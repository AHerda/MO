# Author: Adrian Herda

using JuMP, HiGHS# GLPK Cbc
using ProgressMeter
using Hungarian

function read_file(filename::String)
    file=open(filename, "r")
    lines = readlines(file)
    close(file)

    sizes = split(lines[1])
    n = parse(Int, sizes[1])
    m = parse(Int, sizes[2])
    p = zeros(Float64, n, m)

    for (i, line) in enumerate(lines[3:end])
        columns = split(line)[2:2:end]
        for (j, value) in enumerate(columns)
            p[i, j] = parse(Int, value)
        end
    end

    return p
end

function calc_alpha(p::Matrix{Float64})
    n, m = size(p)
    ts = zeros(Int, m)

    for i in 1:n
        min_val, min_index = findmin(p[i, :])
        ts[min_index] += min_val
    end

    return maximum(ts)
end

function is_solvable(p::Matrix{Float64}, T::Int64)
    n, m = size(p)
    model = Model(HiGHS.Optimizer)

    blocked = [(i, j) for i in 1:n, j in 1:m if p[i, j] > T]
    available_machines = [[j for j in 1:m if p[i, j] <= T] for i in 1:n]
    available_jobs = [[i for i in 1:n if p[i, j] <= T] for j in 1:m]

    # Zmeinna decyzyjna, przyjumje wartość 1 gdy i-te zadanie jest przydzielone do j-tej maszyny
    @variable(model, x[1:n, 1:m] >= 0)

    # Ograniczenia
    # Nie możemy przydzielić zadania do maszyny, jeśli jego czas przekracza T
    @constraint(model, [(i, j) in blocked], x[i, j] == 0)
    # Kazde zadanie musi być przydzielone do jednej maszyny
    @constraint(model, [i in 1:n], sum(x[i, j] for j in available_machines[i]) == 1)
    # Maszyna pracuje przez co najwyżej T jednostek czasu a jej czas pracy to suma czasów zadań przydzielonych do niej
    @constraint(model, [j in 1:m], sum(x[i, j] * p[i, j] for i in available_jobs[j]) <= T)

    set_silent(model)
    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        return true, value.(x)
    else
        return false, nothing
    end
end

function find_min_T(p::Matrix{Float64})
    alpha = calc_alpha(p)
    _, m = size(p)
    left  = floor(Int64, alpha / m)
    right = Int64(alpha)

    while left < right
        mid = floor(Int64, (left + right) / 2)
        print("\tSprawdzanie T = ", mid)
        solvable, _ = is_solvable(p, mid)

        if solvable
            right = mid
            println(" - o")
        else
            left = mid + 1
            println(" - x")
        end
    end

    T = left
    _, x = is_solvable(p, T)

    return T, x
end

function refine_x2(x::Matrix{Float64}, p::Matrix{Float64})
    n, m = size(x)
    x_new = copy(x)

    fractional_jobs = findall(i -> x[i, findfirst(j -> j > 0, x[i, :])] < 1, 1:n)

    if isempty(fractional_jobs)
        # println("Brak zadań ułamkowo przypisanych – nic nie zmieniono.")
        loads = zeros(Float64, m)
        for i in 1:n, j in 1:m
            loads[j] += x[i, j] * p[i, j]
        end

        Cmax = maximum(loads)
        return x, Cmax
    end

    # display(x)
    # display(fractional_jobs)
    # display(x[fractional_jobs, :])

    cost_matrix = zeros(length(fractional_jobs), m)
    for (idx, job) in enumerate(fractional_jobs)
        for machine in 1:m
            cost_matrix[idx, machine] = p[job, machine]
        end
    end

    matching, _ = hungarian(cost_matrix)

    for (local_job_idx, machine_id) in enumerate(matching)
        global_job_id = fractional_jobs[local_job_idx]
        x_new[global_job_id, :] .= 0.0
        x_new[global_job_id, machine_id] = 1.0
    end

    x_new2 = zeros(Int64, n, m)
    for i in 1:n, j in 1:m
        if abs(x_new[i, j] - round(Int64, x_new[i, j])) > 1e-5
            println("Ułamek: ", x_new[i, j], " w zadaniu ", i, " na maszynie ", j)
        end
        x_new2[i, j] = round(Int64, x_new[i, j])
    end
    # x_new = Int64.(round.(x_new))

    loads = zeros(Float64, m)
    for i in 1:n, j in 1:m
        loads[j] += x_new2[i, j] * p[i, j]
    end

    Cmax = maximum(loads)
    # display(x_new[fractional_jobs, :])

    return x_new2, Cmax
end

function refine_x(x::Matrix{Float64}, p::Matrix{Float64}, tol::Float64 = eps(Float64))
    n, m = size(p)

    assign = zeros(Int, n)
    fractional = Int[]
    for i in 1:n
        maxval, jmax = findmax(x[i, :])
        if maxval ≥ 1 - tol

            assign[i] = jmax
        else

            push!(fractional, i)
        end
    end

    H_i2j = Dict{Int, Vector{Int}}()
    H_j2i = Dict{Int, Vector{Int}}(j => Int[] for j in 1:m)
    for i in fractional
        nbrs = Int[]
        for j in 1:m
            if x[i, j] > tol
                push!(nbrs, j)
            end
        end

        if isempty(nbrs)
            _, jmax = findmax(x[i, :])
            push!(nbrs, jmax)
        end
        H_i2j[i] = nbrs
        for j in nbrs
            push!(H_j2i[j], i)
        end
    end

    alive_job     = Dict(i => true for i in fractional)
    alive_machine = Dict(j => !isempty(H_j2i[j]) for j in 1:m)
    degree_m      = Dict(j => length(H_j2i[j]) for j in 1:m)

    leaf_q = Int[]
    for j in 1:m
        if alive_machine[j] && degree_m[j] == 1
            push!(leaf_q, j)
        end
    end

    matched_pairs = Dict{Int, Int}()

    while !isempty(leaf_q)
        j_leaf = pop!(leaf_q)

        if !alive_machine[j_leaf] || degree_m[j_leaf] != 1
            continue
        end

        i_nbrs = [ i for i in H_j2i[j_leaf] if alive_job[i] ]
        @assert length(i_nbrs) == 1 "Machine $j_leaf should have exactly one live neighbor"
        i0 = i_nbrs[1]

        matched_pairs[i0]       = j_leaf
        alive_job[i0]           = false
        alive_machine[j_leaf]   = false

        for j2 in H_i2j[i0]
            if alive_machine[j2]
                filter!(ii -> ii != i0, H_j2i[j2])
                degree_m[j2] = length(H_j2i[j2])
                if degree_m[j2] == 1
                    push!(leaf_q, j2)
                end
            end
        end

        H_i2j[i0]     = Int[]
        H_j2i[j_leaf] = Int[]
    end

    visited_job     = Dict(i => false for i in fractional)
    visited_machine = Dict(j => false for j in 1:m)

    for i_start in fractional
        if !alive_job[i_start] || visited_job[i_start]
            continue
        end

        cycle_nodes = Int[]
        current_i   = i_start

        alive_nbrs = [ j for j in H_i2j[current_i] if alive_machine[j] ]
        if isempty(alive_nbrs)
            visited_job[current_i] = true
            continue
        end
        j_next = alive_nbrs[1]

        while true
            push!(cycle_nodes, current_i)
            push!(cycle_nodes, j_next)
            visited_job[current_i]     = true
            visited_machine[j_next]    = true

            next_jobs = [ i2 for i2 in H_j2i[j_next] if alive_job[i2] && !visited_job[i2] ]
            if isempty(next_jobs)
                break
            end
            current_i = next_jobs[1]

            next_machs = [ j2 for j2 in H_i2j[current_i] if alive_machine[j2] && !visited_machine[j2] ]
            if isempty(next_machs)
                break
            end
            j_next = next_machs[1]
        end

        for idx in 1:2:length(cycle_nodes)
            i_cycle = cycle_nodes[idx]
            j_cycle = cycle_nodes[idx + 1]
            matched_pairs[i_cycle]     = j_cycle
            alive_job[i_cycle]         = false
            alive_machine[j_cycle]     = false
        end
    end

    for (i, j) in matched_pairs
        assign[i] = j
    end

    for i in 1:n
        if assign[i] == 0
            _, jmin = findmin(p[i, :])
            assign[i] = jmin
        end
    end

    x_final = zeros(Int, n, m)
    loads   = zeros(Float64, m)
    for i in 1:n
        j_assigned = assign[i]
        x_final[i, j_assigned] = 1
        loads[j_assigned]     += p[i, j_assigned]
    end

    Cmax = maximum(loads)
    return x_final, Cmax
end

function check_solution(x::Matrix{Int64}, p::Matrix{Float64}, T::Float64)
    n, m = size(p)

    # Sprawdzenie, czy każde zadanie jest przydzielone do jednej maszyny
    for i in 1:n
        if sum(x[i, :]) != 1
            return false, "Zadanie $(i) nie jest przydzielone do jednej maszyny."
        end
    end

    # Sprawdzenie, czy każda maszyna nie przekracza czasu T
    for j in 1:m
        if sum(x[i, j] * p[i, j] for i in 1:n) > T
            return false, "Maszyna $(j) przekracza czas T."
        end
    end

    return true, "Rozwiązanie jest poprawne."
end

function process_file(filename::String)
    p = read_file(filename)
    n, _ = size(p)

    T, x = find_min_T(p)
    @assert(!isnothing(x), "Nie znaleziono rozwiązania")
    print("\t\tRefining solution $(T)")
    # x, T = refine_x(x, p, 1e-5)
    x, T = refine_x(x, p)
    println(" -> $(T)")

    is_valid, message = check_solution(x, p, T)
    if !is_valid
        @warn "Rozwiązanie nie jest poprawne: $(message)"
        for i in 1:n
            if sum(x[i, :]) != 1
                display(x[i, :])
            end
        end
    end

    return T, x
end

function find_real_solution(filename::String)

    solution_filename = replace(filename, ".txt" => "CPLEX.txt")
    solution_filename = replace(solution_filename, "data/" => "data/s")
    if !isfile(solution_filename)
        error("Plik z rozwiązaniem nie istnieje: $(solution_filename)")
    end

    cmax = zero(Float64)

    open(solution_filename, "r") do file
        for line in eachline(file)
            if occursin("Cmax", line)
                cmax = parse(Float64, rsplit(line, " ", limit=2)[end])
                break
            end
        end
    end
    if cmax == zero(Float64)
        @warn "Nie znaleziono wartości Cmax w pliku $(solution_filename)"
        return nothing
    end
    return cmax
end

function main()
    results_file = "results.csv"
    folders = [
      "instancias1a100","instancias100a120","instancias100a200",
      "instanciasde10a100","Instanciasde1000a1100","JobsCorre","MaqCorre"
    ]
    filenames = String[]


    for folder in folders
        if !isdir("data/" * folder)
            error("Folder $(folder) nie istnieje.")
        else
            for file in readdir("data/" * folder)
                if endswith(file, ".txt")
                    push!(filenames, "data/" * folder * "/" * file)
                else
                    error("Nieprawidłowy format pliku: ", file)
                end
            end
        end
    end

    # println(filenames)
    # open(results_file, "w") do file
    #     write(file,
    #       "subfolder,filename,jobs,machines,T_star,Cmax,ratio_lp"
    #     )
    # end

    last_good = "data/instancias100a200/1046.txt"
    idx = findfirst(filenames .== last_good)

    @showprogress 1 "Solving" for filename in filenames#[idx:idx]
        println("Przetwarzanie pliku: ", filename)
        T_star, x = process_file(filename)
        n, m = size(x)

        Cmax = find_real_solution(filename)
        @assert(!isnothing(Cmax), "Nie znaleziono rozwiązania w pliku $(filename)")
        ratio_lp = T_star / Cmax

        subfolder = split(filename, "/")[2]
        file_name = split(filename, "/")[3]

        open(results_file, "a") do file
            write(file, "\n$(subfolder),$(file_name),$(n),$(m),$(T_star),$(Cmax),$(ratio_lp)")
        end
    end
end

main()

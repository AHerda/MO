# Author: Adrian Herda

using JuMP
import Cbc

# Wczytanie danych
include("data1.jl")

# Funkcja generująca wszystkie możliwe kombinacje szerokości w celu podziału standardowej szerokości na mniejsze szerokości
function possible_divides(standard::Int, widths::Vector{Int})
    combination = zeros(Int, length(widths))
    result = [ append!(copy(combination), [standard]) ]
    flag = true
    while flag
        for i in eachindex(combination)
            combination[i] += 1
            sum = combination' * widths

            if sum <= standard
                temp_vec = copy(combination)
                push!(temp_vec, standard - sum)
                push!(result, temp_vec)
                break
            else
                if i == length(combination)
                    flag = false
                    break
                end
                combination[i] = 0
            end
        end

    end
    return result
end

all_possible = possible_divides(std_width, widths)

# Model
model = Model(Cbc.Optimizer)

# Zmienna decyzyjna x[i] oznacza liczbę wzorów i-tego typu
@variable(model, x[1:length(all_possible)] >= 0, Int)

# Ograniczenie dotyczące zaspokojenia popytu dla każdego z typów szerokości
@constraint(model, [i in eachindex(widths)], sum(x[j] * all_possible[j][i] for j in eachindex(all_possible)) >= demand[i])

# Funckaj celu minimalizująca resztki po cięciach desek
@objective(model, Min, sum(x))

# Rozwiązanie problemu
optimize!(model)

# Wyświetlenie wyników
println("Funkcja celu: ", objective_value(model))
println("Ilość resztek: ", sum(value.(x)) * std_width - sum(demand .* widths))
println("Ilość wyciętych wzorów: ")
for p in eachindex(all_possible)
    xp = value(x[p])
    if xp > 1e-6
        println("\tWzór ", all_possible[p], " × ", Int(xp))
    end
end
println("Wyprodukowanych desek: ")
all = sum(all_possible .* value.(x))
for i in eachindex(widths)
    println("\tSzerokość ", widths[i], " × ", Int(all[i]))
end

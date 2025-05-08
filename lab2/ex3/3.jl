# Author: Adrian Herda

using JuMP, Cbc

# Wczytanie danych
include("data3.jl")

# Model
model = Model(Cbc.Optimizer)

# Zmienne decyzyjne
# x[n, t, m] =  oznacza że j to czas rozpoczęcia n-tego zadania na m-tej maszynie
@variable(model, x[1:N, 1:T, 1:M], Bin)
# C_max oznacza maksymalny czas zakończenia zadań
@variable(model, C_max >= 0)

# Ograniczenia
# Każde zadanie musi być zakończone przed C_max
@constraint(model, [n in 1:N, m in 1:M], sum((t - 1 + P[n]) * x[n, t, m] for t in 1:T) <= C_max)
# Zadania są wykonywane dokładnie raz
@constraint(model, [n in 1:N], sum(x[n, t, m] for t in 1:T, m in 1:M) == 1)
# Warunki poprzedzania muszą być spełnione
@constraint(model, [(i, j) in R], sum((t + P[i]) * x[i, t, m] for t in 1:T, m in 1:M) <= sum(t * x[j, t, m] for t in 1:T, m in 1:M))
# Zadania nie mogą na siebie nachodzić
@constraint(model, [t in 1:T, m in 1:M], sum(x[n, t2, m] for n in 1:N, t2 in max(1, t + 1 - P[n]):t) <= 1)

# Funkcja celu
# Minimalizacja maksymalnego czasu zakończenia zadań
@objective(model, Min, C_max)

# Rozwiązanie modelu
optimize!(model)

x = value.(x)

# Wyświetlenie wyników
println("Funkcja celu: ", objective_value(model))
println("Rozwiązanie : ")
for n in 1:N
    for t in 1:T
        for m in 1:M
            if value(x[n, t, m]) > 0.5
                println("Zadanie ", n, " zaczyna się w ", t - 1, " na maszynie ", m)
            end
        end
    end
end
println("Rozkład zadań na maszyny: ")
println("\t   | 0123456789")
println("========================")
for m in 1:M
    print("\tM", m, " | ")
    for t in 1:round(Int, value(C_max))
        ch = "."
        for n in 1:N
            if sum(x[n, max(1, t + 1 - P[n]):t, m]) > 0.5
                ch = Char('0' + n)
            end
        end
        print(ch)
    end
    println()
end

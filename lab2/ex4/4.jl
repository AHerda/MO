# Author: Adrian Herda

using JuMP, Cbc

# Wczytanie danych
include("data4.jl")

T_max = sum(T) + 1

# Model
model = Model(Cbc.Optimizer)

# Zmienne decyzyjne
# x[n, t] = 1 oznacza że t to czas rozpoczęcia n-tego zadania
@variable(model, x[1:n, 1:T_max], Bin)
# C_max oznacza maksymalny czas zakończenia zadań
@variable(model, C_max >= 0)

# Ograniczenia
# C_max to maksymalny czas zakończenia wszystkich zadań
@constraint(model, [j in 1:n], sum((t - 1 + T[j]) * x[j, t] for t in 1:T_max) <= C_max)
# Zadania są wykonywane dokładnie raz
@constraint(model, [j in 1:n], sum(x[j, :]) == 1)
# Warunki poprzedzania muszą być spełnione
@constraint(model, [(i, j) in R], sum((t + T[i]) * x[i, t] for t in 1:T_max) <= sum(t * x[j, t] for t in 1:T_max))
# Zadania nie mogą przekraczać limitu zasobów
@constraint(model, [t in 1:T_max, i in 1:p], sum(x[j, s] * r[j][i] for j in 1:n, s in max(1, t + 1 - T[j]):t) <= N[i])

# Funkcja celu
# Minimalizacja maksymalnego czasu zakończenia zadań
@objective(model, Min, C_max)

# Rozwiązanie modelu
optimize!(model)


# Wyświetlenie wyników
x = Int.(round.(Int, value.(x)))
# W powyższym rozwiązaniu czas zaczyna się od 1 sekundy więc doejmujemy 1 aby przekonwertować to na informatyczne standardy
C_max = Int(ceil(value.(C_max))) - 1

s = [ sum(t * x[j, t] for t in 1:T_max) for j in 1:n ]
println("\n  Optymalny makespan Cmax = ", value(C_max), "\n")
for j in 1:n
    println("Zadanie $j: start = ", s[j],
            ", koniec = ", s[j] - 1 + T[j])
end

# ——— ASCII-GANTT ———
println("\nGANTT (zadania × czas 0…$(C_max - 1)):")
for j in 1:n
    line = ""
    for tau in 1:C_max
        line *= (s[j] ≤ tau < s[j] + T[j] ? "█" : "·")
    end
    println(lpad("j=$j",4), " | ", line)
end

# profil zasobów
println("\nProfil zasobów (interwały czasu ze stałym użyciem):")
# zbieramy wszystkie punkty startu i zakończenia
events = sort(unique(vcat(s, [s[j] + T[j] for j in 1:n])))
for k in 1:length(events)-1
    t0 = events[k]
    t1 = events[k+1]
    # obliczamy ile zasobu użyte w całym [t0, t1)
    usage = sum(r[j,1] for j in 1:n if s[j] < t1 && s[j] + T[j] > t0)
    println(" t ∈ [", lpad(t0,3), ", ", lpad(t1,3), "): ",
            lpad(usage,2), "/", N[1])
end

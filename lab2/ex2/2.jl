# Author: Adrian Herda

using JuMP, Cbc

include("data2.jl")

# Dodatkowa dana określająca najdłuższy mozłliw bezpieczny czas do wykonania wszystkich zadań
T = sum(P) + maximum(R) + 1

# Model
model = Model(Cbc.Optimizer)

# Zmienna decyzyjna określające czas zakończenia zadań i kolejność wykonywania zadań C[i, j] == 1 <=> zadanie i kończy się w czasie j
@variable(model, C[1:N, 1:T], Bin)

# Ograniczenia
# Każde zadanie wykonywane jest dokładnie raz
@constraint(model, [n in 1:N], sum(C[n, :]) == 1)
# Rozpoczynanie zadań najwcześniej w czasie zapisanym w R
@constraint(model, [n in 1:N], sum((t - P[n]) * C[n, t] for t in 1:T) >= R[n])
# Zadania nie mogą na siebie nachodzić
@constraint(model, [t in 1:T], sum(C[n,s] for n in 1:N, s in t:min(T, t - 1 + P[n])) <= 1)

# Funckja celu
# Minimalizacja sumy wag pomonożonych przez czas zakończenia zadań
@objective(model, Min, sum(W[n] * sum(t * C[n, t] for t in 1:T) for n in 1:N))

# Rozwiązanie modelu
optimize!(model)

# Wyświetlenie wyników
C = value.(C)

println("Funkcja celu: ", objective_value(model))

println("Rozwiązanie : ")
for n in 1:N
    for t in 1:T
        if C[n,t] > 0.5
            println("Zadanie ", n, " kończy się w ", t - 1)
        end
    end
end

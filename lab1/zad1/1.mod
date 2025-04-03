# Adrian Herda

# Wymiar
param n >= 1;

# Indeksy dla ułatwienia
set N := {1..n};

# podane w zadniu wartości parametrów
param A{i in N, j in N} := 1 / (i + j - 1);
param b{i in N} := sum{j in N} A[i,j];
param c{i in N} := b[i];

# --- Zmienne decyzyjjne ---
# Wektor zmiennych zadany w treści zadania
var x{i in N} >= 0;

# --- funkcja kosztu ---
# Funkcja kosztu - min c^T * x
minimize cost_func: sum{i in N} c[i] * x[i];

# --- Ograniczenia ---
# Ograniczenia - Ax = b
s.t. ogran{i in N}:
    sum{j in N} A[i,j] * x[j] = b[i];

solve;

# display x;
display cost_func;

# Sprawdzanie błędu
param err := sqrt(sum{i in N} (x[i] - 1)^2) / sqrt(n);
display err;

end;

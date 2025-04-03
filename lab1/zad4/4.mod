# Adrian Herda

set zajecia;
set grupy;
set grupy_wf;

param czas_start {g in grupy, z in zajecia} >= 0;
param czas_koniec {g in grupy, z in zajecia} >= 0;
param dzien {g in grupy, z in zajecia} >= 0 integer;

param czas_start_wf {g in grupy_wf} >= 0;
param czas_koniec_wf {g in grupy_wf} >= 0;
param dzien_wf {g in grupy_wf} >= 0 integer;

param pkt {g in grupy, z in zajecia} >= 0 integer;

# --- zmienne decyzyjne ---
# Zmienn wybranych zajęć
var wybrane {g in grupy, z in zajecia} binary;
# Wybrane zajęcia sportowe
var wybrane_wf {grupy_wf} binary;

# --- Funkcja kosztu ---
# maksymalizuje punkty wygody wybrancyh zajęć
maximize pkt_suma: sum {g in grupy, z in zajecia} (pkt[g, z] * wybrane[g, z]);

# --- Ograniczenia ---
# mkasymalnie jedna grupa wybrana na zjęcia
s.t. jedna_grupa_na_kurs {z in zajecia}: sum {g in grupy} wybrane[g, z] = 1;
#minimalnie jedne zajęcia sportowe
s.t. min_jeden_trening: sum {g in grupy_wf} wybrane_wf[g] >= 1;
#maksymalnie 4h ćwiczeń dziennie
s.t. max_4h_dziennie {d in 1..5}: sum {g in grupy, z in zajecia : dzien[g, z] = d} (
    (czas_koniec[g,z] - czas_start[g,z]) * wybrane[g, z]
) <= 4;

# zajęcia nie mogą na siebie nachodzić
s.t. brak_nachodzenia {g1 in grupy, g2 in grupy, z1 in zajecia, z2 in zajecia :
    (g1 != g2 or z1 != z2) and
    dzien[g1, z1] = dzien[g2, z2] and
    czas_start[g1, z1] <= czas_start[g2, z2] and
    czas_start[g2, z2] <= czas_koniec[g1, z1] }:
        wybrane[g1, z1] + wybrane[g2, z2] <= 1;

# wf nie może nachodzić na zajęcia
s.t. brak_nachodzenia_wf {g in grupy, z in zajecia, g_wf in grupy_wf:
    dzien[g,z] = dzien_wf[g_wf] and (
        (
            czas_start_wf[g_wf] <= czas_start[g,z] and
            czas_start[g,z] <= czas_koniec_wf[g_wf]
        ) or
        (
            czas_start[g,z] <= czas_start_wf[g_wf] and
            czas_start_wf[g_wf] <= czas_koniec[g,z]
        )
    )}:
        wybrane[g,z] + wybrane_wf[g_wf] <= 1;

# Wymagane 1h przerwy na obiad w stołówce otwartej tylko i wyłącznie 12-14
s.t. przerwa_obiad {d in 1..5}:
    (sum {g in grupy, c in zajecia : dzien[g,c] = d and czas_start[g,c] < 12 and czas_koniec[g,c] <= 14} (czas_koniec[g,c] - 12) * wybrane[g,c])
    + (sum {g in grupy, c in zajecia : dzien[g,c] = d and czas_start[g,c] >= 12 and czas_koniec[g,c] <= 14} (czas_koniec[g,c] - czas_start[g,c]) * wybrane[g,c])
    + (sum {g in grupy, c in zajecia : dzien[g,c] = d and czas_start[g,c] >= 12 and czas_koniec[g,c] > 14} (14 - czas_start[g,c]) * wybrane[g,c])
    + (sum {g in grupy_wf: dzien_wf[g] = d and czas_start_wf[g] < 12 and czas_koniec_wf[g] <= 14} (czas_koniec_wf[g] - 12) * wybrane_wf[g])
    + (sum {g in grupy_wf: dzien_wf[g] = d and czas_start_wf[g] >= 12 and czas_koniec_wf[g] <= 14} (czas_koniec_wf[g] - czas_start_wf[g]) * wybrane_wf[g])
    + (sum {g in grupy_wf: dzien_wf[g] = d and czas_start_wf[g] >= 12 and czas_koniec_wf[g] > 14} (14 - czas_start_wf[g]) * wybrane_wf[g]) <= 1;

# dodatkowe warunki
# brak zajęć w środę i piątek
s.t. wolna_sroda {g in grupy, z in zajecia : dzien[g,z] = 3 or dzien[g,z] = 5} : wybrane[g,z] = 0;
# zajęcia o preferencji nie mniejszej niż 5
s.t. pkt_min_5 {g in grupy, z in zajecia : pkt[g,z] < 5 } : wybrane[g,z] = 0;

solve;

printf "Total preference: %d\n", pkt_suma;
printf{g in grupy, z in zajecia : wybrane[g,z] = 1}:
    "Take course %s with group %s on %d, starting: %f and ending: %f\n", z, g, dzien[g,z], czas_start[g,z], czas_koniec[g,z];
printf{g in grupy_wf: wybrane_wf[g] = 1}:
    "Train on day %d between %d and %d\n", dzien_wf[g], czas_start_wf[g], czas_koniec_wf[g];

end;

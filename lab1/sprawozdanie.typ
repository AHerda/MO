#set heading(numbering: "1.")
#set text(lang: "pl")
#set text(font: "Libertinus Math")



#align(top + center)[
  #text(size: 24pt, [Metody Optymalizacji \ Laboratorium 1])

  Adrian Herda

  #datetime.today().display()
]
= Zadanie 1
== Model
=== Zmienne decyzyjne
- $n in NN$ - Wymiar problemu

- $x = vec(x_1,x_2,...,x_n) gt.eq 0$

=== Ograniczenia
$ A x = b $
gdzie:
- $a_(i j) = 1 / (i + j - 1)$, dla $i, j, = 1, ... , n$

- $b_i = sum_(j=1)^n (1 / (i + j -1))$,   dla $i, j, = 1, ... , n$

== Funkcja kosztu
$ min c^T x = sum_(i = 1)^n c_i dot x_i $
gdzie:
- $c_i = sum_(j=1)^n (1 / (i + j -1))$,   dla $i, j, = 1, ... , n$

== Wyniki

Prawidłowym rozwiązaniem jest $x=1$. Skoro znamy już ten wynik, bardziej interesujące będzie przeanalizowanie błędów względnych by lepiej zobrazować co się dzieje.
$ e r r o r= (||x - hat(x)||_2) / (||x||_2) $
#align(center)[
  #table(
    columns: (auto, auto),
    inset: 5pt,
    table.header([*n*], [*error*]),
    $1$,$0$,
    $2$,$1.05325004057301 dot 10^(-15)$,
    $3$,$3.67157765110227 dot 10^(-15)$,
    $4$,$3.27016385075681 dot 10^(-13)$,
    $5$,$3.35139916635905 dot 10^(-12)$,
    $6$,$6.83335790676898 dot 10^(-11)$,
    $7$,$1.67868542192291 dot 10^(-08)$,
    $8$,$0.514058972177268$,
    $9$,$0.682911338087722$,
    $10$,$0.990387574803086$
  )
]

#align(center)[
  #table(
    columns: (auto, auto),
    inset: 5pt,
    table.header([*n*], [*Funkcja kosztu*]),
    $1$,$1$,
    $2$,$2.33333333333333$,
    $3$,$3.7$,
    $4$,$5.07619047619048$,
    $5$,$6.45634920634921$,
    $6$,$7.83852813852814$,
    $7$,$9.22187257187257$,
    $8$,$10.6059496062796$,
    $9$,$11.9905168356488$,
    $10$,$13.37542804637291$
  )
]

== Wnioski

Zadanie szukania zadanego wektora jest źle uwarunkowane, ponieważ do jego liczenia jest potrzebna macierz Hilberta.

Błąd względny dla wymiaru $n=7$ jest jeszcze wyjątkowo mały ale już dla $n=8$ błąd ten wynosi prawie $0.5$

= Zadanie 2

Zadanie opisuje problem optymalnego przemieszczenia dźwigów między miastami aby zniwelować zapotrzebowania w miastach wykorzystując nadmiary w innych miastach

== Model
=== Zmienne decyzyjne

- $m o v I_(m 1, m 2)$ - liczba dźwigów typu I przeniesiona z miasta m1 do miasta m2,
- $m o v I I_(m 1, m 2)$ - liczba dźwigów typu II przeniesiona z miasta m1 do miasta m2,
- $m o v I I I_(m 1, m 2)$ - liczba dźwigów typu II przeniesiona z miasta m1 do miasta m2 w celu zastąpienia dźwigów typu I,

=== Ograniczenia

+ Ograniczenie przenoszonych dźwigów wedle nadmiarów
  - $sum_(m 2 in M) m o v I_(m 1,m 2) lt.eq s u r p I_(m 1)$

  - $sum_(m 2 in M) (m o v I I_(m 1,m 2) + m o v I I I_(m 1,m 2)) lt.eq s u r p I I_(m 1)$

+ Ograniczenie przenoszonych dźwigów wedle braków
  - $sum_(m 1 in M) (m o v I_(m 1,m 2) + m o v I I I_(m 1,m 2)) gt.eq s h o r t I_(m 2)$

  - $sum_(m 1 in M) m o v I I_(m 1,m 2) gt.eq s u r p I I_(m 2)$
\

== Funkcja kosztu

Minimalizujemy koszt związany z transportem

$ min sum_(m 1, m 2 in M) (d i s t_(m 1, m 2) dot m o v I_(m 1, m 2) + 1.2 dot d i s t_(m 1, m 2) dot (m o v I I_(m 1, m 2) + m o v I I I_(m 1, m 2)))$

== Wyniki

#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 5pt,
    table.header([z], [do], [ile] ,[typ dźwigu]),
    [Opole],[[Brzeg]], $4$, [I],
    [Opole],[Kędzierzyn-Koźle], $3$, [I],
    [Nysa],[Brzeg], $5$, [I],
    [Nysa],[Prudnik], $1$, [I],
    [Strzelce Opolskie],[Kędzierzyn-Koźle], $5$, [I],
    [Nysa],[Opole], $2$, [II],
    [Prudnik],[Strzelce Opolskie], $4$, [II],
    [Prudnik],[Kędzierzyn-Koźle],$2$, [II],
    [Prudnik],[Racibórz], $1$, [II],
    [Brzeg],[Brzeg], $1$, [II zmiana na I],
    [Prudnik],[Prudnik], $3$, [II zmiana na I]
  )
]

Całkowity koszt wyniósł 1400.44 jakimi posługiwał się twórca zadania. Pozbycie się warunku na całkowitoliczbowość zmiennych decyzyjnych nie wpływa na końcowy wynik. Solver widocznie lubi wykorzystanie dźwigów typu II jako typu I bez zmiany miasta przez to że nie wprowadza to żadnych kosztów związanych z przewozem. Zapotrzebowanie na dźwigi zostało zlikwidowane w optymalny sposób.

= Zadanie 3

Zadanie to polegało na optymalizacji kosztów rafinerii tworzącej 3 rodzaje paliw z dwóch rodzajów ropy. Rafineria wykorzystuje destylacje i krakowanie jako metody tworzenia paliw.

== Model

- $R = {"B1, B2"}$ - rodzaje ropy
- $P_d = {"benzyna, olej, destylat, reszta"}$ - produkty destylacji
- $P_k = {"benzyna, olej, reszta"}$ - produkty krakowania destylatu
- $W_o = {"domowe, ciezkie"}$ - wykorzystanie oleju z destylacji
- $W_d = {"krak, ciezkie"}$ - wykorzystanie destylatu
=== Parametry

- $"wydajnosc"_(r,p)$ - wydajność destylacji ropy określająca ile produktu $p in P_d$ zostało stworzonego z ropy $r in R$
- $"wydajnosc_krak"_(p)$ - wydajność krakowania destylatu określająca ile produktu $p in P_k$ zostało stworzonego
- $"desty_siarka"_r$ - udział siarki w oleju pozyskanego z destylacji ropy $r in R$
- $"krak_siarka"_r$ - udział siarki w oleju pozyskanego z krakowania destylatu ropy $r in R$

=== Zmienne decyzyjne

- $"ropa"_r$, $r in R$ -- ilość ton zakupionej oraz przetwarzanej ropy $B 1$ oraz $B 2$
- $"olej"_(r, c)$, $r in R$, $c in W_o$ -- określa ilość, w tonach, oleju z każdego rodzaju ropy idącego do paliw domowych i ciężkich
- $"desty"_(r, c)$, $r in R$, $c in W_d$ -- określa ilość, w tonach, destylatu z każdego rodzaju ropy idącego do krakowania i paliw ciężkich

=== Ograniczenia

- Suma oleju wyprodukowanego z danego typu ropy musi równać się sumie ton oleju wykorzystywanego do różnych celów
$ forall_(r in R)("wydajnosc"_(r, "olej") dot "ropa"_r = sum_(w in W_o) "olej"_(r,w)) $

- Suma destylatu wyprodukowanego z danego typu ropy musi równać się sumie ton destylatu wykorzystywanego do różnych celów
$ forall_(r in R)("wydajnosc"_(r, "destylat") dot "ropa"_r = sum_(w in W_d) "desty"_(r,w)) $

- Ilość wyprodukowanych paliw silnikowych nie może być mniejsza niż podane w zadaniu $"min"_s = 200000$ na ilość wyprodukowanego paliwa składa się benzyna z destylacji oraz benzyna z krakowania destylatu
$ sum_(r in R)("wydajnosc_krak"_("benzyna") dot "desty"_(r, "krak") + "wydajnosc"_(r, "benzyna") dot "ropa"_r) gt.eq "min"_s $

- Ilość wyprodukowanych paliw olejowych nie może być mniejsza niż podane w zadaniu $"min"_o = 400000$ na ilość wyprodukowanego paliwa składa się część oleju z destylacji oraz olej z krakowania destylatu
$ sum_(r in R)("wydajnosc_krak"_("olej") dot "desty"_(r, "krak") + "olej"_(r, "domowe")) gt.eq "min"_o $

- Ilość wyprodukowanych paliw ciężkich nie może być mniejsza niż podane w zadaniu $"min"_c = 250000$ na ilość wyprodukowanego paliwa składa się część oleju z destylacji, część destylatu, resztki destylacji oraz resztki z krakowania destylatu
$ sum_(r in R)("wydajnosc_krak"_("reszta") dot "desty"_(r, "krak") + "desty"_(r, "reszta") + "olej"_(r, "ciezkie") + "wydajnosc"_(r, "reszta") dot "ropa"_r) gt.eq "min"_c $

- Wyprodukowane paliwa olejowe nie mogą mieć więcej niż $max_s = 0.5%$ siarki w swoim składzie. Skład siarki w podawany jest przez parametry desty_siraka oraz krak_siarka
$ sum_(r in R)("desty_siarka"_r dot "olej"_(r, "ciezkie") + "krak_siarka"_r dot "wydajnosc_krak"_(r, "olej") dot "desty"_(r, "krak")) lt.eq\ "max"_s dot  sum_(r in R)("wydajnosc_krak"_("olej") dot "desty"_(r, "krak") + "olej"_(r, "domowe")) $

== Funkcja kosztu

- $C_(B 1) = 1300$ - koszt tony ropy B1
- $C_(B 2) = 1500$ - koszt tony ropy B2
- $C R_1 = 10$ - koszt destylacji ropy
- $C R_2 = 20$ - koszt krakowania destylatu

Chcemy zminimalizować koszty produkcji paliw:

$ min sum_(r in R) ("ropa"_r * (C_r + C R_1) + C R_2 * "desty"_(r, "krak")) $

== Wyniki

Optymalnym rozwiązaniem okazuje się zakup wyłącznie tańszej ropy B1. Ta ropa nie dość że jest tańsza w kupnie jak i w obróbce ale ma również mniejszą zawartość siarki.
- Kupujemy $1026030.37$ ton ropy B1
- $381561.37$ ton oleju z destylacji idzie na cele paliw olejowych
- $28850.325$ ton oleju z destylacji idzie na cele paliw ciężkich
- $91190.89$ ton destylatu idzie do krakowania
- $61713.67$ ton destylatu idzie na cele paliw ciężkich

Całkowity koszt wyniósł $1345943600.87\$ $

= Zadanie 4

Zadanie polegało na znalezieniu optymalnego planu ćwiczeń wedle godzin i ocen zajęć podanych w treści zadania. Dodatkowo w plan trzeba było zmieścić godzinną przerwę w godzinach 12 - 14 a także zajęcia sportowe co najmniej raz w tygodniu.

== Model
- $"Zaj" = {"algebra, analiza, fizyka, chemia_minerałów, chemia_organiczna"}$ - Zbiór wszystkich ćwiczeń
- $"Gr" = {"gr1, gr2, gr3, gr4"}$ - grupy ćwiczeniowe z których można wybierać
- $"Gr_wf" = {"gr1, gr2, gr3"}$ - grupy zajęć sportowych z których można wybierać

=== Parametry
- $"Start"_(z, g)$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat godzin o których zajęcia się zaczynały
- $"Koniec"_(z, g)$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat godzin o których zajęcia się kończyły
- $"Dzien"_(z, g) in [1,2,3,4,5]$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat dni w których zajęcia się odbywały
- $"Pkt"_(z, g)$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat preferencji co do zajęć

- $"Start_wf"_(z, g)$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat godzin o których zajęcia sportowe się zaczynały
- $"Koniec_wf"_(z, g)$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat godzin o których zajęcia sportowe się kończyły
- $"Dzien_wf"_(z, g) in [1,2,3,4,5]$, $z in "Zaj", g in "Gr"$ - macierz zawierająca informacje na temat dni w których zajęcia sportowe się odbywały

=== Zmienne decyzyjne

- $"Wybrane"_(z, g) in [0, 1]$, $z in "Zaj", g in "Gr"$ - Macierz określająca które zajęcia wybraliśmy
  - $1$ - oznacza wybranie zajęć
  - $0$ - oznacza nie wybranie zajęć

- $"Wybrane_wf"_(z, g) in [0, 1]$, $z in "Zaj", g in "Gr"$ - Macierz określająca które zajęcia sportowe wybraliśmy
  - $1$ - oznacza wybranie zajęć
  - $0$ - oznacza nie wybranie zajęć

=== Ograniczenia

+ Z każdego przedmiotu możemy wybrać tylko jedną grupę
  $ forall_(z in "Zaj") (sum_(g in "Gr") "Wybrane"_g = 1) $
+ Z wf musimy wybrać minimalnie jedną grupę
  $ sum_(g in "Gr_wf") "Wybrane_wf"_g >= 1 $
+ Możemy mieć maksymalnie 4h ćwiczeń dziennie
  $ forall_(d in [5]) (sum_(g in "Gr", z in "Zaj", "Dzien"_(z, g) = d) ("Koniec"_(z,g) - "Start"_(z, g))<= 4) $
+ Zajęcia nie mogą się zaczynać w trakcie innych zajęć - sprawdzamy to poprzez porównywanie czasu rozpoczęcia i zakończenia par zajęć, jeśli czas rozpoczęcia jednych zajęć zawiera się w pomiędzy granicami innych zajęć to wybrać możemy co najwyżej jedne z nich
  $ (forall_(z 1, z 2 in "Zaj"))(forall_(g 1, g 2 in "Gr")) \ ((z 1, g 1) != (z 2, g 2) and "Dzien"_(z 1, g 1) = "Dzien"_(z 2, g 2) and "Start"_(z 1, g 1) <= "Start"_(z 2, g 2) and "Start"_(z 2, g 2) <= "Koniec"_(z 1, g 1)) \ arrow.double.long "Wybrane"_(z 1, g 1) + "Wybrane"_(z 2, g 2) <= 1 $
+ Podobnie treningi nie mogą się zaczynać w trakcie ćwiczeń
  $ (forall_(z in "Zaj"))(forall_(g in "Gr"))(forall_(g^"wf" in "Gr_wf")) \ ("Dzien"_(z, g) = "Dzien_wf"_(g^"wf") and "Start"_(z, g) <= "Start_wf"_(g^"wf") and "Start_wf"_(g^"wf") <= "Koniec"_(z, g)) \ arrow.double.long "Wybrane"_(z, g) + "Wybrane_wf"_(g^"wf") <= 1 $
+ Ani nie mogą się kończyć w trakcie ćwiczeń
  $ (forall_(z in "Zaj"))(forall_(g in "Gr"))(forall_(g^"wf" in "Gr_wf")) \ ("Dzien"_(z, g) = "Dzien_wf"_(g^"wf") and "Start_wf"_(g^"wf") <= "Start"_(z, g) and "Start"_(z, g)) <= "Koniec_wf"_(g^"wf") \ arrow.double.long "Wybrane"_(z, g) + "Wybrane_wf"_(g^"wf") <= 1 $
+ Ćwiczenia muszą zostawić godzinę przerwy w godzinach 12-14 na obiad na stołówce
  $
  (forall_(d in [5])) \
  sum_(g in "Gr", z in "Zaj", "Dzien"_(z, g) = d, "Start"_(z, g) < 12, "Koniec"_(z, g) <= 14)(("Koniec"_(z,g) - 12) dot "Wybrane"_(z,g)) + \
  sum_(g in "Gr", z in "Zaj", "Dzien"_(z, g) = d, "Start"_(z, g) >= 12, "Koniec"_(z, g) <= 14)(("Koniec"_(z,g) - "Start"_(z,g)) dot "Wybrane"_(z,g)) + \
  sum_(g in "Gr", z in "Zaj", "Dzien"_(z, g) = d, "Start"_(z, g) >= 12, "Koniec"_(z, g) > 14)((14 - "Start"_(z,g)) dot "Wybrane"_(z,g)) + \
  sum_(g in "Gr_wf", "Dzien_wf"_(g) = d, "Start_wf"_(g) < 12, "Koniec_wf"_(g) <= 14)(("Koniec_wf"_g - 12) dot "Wybrane_wf"_(g)) + \
  sum_(g in "Gr_wf", "Dzien_wf"_(g) = d, "Start_wf"_(g) >= 12, "Koniec_wf"_(g) <= 14)(("Koniec_wf"_g - "Start_wf"_(g)) dot "Wybrane_wf"_(g)) + \
  sum_(g in "Gr_wf", "Dzien_wf"_(g) = d, "Start_wf"_(g) >= 12, "Koniec_wf"_(g) > 14)((14 - "Start_wf"_(g)) dot "Wybrane_wf"_(g)) <= 1
  $

=== Ograniczenia dodatkowe <ogr_dod>
+ Brak ćwiczeń w środy oraz 5
  $ (forall_(g in "Gr", z in "Zaj")) ("Dzien"_(z, g) in {3, 5} arrow.double.long "Wybrane"_(z,g) = 0) $
+ Brak ćwiczeń o preferencji mniejszej niż 5
  $ (forall_(g in "Gr", z in "Zaj")) ("Pkt"_(z, g) lt.eq 5 arrow.double.long "Wybrane"_(z,g) = 0) $

== Funkcja kosztu

Naszym celem jest zmaksymalizowanie wybieranie preferowanych ćwiczeń. W tym celu maksymalizujemy sumę preferencji wszystkich wybranych ćwiczeń

$ max sum_(g in "Gr", z in "Zaj")("Pkt"_(z,g) dot "Wybrane"_(z,g)) $

== Wyniki
=== Bez dodatkowych warunków
Bez dodatkowych warunków plan prezentuje się następująco:

#align(center)[
#table(
  columns: 6,
  align: center,
    "" , "Pn." , "Wt." , "Śr." , "Cz." , "Pt.",
    "8:00" , "chemia min. (I)" , "" , "" , "" , "",
    "8:30" , "chemia min. (I)" , "" , "" , "" , "",
    "9:00" , "chemia min. (I)" , "" , "" , "" , "",
    "9:30" , "chemia min. (I)" , "" , "" , "" , "",
    "10:00" , "" , "analiza (II)" , "algebra (III)" , "" , "",
    "10:30" , "chemia org. (II)" , "analiza (II)" , "algebra (III)" , "" , "",
    "11:00" , "chemia org. (II)" , "analiza (II)" , "algebra (III)" , "" , "",
    "11:30" , "chemia org. (II)" , "analiza (II)" , "algebra (III)" , "" , "",
    "12:00" , "lunch" , "lunch" , "lunch" , "lunch" , "lunch",
    "12:30" , "lunch" , "lunch" , "lunch" , "lunch" , "lunch",
    "13:00" , "trening" , "" , "" , "" , "",
    "13:30" , "trening" , "" , "" , "" , "",
    "14:00" , "trening" , "" , "" , "" , "",
    "14:30" , "trening" , "" , "" , "" , "",
    "15:00" , "" , "" , "" , "" , "",
    "15:30" , "" , "" , "" , "" , "",
    "16:00" , "" , "" , "" , "" , "",
    "16:30" , "" , "" , "" , "" , "",
    "17:00" , "" , "" , "" , "fizyka (IV)" , "",
    "17:30" , "" , "" , "" , "fizyka (IV)" , "",
    "18:00" , "" , "" , "" , "fizyka (IV)" , "",
    "18:30" , "" , "" , "" , "fizyka (IV)" , "",
    "19:00" , "" , "" , "" , "fizyka (IV)" , "",
    "19:30" , "" , "" , "" , "fizyka (IV)" , "",
)]

Suma preferencji wynosi 37. Można by nawet dodać jeszcze jedne zajęcia sportowe w środę od 13:00 do 15:00 ale to nie jest już wymagane od solvera.

=== Dodatkowe warunki

Ograniczenia dodatkowe widoczne w @ogr_dod powodują zmiany w planie prezentujące się następująco:

#align(center)[
#table(
  columns: 6,
  align: center,
    "" , "Pn." , "Wt." , "Śr." , "Cz." , "Pt.",
    "8:00" , "" , "" , "" , "analiza (IV)" , "",
    "8:30" , "" , "" , "" , "analiza (IV)" , "",
    "9:00" , "" , "" , "" , "analiza (IV)" , "",
    "9:30" , "" , "" , "" , "analiza (IV)" , "",
    "10:00" , "" , "fizyka (II)" , "" , "" , "",
    "10:30" , "chemia org. (II)" , "fizyka (II)" , "" , "" , "",
    "11:00" , "chemia org. (II)" , "fizyka (II)" , "trening" , "" , "",
    "11:30" , "chemia org. (II)" , "fizyka (II)" , "trening" , "" , "",
    "12:00" , "lunch" , "fizyka (II)" , "trening" , "lunch" , "lunch",
    "12:30" , "lunch" , "fizyka (II)" , "trening" , "lunch" , "lunch",
    "13:00" , "algebra (I)" , "lunch" , "lunch" , "chemia min. (III)" , "",
    "13:30" , "algebra (I)" , "lunch" , "lunch" , "chemia min. (III)" , "",
    "14:00" , "algebra (I)" , "" , "" , "chemia min. (III)" , "",
    "14:30" , "algebra (I)" , "" , "" , "chemia min. (III)" , ""
)]

W tym wypadku suma preferencji wynosi 28. Jest to znacznie mniej niż w poprzednim wypadku ale jej kosztem zapewniliśmy dwa wolne dni od ćwiczeń.

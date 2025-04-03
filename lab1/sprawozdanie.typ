#set heading(numbering: "1.")
#set text(lang: "pl")
#set text(font: "Libertinus math")



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
$ min c^T x $
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

Zadanie polegało na znalezieniu optymalnego planu ćwiczen wedle godzin i ocen zajęć podanych w treści zadania. Dodatkowo w plan trzeba było zmieścić godzinną przerwę w godzinach 12 - 14 a także zajęcia sportowe conajmniej raz w tygodniu.

== Model


#align(top + center)[
  #text(size: 24pt, [Metody Optymalizacji \ Laboratorium 2])

  *Adrian Herda*

  #datetime.today().display()
]

#show heading: set block(below: 1em, above: 2em)
#set heading(numbering: "1.")
#set text(lang: "pl")
#set par(
  first-line-indent: 0.8em,
  spacing: 1em,
  leading: 0.8em,
  justify: true,
)

= Zadanie 1

Celem modelu jest minimalizacja resztek pozostawionych po wycinaniu desek w tartaku. Tartak tnie deski o długości $22$ cali na kawałki o długości $7, 5, 3$ cale.

== Dane

- $W$  - standardowa szerokość deski (w calach),
- $w_i$ - możliwe szerokości desek po cięciu (w calach) dla $i in {1,2,3}$,
- $d_i$ - zapotrzebowanie na deski o odpowiednich szerokościach,
- $P$ - zbiór możliwych kombinacji szerokości desek po cięciu jednej deski wraz z resztą pozstałą po cięciu. Każda kombinacja to czwórka $(a_1, a_2, a_3, r)$, gdzie $a_i$ to liczba desek o szerokości $w_i$ pozyskanych z takiego podziału deski, a $r$ to reszta pozostała po cięciu.

=== Egzemplarz

- $W = 22$,
- $w = [1,2,3]$,
- $d = [110, 120, 80]$

== Model

=== Zmienne decyzyjne

- $x_p in NN union {0}$ - liczba desek wyciętych według kombinacji $p in P$

=== Ograniczenia

- Ograniczenie na zapotrzebowanie deski o szerokości $w_i$:
$ sum_(p in P) x_p dot a_(i p) gt.eq d_i ", dla" i in {1, 2, 3} $
gdzie $a_(i p)$ to liczba desek o szerokości $w_i$ w kombinacji $p$.

=== Funkcja celu

Funkcja celu minimalizuje resztę pozostałą po cięciu oraz nadmiarowe deski wycięte podczas cięć, równowaażnie można powiedzieć że minimalizuje liczbę użytych desek:
$ min sum_(p in P) x_p $

== Rozwiązanie

Wykorzustując solver Cbc oraz bibliotekę JuMP w języku Julia, otrzymujemy następujące rozwiązanie:

=== Funkcja celu

- Ilość wykorzystanych desek: $74$,
- Ilość niewykorzystanego materiału (w calach): $18$

=== Wybrane kombinacje
- Wzór $(1,3,0,0) times 28$
- Wzór $(2,1,1,0) times 37$
- Wzór $(1,0,5,0) times 9$

== Wyprodukowane deski

- Ilość desek o szerokości $7$ cali: $111$
- Ilość desek o szerokości $5$ cali: $121$
- Ilość desek o szerokości $3$ cali: $82$

== Podusmowanie

Algorytm wykorzystał tylko kombinacje nie zostawiające reszty po cięciu i zminimalizował ilość nadmiarowych desek.

#pagebreak()

= Zadanie 2

Celem modelu jest znalezienie harmonogramu dla pojedynczej maszyny pozwalającego na zminimalizowanie kosztów wykonywania zadań. Koszty wykonywania zadań są obliczane na podstawie czasu ich realizacji oraz ich wagi.

== Dane
- $n$ - liczba zadań,
- $p_j$ - czas potrzebny na wykonanie zadania $j in [n]$,
- $w_j$ - waga zadania $j in [n]$,
- $r_j$ - czas najwcześniejszego możliwego rozpoczęcia zadania $j in [n]$,
- $T = sum_(j in [n])p_j + max_(j in [n]){r_j} + 1$ - dodatkowy parametr pomocniczy, który oznacza maksymalny potrzebny czas na wykonanie wszystkich zadań

=== Wybrany egzemplarz
#align(center)[
  #table(
    columns: 11,
    [$j$ - Zadanie], [$ 1$],[$ 2$],[$ 3$],[$ 4$],[$ 5$],[$ 6$],[$ 7$],[$ 8$],[$ 9$],[$ 10$],
    [$p_j$ - Czas wykonywania], [$ 3$], [$ 2$], [$ 7$], [$ 5$], [$ 6$], [$ 4$], [$ 8$], [$ 3$], [$ 9$], [$ 2$],
    [$w_j$ - Waga], [$ 2$], [$ 4$], [$ 1$], [$ 3$], [$ 2$], [$ 5$], [$ 1$], [$ 2$], [$ 4$], [$ 3$],
    [$r_j$ - Czas możliwego rozpoczęcia], [$ 0$], [$ 1$], [$ 3$], [$ 5$], [$ 0$], [$ 2$], [$ 6$], [$ 4$], [$ 3$], [$ 0$]
  )
]

== Model
=== Zmienne decyzyjne

- $x_(j t) in {0, 1}$, dla $j in [n]$, $T]$ $ x_(j t) = cases(1 : "zadanie" j "ma ostanią jednostkę czasu działania w momencie" t, 0 : "w przeciwnym przypadku") $

=== Ograniczenia

- Każde zadanie może być wykonywane tylko raz, czyli może się zakończyć tylko raz:
$ sum_(T])x_(j t) = 1", dla" j in [n] $
- Każde zadanie może się zaczynać nie wcześniej niż podane w odpowiadającym parametrze r:
$ sum_(T]) x_(j t)(t - p_j) gt.eq r_j", dla" j in [n] $
- W dowolnym momencie czasu wykonywane jest maksymalnie jedno zadanie
$ sum_(j in [n])(sum_(t' = t)^min{T, t - 1 + p_j} x_(j t')) lt.eq 1", dla" T] $

=== Funkcja celu

Funkcja celu minimalizuje sumę ważonych czasów zakończenia zadań:
$ min sum_(j in [n]) w_j dot sum_(T]) (t dot x_(j t)) $
gdzie $sum_(t = 1)^T (t dot x_(j t))$ interpretować można jako czas zakończenia zadania $j$.

== Rozwiązanie

Wykorzustując solver Cbc oraz bibliotekę JuMP w języku Julia, otrzymujemy optymalne rozwiązanie.
Wyniki zapisywane są z czasem zaczynającym się od $0$-wej sekundy podczas gdy liczone są zaczynając się do $1$-ej sekundy

=== Funkcja celu
$
  sum_(j in [n]) w_j dot sum_(T]) (t dot x_(j t)) = 439
$

=== Momenty zakończeń

#align(center)[
  #table(
    columns: 2,
    table.header([Zadanie], [Moment zakończenia],),
    [$ 1$], [$ 13$],
    [$ 2$], [$ 3$],
    [$ 3$], [$ 40$],
    [$ 4$], [$ 18$],
    [$ 5$], [$ 33$],
    [$ 6$], [$ 7$],
    [$ 7$], [$ 48$],
    [$ 8$], [$ 10$],
    [$ 9$], [$ 27$],
    [$ 10$], [$ 1$],
  )
]

#pagebreak()

= Zadanie 3

Celem modelu z tego zadania jest stworzenie harmonogramu dla określonej liczby maszyn tak aby wykonać zadania przeznaczone dla tych maszynw jak najszybszym czasie. Zadania mają czasy wykonywania i ograniczenia poprzedzalności których trzeba przeszkadzać.

== Dane
- $m$ - liczba maszyn,
- $n$ - liczba zadań,
- $p_j$ - czasy wykonywania
- $R = {(a, b): a prec b}$ - zbiór relacji poprzedzania gdzie $a prec b$ oznacza ze zadanie $b$ nie może się zacząć dopóki $a$ się nie zakończy
- $T = 1 + sum_(j in [n]) p_j$ - dodatkowy parametr pomocniczy oznaczający maksymalny czas w jakim wszystkie zadania mogłyby zostać wykonane przez jedna maszynę

=== Egzemplarz

- $m = 3$
- $n = 9$
- #table(
    columns: 2,
    align: center,
    table.header([Zadanie $j$], [$p_j$]),
    [$ 1$], [$ 1$],
    [$ 2$], [$ 2$],
    [$ 3$], [$ 1$],
    [$ 4$], [$ 2$],
    [$ 5$], [$ 1$],
    [$ 6$], [$ 1$],
    [$ 7$], [$ 3$],
    [$ 8$], [$ 6$],
    [$ 9$], [$ 2$]
  )
- $R = {
    (1, 4), (2, 4), (2, 5), (3, 4), (3, 5),
    (4, 6), (4, 7), (5, 7), (5, 8),
    (6, 9), (7, 9)
}$

#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#let nodes = (1,2,3,4,5,6,7,8,9)
#let edges = (
  (1, 4), (2, 4), (2, 5), (3, 4), (3, 5),
  (4, 6), (4, 7), (5, 7), (5, 8),
  (6, 9), (7, 9)
)

=== Diagram poprzedzania

#align(center)[
  #diagram({
    node((0, 0), [1], radius: 0.8em, name: str(1), stroke: 0.1pt)
    node((1, 0), [2], radius: 0.8em, name: str(2), stroke: 0.1pt)
    node((2, 0), [3], radius: 0.8em, name: str(3), stroke: 0.1pt)
    node((.5, 1), [4], radius: 0.8em, name: str(4), stroke: 0.1pt)
    node((1.5, 1), [5], radius: 0.8em, name: str(5), stroke: 0.1pt)
    node((0, 2), [6], radius: 0.8em, name: str(6), stroke: 0.1pt)
    node((1, 2), [7], radius: 0.8em, name: str(7), stroke: 0.1pt)
    node((2, 2), [8], radius: 0.8em, name: str(8), stroke: 0.1pt)
    node((.5, 3), [9], radius: 0.8em, name: str(9), stroke: 0.1pt)
    for (from, to) in edges {
      edge(label(str(from)), label(str(to)), "-|>", bend: 0deg)
    }
  })
]

== Model

=== Zmienne decyzyjne
- $x_(j t i) in {0, 1}$, dla $j in [n], T], i in [m]$
  $
    x_(j t i) = cases(1 : "zadanie" j "ma rozpoczyna swoje działanie w momencie" t "na maszynie" i, 0 : "w przeciwnym wypadku")
  $
- $C gt.eq 0$ - minimalny czas potrzebny na wykonanie wszystkich zadań

=== Ograniczenia

- Każde zadanie kończy się nie później niź $C$
$ sum_(T]) x_(j t i)(t - 1 +p_j) lt.eq C", dla" j in [n] "oraz" i in [m] $
- Każde zadanie musi być wykonane, a więc i rozpoczęte, dokładnie raz
$ sum_(T])sum_(i in [m]) x_(j t i) = 1", dla" j in [n] $
- Warunki poprzedzania muszą być spełnione - czas zakońćzenia zadanie $a$ musi być mniejszy niż czas rozpoczęcia zadania $b$
$ sum_(T])sum_(i in [m]) x_(a t i)(t + p_a) lt.eq sum_(T])sum_(i in [m]) t dot x_(b t i)", dla" (a,b) in R $
- Zadania nie mogą na siebie nachodzić
$ sum_(j in [n])(sum_(t'=max{1, t + 1 - p_j})^t x_(j t' m)) lt.eq 1", dla" T] "oraz" i in [m] $

=== Funkcja celu

Funkcja celu minimalizuje czas potrzebny na wykonanie wszystkich zadań

$ min C $

== Rozwiązanie

Wykorzystując solver Cbc oraz bibliotekę JuMP języka Julia do stworzenia modelu, zostało znalezione optymalne rozwiązanie:

=== Funkcja celu

$ C = 9 $

=== Harmonogram na diagramie Gantt'a

#figure(
  image("zad3.png", width: 100%),
  caption: [Diagram Gantt'a dla optymalnego rozwiązania $C = 9$],
) <zad3>


= Zadanie 4

Zadnie polegało na stworzeniu modelu który znajdzie harmonogram wykonywania zadań przy ograniczonych zasobach nie łąmiąc określonych zasad poprzedzania. Każde zadanie ma określony czas trwania, wymaganą ilość zasobu do jego wykonania oraz może zacząć się nie wcześniej niż skończy się jego poprzednik.

== Dane

- $P$ - ilość limitowanych zasobów
- $n$ - ilość zadań do wykonania
- $N_p$ - ilość dostępnego zasobu $p in [P]$
- $delta_j$ - czas potrzebny do wykonania zadania $j in [n]$
- $r_(j p)$ - ilość zasobu $p in [P]$ potrzebna do wykonania zadania $j in [n]$
- $R = {(a, b): a prec b}$ - zbiór relacji poprzedzania gdzie $a prec b$ oznacza ze zadanie $b$ nie może się zacząć dopóki $a$ się nie zakończy
- $T_max = 1 + sum_(j in [n])delta_j$ - dodatkowy parametr pomocniczy oznaczający maksymalny czas w jakim wszystkie zadania mogłyby zostać wykonane, wykonując wszytskie po kolei i nie dzieląc zasobów pomiędzy zadania

=== Egzemplarz

- $P = 1$
- $n = 8$
- $N = [ 30 ]$
- #table(
  columns: 9,
  align: center,
  [Zadanie $j$], [$ 1$],[$ 2$],[$ 3$],[$ 4$],[$ 5$],[$ 6$],[$ 7$],[$ 8$],
  [Czas wykonania $delta_j$], [$ 50$], [$ 47$], [$ 55$], [$ 46$], [$ 32$], [$ 57$], [$ 15$], [$ 62$],
  [Potrzebne zasoby $r_j$], [$[ 9]$],[$ [17]$],[$ [11]$],[$ [4]$],[$ [13]$],[$[ 7]$],[$ [7]$],[$ [17]$]
)
- $R = {
    (1, 2), (1, 3), (1, 4),
    (2, 5), (3, 6), (4, 6), (4, 7),
    (5, 8), (6, 8), (7, 8)
}$

#let edges2 = (
    (1, 2), (1, 3), (1, 4),
    (2, 5), (3, 6), (4, 6), (4, 7),
    (5, 8), (6, 8), (7, 8)
)

=== Diagram poprzedzania
#align(center)[
  #diagram({
    node((1, 0), [1], radius: 0.8em, name: str(1), stroke: 0.1pt)
    node((2, 1), [2], radius: 0.8em, name: str(2), stroke: 0.1pt)
    node((1, 1), [3], radius: 0.8em, name: str(3), stroke: 0.1pt)
    node((0, 1), [4], radius: 0.8em, name: str(4), stroke: 0.1pt)
    node((2, 2), [5], radius: 0.8em, name: str(5), stroke: 0.1pt)
    node((1, 2), [6], radius: 0.8em, name: str(6), stroke: 0.1pt)
    node((0, 2), [7], radius: 0.8em, name: str(7), stroke: 0.1pt)
    node((1, 3), [8], radius: 0.8em, name: str(8), stroke: 0.1pt)
    for (from, to) in edges2 {
      edge(label(str(from)), label(str(to)), "-|>", bend: 0deg)
    }
  })
]

== Model

=== Zmienne decyzyjne
- $x_(j t) in {0, 1}$, dla $j in [n], T_max]$
  $
    x_(j t i) = cases(1 : "zadanie" j "ma rozpoczyna swoje działanie w momencie" t, 0 : "w przeciwnym wypadku")
  $
- $C gt.eq 0$ - minimalny czas potrzebny na wykonanie wszystkich zadań

=== Ograniczenia

- Każde zadanie kończy się nie później niź $C$
$ sum_(T_max]) x_(j t)(t - 1 + delta_j) lt.eq C", dla" j in [n] $
- Każde zadanie musi być wykonane, a więc i rozpoczęte, dokładnie raz
$ sum_(T_max]) x_(j t) = 1", dla" j in [n] $
- Warunki poprzedzania muszą być spełnione - czas zakońćzenia zadanie $a$ musi być mniejszy niż czas rozpoczęcia zadania $b$
$ sum_(T_max]) x_(a t)(t + delta_a) lt.eq sum_(T_max]) t dot x_(b t)", dla" (a,b) in R $
- Zadania nie mogą przekraczać limitu zasobów w żadnym momencie czasu
$ sum_(j in [n])(sum_(t'=max{1, t + 1 - delta_j})^t (x_(j t') dot r_(j p))) lt.eq N_p", dla" T_max] "oraz" p in [P] $


=== Funkcja celu

Funkcja celu minimalizuje czas potrzebny na wykonanie wszystkich zadań

$ min C $

== Rozwiązanie

Wykorzustując solver Cbc oraz bibliotekę JuMP w języku Julia, otrzymujemy następujące optymalne rozwiązanie:

=== Funkcja celu

$ C = 237 $

=== Starty i zakończenia zadań

#align(center)[
  #table(
    align: center,
    columns: 3,
    table.header([Zadanie], [Start], [Koniec]),
    [$ 1 $], [$ 1 $], [$ 50 $],
    [$ 2 $], [$ 97 $], [$ 143 $],
    [$ 3 $], [$ 52 $], [$ 106 $],
    [$ 4 $], [$ 51 $], [$ 96 $],
    [$ 5 $], [$ 144 $], [$ 175 $],
    [$ 6 $], [$ 119 $], [$ 175 $],
    [$ 7 $], [$ 161 $], [$ 175 $],
    [$ 8 $], [$ 176 $], [$ 237 $],
  )
]

=== Harmonogram na diagramie Gantt'a

#figure(
  image("zad4.png", width: 100%),
  caption: [Diagram Gantt'a dla optymalnego rozwiązania $C = 237$],
) <zad4>

=== Wykorzystanie zasobów

#align(center)[
  #table(
    align: center,
    columns: 3,
    table.header([Start \ (włącznie)], [Koniec \ (wyłącznie)], [Wykorzystanie \ zasobów]),
      [$ 1$],  [$ 51$], [$ 9/30 $],
      [$ 51$],  [$ 52$], [$ 4/30 $],
      [$ 52$],  [$ 97$],[$ 15/30 $],
      [$ 97$], [$ 107$],[$ 28/30 $],
      [$ 107$], [$ 119$],[$ 17/30 $],
      [$ 119$], [$ 144$],[$ 24/30 $],
      [$ 144$], [$ 161$],[$ 20/30 $],
      [$ 161$], [$ 176$],[$ 27/30 $],
      [$ 176$], [$ 238$],[$ 17/30 $],
  )
]

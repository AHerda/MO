#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: [Metody Optymalizacyjne \ Laboratorium 3],
  authors: (
    (name: "Adrian Herda", affiliation: "Informatyka Algorytmiczna, Politechnika Wrocławska"),
  ),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  abstract: none, // also can be none
  date: [#datetime.today().display("[day].[month].[year]")],
)

= Wprowadzenie

Celem zadania było zaimplemetowanie algorytmy $2$-aproksymującego dla problemu szeregowania zadań na niezależnych maszynach z kryterium minimalizacji długości uszeregowania.

Zaimplementowany algorytm jest oparty na algorytmie $2$-aproksymującym dla problemu szeregowania zadań na maszynach równoległych z kryterium minimalizacji długości uszeregowania, który jest opisany w książce Approximation Algorithms (2001, V. V. Vazirani) @vazirani2001approximation.

Implementacja wykonana została w języku Julia z wykorzystaniem pakietu JuMP @jump, oraz solvera HiGHS.

= Opis algorytmu

Algorytm składa się z 5 kroków:

+ okreslenie zakresu $T$,
+ wyszukania za pomocą binary search minimalnej wartości $T^*$ z możliwym rozwiązaniem $L P(T)$,
+ znalezienia $x$ rozwiązania bazowego dopuszczalnego dla $T^*$,
+ zaokrąglenia ułamkowego $x$ za pomocą doskonałego dopasowania w grafie dwudzielnym,
+ wyliczenia długości szeregowania.

== Zakres wartości $T$

Zakres wartości $T$ to przedział $[ceil(alpha / m), ceil(alpha)]$ w którym szukamy rozwiązania, gdzie $alpha$ to suma czasów wykonania wszystkich zadań na wszystkich maszynach na których te zadania wykonywane są najszybciej, czyli $ alpha = max_(1 lt.eq j lt.eq m) sum_(i in {k: min_(m in [1, n]){p_(m,j)} = p_(k,j)}) p_(i,j) $

== Relaksacja do programowania liniowego

=== Dane wejściowe

- $T$ - zakres czasu, w którym szukamy rozwiązania,
- $n$ - liczba zadań,
- $m$ - liczba maszyn,
- $p_(i,j)$ - czas wykonania zadania $i$ na maszynie $j$, dla $1 lt.eq i lt.eq n$ oraz $1 lt.eq j lt.eq m$.

=== Zmienne

- $x_(i,j) in [0, 1]$ - zmienna, która przyjmuje wartość $1$, jeśli zadanie $i$ jest przypisane do maszyny $j$, dla $1 lt.eq i lt.eq n$ oraz $1 lt.eq j lt.eq m$.

=== Ograniczenia

- każde zadanie musi być przypisane do dokładnie jednej maszyny:
  $ sum_(j=1)^m x_(i,j) = 1", dla " 1 lt.eq i lt.eq n $
- maszyny moigą pracować conajwyżej w czasie $T$:
  $ sum_(i=1)^n p_(i,j) dot x_(i,j) lt.eq T", dla "1 lt.eq j lt.eq m $

=== Cel

Celem jest zadecydwanie czy istnieje takie przypisanie zadań do maszyn, że całkowity czas wykonania wszystkich zadań nie przekracza $T$.

= Wyniki

Współczynnik aproksymacji jest obliczany jako stosunek długości uszeregowania otrzymanego przez algorytm do długości uszeregowania optymalnego.

#figure(
  image("../plots/ratio_vs_n_scatter.png"),
  caption: "Wykres ilustrujący zależność między liczbą zadań a współczynnikiem aproksymacji algorytmu.",
) <rys1>

Na rysunku 1. widoczny jest trend polepszania się współczynnika aproksymacji wraz ze wzrostem liczby zadań.

#table(
  columns: 3,
  table.header(
    "Liczba zadań",
    "Średni współczynnik aproksymacji",
    "Maksymalny współczynnik aproksymacji"
  ),
  [$100$], [$1.336283$], [$ 1.980198$],
  [$200$], [$1.230766$], [$ 1.894737$],
  [$500$], [$1.106448$], [$ 1.717949$],
  [$1000$], [$1.056992$], [$ 1.500000$],
)

Dla mniejszych instancji wpsółczynniki aprokymacji mimo nie tak dużej średniej osiągją wartości nawet bliskie $2$, podczas gdy dla większych instancji maksymalne współczynniki nie przekraczają wartości $1.5$.

#figure(
  image("../plots/ratio_boxplot_by_family.png"),
  caption: "Wykres ilustrujący zależność między liczbą zadań a współczynnikiem aproksymacji algorytmu.",
) <rys1>

#table(
  columns: 3,
  table.header(
    [Rodzina instancji],
    [Średni współczynnik \ aproksymacji],
    [Maksymalny współczynnik \ aproksymacji]
  ),
[  Instanciasde1000a1100], [$ 1.110597$], [$1.976802$],
[            JobsCorre], [$ 1.206766$], [$1.913462$],
[             MaqCorre], [$ 1.242718$], [$ 1.872549$],
[    instancias100a120], [$ 1.122442$], [$ 1.980198$],
[    instancias100a200], [$ 1.110965$], [$ 1.540670$],
[      instancias1a100], [$ 1.331844$], [$ 1.894737$],
[   instanciasde10a100], [$ 1.152753$], [$ 1.632911$],
)
Na wykresie 2. widoczny jest rozkład współczynników aproksymacji dla różnych rodzin instancji. Widać, że dla rodzin instancji z wyższymi zakresami czasów wykonywania zadań współczynniki są mniejsze i nie rozrzucone aż tak.Dla rodziny "instancias1a100", gdzie czasy wykonywania zadań są najmniejsze i mieszczą się w zakresie $1, 100$, współczynniki są największe i dochodzą az do wartości bardzo bliskich wartości $2$.

#bibliography("bilio.bib")

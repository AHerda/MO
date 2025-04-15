#set text(lang: "pl")

#align(top + center)[
  #text(size: 24pt, [Kartkówka 2]) \
  #datetime.today().display()
]

+ Zapisz model w postaci programowania liniowego: \
  $y_i$ - produkty
  $
    max {y_1 k_1 + y_2 k_2} \
    forall_(i in {1,2,3}) d_(i,1) y_1 + d_(i, 2) y_2 <= p_i\
    y_1, y_2 >= 0
  $
+ Ile zmiennych ile ograniczeń: \
  Zmiennych: 2 \
  Ograniczeń: 3 \
+ Postać standardowa:
  $
    min {-y_1 k_1 - y_2 k_2} \
    forall_(i in {1,2,3}) d_(i,1) y_1 + d_(i, 2) y_2 + s_i = p_i \
    y_1, y_2 >= 0 \
    s_1, s_2, s_3 >= 0
  $
+ Ile zmiennych i oraniczeń w postaci standardowej: \
  Zmiennych: 5 \
  Ograniczeń: 3
+ Ile jest rozwiązań bazowych, wybierz 3 bazy i policz i zapisz ich układ równań \
  ???

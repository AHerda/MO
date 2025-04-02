# Adrian Herda

set ropa;
set produkty;
set produkty_krak;
set cel_oleju;
set cel_desty;

param koszt_ropy {r in ropa} >= 0;
param wydajnosc {p in produkty, r in ropa} >= 0;
param wydajnosc_krak {p in produkty_krak} >= 0;

param koszt_desty >= 0;
param koszt_krak >= 0;

param min_silnik >= 0;
param min_domowe >= 0;
param min_ciezkie >= 0;

param siarka_max >= 0;
param desty_siarka {r in ropa} >= 0;
param krak_siarka {r in ropa} >= 0;

var ilosc_ropy {r in ropa} >= 0;
var olej {r in ropa, c in cel_oleju} >= 0;
var desty {r in ropa, c in cel_desty} >= 0;

minimize cost_func :
    sum{r in ropa} (
        ilosc_ropy[r] * (koszt_ropy[r] + koszt_desty)
            + koszt_krak * desty[r, "krak"]
    );

s.t. podzial_oleju {r in ropa}:
    ilosc_ropy[r] * wydajnosc["olej", r] = sum{c in cel_oleju} olej[r, c];
s.t. podzial_destylatu {r in ropa}:
    ilosc_ropy[r] * wydajnosc["desty", r] = sum{c in cel_desty} desty[r, c];

s.t. silnik_suma: sum {r in ropa} (
    ilosc_ropy[r] * wydajnosc["benz", r]
    + desty[r, "krak"] * wydajnosc_krak["benz"]
) >= min_silnik;

s.t. domowe_suma: sum {r in ropa} (
    olej[r, "domowe"] + desty[r, "krak"] * wydajnosc_krak["olej"]
) >= min_domowe;

s.t. ciezkie_suma: sum {r in ropa} (
    olej[r, "ciezkie"]
    + desty[r, "krak"] * wydajnosc_krak["reszta"]
    + desty[r, "ciezkie"]
    + wydajnosc["reszta", r]
) >= min_ciezkie;

s.t. siarka_sum: sum {r in ropa} (
    + olej[r, "domowe"] * desty_siarka[r]
    + desty[r, "krak"] * wydajnosc_krak["olej"] * krak_siarka[r]
) <= siarka_max * sum {r in ropa} (
    olej[r, "domowe"] + desty[r, "krak"] * wydajnosc_krak["olej"]
);

solve;

display ilosc_ropy;
display olej;
display desty;
display cost_func;

end;

# Adrian Herda

# Parametry modelu
set Cities;

param shortI{c in Cities} >= 0;
param shortII{c in Cities} >= 0;
param surpI{c in Cities} >= 0;
param surpII{c in Cities} >= 0;

param dist{c1 in Cities, c2 in Cities} >= 0;

# Zmienne decyzyjne
var movI{c1 in Cities, c2 in Cities} >= 0;
var movII{c1 in Cities, c2 in Cities} >= 0;
# przemieszczenie dzwigow typu II uzywanych jako dzwigi typu I
var movIII{c1 in Cities, c2 in Cities} >= 0;

# Funkcja kosztu
minimize cost_func:
    sum{c1 in Cities, c2 in Cities} (
        (dist[c1, c2] * movI[c1,c2]) + (1.2 * dist[c1,c2] * (movII[c1,c2] + movIII[c1,c2]))
    );

# Ograniczenia
# Do c2 musimy przywieźć conajmniej tyle dzwigow I lub II zeby pokrywaly short
s.t. short_movI{c2 in Cities}: sum{c1 in Cities} (movI[c1,c2] + movIII[c1,c2]) >= shortI[c2];
# Do c2 musimy przywieźć conajmniej tyle dzwigow II zeby pokrywaly shortII
s.t. short_movII{c2 in Cities}: sum{c1 in Cities} movII[c1,c2] >= shortII[c2];
# Od c1 możemy wywieźć maksymalnie tyle dzwigow I zeby nie przekraczaly surpI
s.t. surp_movI{c1 in Cities}: sum{c2 in Cities} movI[c1,c2] <= surpI[c1];
# Od c1 możemy wywieźć maksymalnie tyle dzwigow II zeby nie przekraczaly surpII
s.t. surp_movII{c1 in Cities}: sum{c2 in Cities} (movII[c1,c2] + movIII[c1,c2]) <= surpII[c1];

solve;

display movI, movII, movIII, cost_func;

end;

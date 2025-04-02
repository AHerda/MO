echo "n,err"
for N in {1..10}; do
    echo -n "$N,"
    cat <<EOF > tmp.dat
data;
param n := $N;
end;
EOF
    glpsol --model 1.mod --data tmp.dat | grep 'err = ' | sed 's/^err = //'
done

rm tmp.dat

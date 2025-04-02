bash run.sh | grep mov | lines | split column '.val = ' | skip 4 | where column2 != '0'

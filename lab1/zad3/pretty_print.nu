bash run.sh | lines | where $it =~ val | split column ".val = "

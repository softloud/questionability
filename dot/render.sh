#!/usr/bin/env bash
# sudo apt install graphviz

set -euo pipefail

mkdir -p figures

for f in dot/*.dot; do
    name=$(basename "$f" .dot)
    dot -Tpng "$f" -o "figures/${name}.png"
    echo "Rendered figures/${name}.png"
done

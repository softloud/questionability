#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/../dbt/seeds"

# Clear existing seeds
rm -f "$SEEDS_DIR"/*.csv

# Copy all CSVs from source-data to seeds directory, preserving names
for csv in "$SCRIPT_DIR"/*.csv; do
	cp "$csv" "$SEEDS_DIR/$(basename "$csv")"
done

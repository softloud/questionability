#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/../dbt/seeds"

# Clear existing seeds
rm -f "$SEEDS_DIR"/*.csv

# Copy source data CSVs to seeds with canonical names
cp "$SCRIPT_DIR/blue_tit_data_updated_2020-04-18.csv" "$SEEDS_DIR/tit_model.csv"
cp "$SCRIPT_DIR/master_data_Charles_euc.csv" "$SEEDS_DIR/euc_model.csv"

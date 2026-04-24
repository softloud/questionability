# Platform: dbt / Dagster / PostgreSQL

This document covers the data platform underlying the project — how source data flows into the database and is transformed via dbt, orchestrated by Dagster.

## Prerequisites

- [uv](https://github.com/astral-sh/uv) — Python package management (see [using-uv.md](using-uv.md))
- PostgreSQL running locally (see [db.md](db.md))
- A `.env` file in the repo root:

```
DATABASE_USER=qnuser
DATABASE_PASSWORD=qnpass
DATABASE=qndb
```

## Setup

```bash
# Install Python dependencies
uv sync

# Set up dbt profile (not committed — contains credentials)
# See db.md for PostgreSQL setup, then configure dbt/profiles.yml
```

## Running Dagster

```bash
make dagster
```

Opens the Dagster UI at `http://localhost:3000`. `DAGSTER_HOME` is set automatically via the Makefile so run history persists across sessions.

## Assets and Jobs

### `seed_refresh` job — run when source data changes

- `sync_seeds` → copies CSVs from `source-data/` into `dbt/seeds/`
- `dbt_seed` → loads those CSVs into the database via `dbt seed`

Run this job from the Dagster UI after adding or updating source files.

### `dbt_assets` — run to refresh transformed data

Materialise `dbt_assets` from the UI to rebuild all dbt models independently of the seed pipeline.

## Adding New Datasets

When you add a new source CSV:

1. Place the file in `source-data/`
2. Edit [`source-data/sync_seeds.sh`](../source-data/sync_seeds.sh) — add a `cp` line mapping your file to a canonical seed name:
   ```bash
   cp "$SCRIPT_DIR/your_new_file.csv" "$SEEDS_DIR/your_seed_name.csv"
   ```
3. Run the `seed_refresh` job in Dagster

dbt will pick up the new seed by filename automatically.

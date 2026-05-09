from pathlib import Path

import duckdb
from dagster import AssetExecutionContext, asset

from dagster_qn.assets.dbt import dbt_assets
from dagster_qn.project import DBT_PROJECT

_DATA_DIR = Path(__file__).parent.parent.parent / "data"
_DUCKDB_PATH = DBT_PROJECT.project_dir / "dev.duckdb"


@asset(deps=[dbt_assets], group_name="analysis")
def export_analytic_csvs(context: AssetExecutionContext):
    """Export all analytic-layer (main_analytic schema) tables from DuckDB to data/ as CSVs."""
    _DATA_DIR.mkdir(exist_ok=True)

    for csv in _DATA_DIR.glob("*.csv"):
        csv.unlink()
        context.log.info(f"Removed {csv.name}")

    con = duckdb.connect(str(_DUCKDB_PATH), read_only=True)
    try:
        tables = con.execute(
            "SELECT table_name FROM information_schema.tables "
            "WHERE table_schema = 'main_analytic' AND table_type = 'BASE TABLE'"
        ).fetchall()

        for (table_name,) in tables:
            df = con.execute(f'SELECT * FROM main_analytic."{table_name}"').df()
            csv_name = table_name.removeprefix("ana_")
            out = _DATA_DIR / f"{csv_name}.csv"
            df.to_csv(out, index=False)
            context.log.info(f"Exported {table_name} ({len(df)} rows) → {out.name}")
    finally:
        con.close()


from dagster import AssetExecutionContext, asset
from dagster_dbt import DbtCliResource
from pathlib import Path
import subprocess

SOURCE_DATA_DIR = Path(__file__).parent.parent.parent / "source-data"

@asset(group_name="seeds")
def sync_seeds() -> None:
    """Syncs dbt seed CSVs from source-data/ into dbt/seeds/ by running sync_seeds.sh."""
    script = SOURCE_DATA_DIR / "sync_seeds.sh"
    subprocess.run(["bash", str(script)], check=True)

@asset(group_name="seeds", deps=[sync_seeds])
def dbt_seed(dbt: DbtCliResource) -> None:
    """Loads seed CSVs into the database via dbt seed."""
    dbt.cli(["seed"]).wait()


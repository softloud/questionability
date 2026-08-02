"""Dagster assets for managing dbt seed data.

This module defines assets that handle the provisioning of seed data for the dbt project.
The workflow consists of:
1. Syncing seed CSV files from the source-data directory to dbt/seeds
2. Loading those seeds into the database using dbt seed command

Assets in this module are grouped under "provisioning" and should be materialized
before analytical assets that depend on the seed data.
"""

from dagster import AssetExecutionContext, asset
from dagster_dbt import DbtCliResource
from pathlib import Path
import subprocess

SOURCE_DATA_DIR = Path(__file__).parent.parent.parent / "source-data"


@asset(group_name="provisioning")
def sync_seeds() -> None:
    """Syncs dbt seed CSVs from source-data/ into dbt/seeds/.
    
    This asset runs the sync_seeds.sh bash script located in the source-data directory.
    The script copies CSV files from source-data/ to dbt/seeds/, ensuring that the
    latest seed data is available for dbt to load into the database.
    
    Raises:
        subprocess.CalledProcessError: If the sync_seeds.sh script fails.
    """
    script = SOURCE_DATA_DIR / "sync_seeds.sh"
    subprocess.run(["bash", str(script)], check=True)


@asset(group_name="provisioning", deps=[sync_seeds])
def dbt_seed(dbt: DbtCliResource) -> None:
    """Loads seed CSVs into the database via dbt seed.
    
    This asset depends on sync_seeds to ensure that seed files are up-to-date
    before loading. It runs `dbt seed --full-refresh` to completely refresh
    all seed data in the database, replacing any existing seed tables.
    
    Args:
        dbt: DbtCliResource for executing dbt commands.
        
    Note:
        Uses --full-refresh flag to ensure a clean load of all seed data,
        which drops and recreates seed tables rather than incrementally updating them.
    """
    dbt.cli(["seed", "--full-refresh"]).wait()


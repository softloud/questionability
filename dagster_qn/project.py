from pathlib import Path

from dagster_dbt import DbtProject

DBT_PROJECT = DbtProject(
    project_dir=Path(__file__).parent.parent / "dbt",
    profiles_dir=Path(__file__).parent.parent / "dbt",
)
DBT_PROJECT.prepare_if_dev()

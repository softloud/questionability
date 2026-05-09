from dagster import AssetSelection, Definitions, define_asset_job
from dagster_dbt import DbtCliResource

from dagster_qn.assets import dbt_assets, dbt_seed, sync_seeds, export_analytic_csvs
from dagster_qn.project import DBT_PROJECT

seed_refresh_job = define_asset_job(
    name="seed_refresh",
    selection=AssetSelection.assets(sync_seeds, dbt_seed),
)

defs = Definitions(
    assets=[sync_seeds, dbt_seed, dbt_assets, export_analytic_csvs],
    jobs=[seed_refresh_job],
    resources={
        "dbt": DbtCliResource(project_dir=DBT_PROJECT),
    },
)

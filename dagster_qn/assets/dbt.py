from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets as dagster_dbt_assets
from dagster_qn.project import DBT_PROJECT

@dagster_dbt_assets(manifest=DBT_PROJECT.manifest_path)
def dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()

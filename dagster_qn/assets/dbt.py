from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets as dagster_dbt_assets, DagsterDbtTranslator
from dagster_qn.project import DBT_PROJECT
from dagster_qn.assets.seeds import dbt_seed


class CustomDbtTranslator(DagsterDbtTranslator):
    def get_tags(self, dbt_resource_props):
        """Pass through dbt tags to Dagster tags."""
        dbt_tags = dbt_resource_props.get("tags", [])
        # Convert list of tags to dictionary format that Dagster expects
        return {tag: "" for tag in dbt_tags}


@dagster_dbt_assets(
    manifest=DBT_PROJECT.manifest_path,
    dagster_dbt_translator=CustomDbtTranslator(),
)
def dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()

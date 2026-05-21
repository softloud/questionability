import os
import subprocess
from pathlib import Path
from dagster import asset, Output, AssetExecutionContext, AssetKey
import json

PROJECT_ROOT = Path(__file__).parents[2]


def run_vis_script(
    context: AssetExecutionContext, script_name: str
) -> Output[Path]:
    script_path = PROJECT_ROOT / "analysis-scripts" / f"{script_name}.R"

    result = subprocess.run(
        ["Rscript", str(script_path)],
        capture_output=True,
        text=True,
        cwd=PROJECT_ROOT,
    )

    context.log.info(f"R stdout: {result.stdout}")
    if result.returncode != 0:
        context.log.error(f"R stderr: {result.stderr}")
        raise RuntimeError(
            f"R script failed (exit {result.returncode}):\n"
            f"stderr: {result.stderr}\n"
            f"stdout: {result.stdout}"
        )

    output_path = PROJECT_ROOT / "figures" / f"{script_name}.png"
    if not output_path.exists():
        raise RuntimeError(
            f"R script succeeded but expected output not found:"
            f" {output_path}"
        )

    context.log.info(f"Output written to {output_path}")
    return Output(output_path)

# instantiate day times scatterplot
@asset(
    group_name="analysis",
    deps=[
        AssetKey(["export_analytic_csvs"]),
    ]
)
def conclusions_treemap(context: AssetExecutionContext) -> Output[Path]:
    return run_vis_script(context, "conclusions--treemap")

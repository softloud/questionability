"""
Dagster assets for generating slide materials.

OVERVIEW
--------
This module defines Dagster assets that generate materials for presentations
and talks. Each asset produces outputs related to slides, such as figures
optimized for presentations, summary tables, or other slide-ready materials.

HOW TO USE
----------
1. Add a new asset in this file:
   @asset(
       group_name="slides",
       deps=[AssetKey(["export_analytic_csvs"])]  # or other dependencies
   )
   def my_slide_asset(context: AssetExecutionContext) -> Output[Path]:
       # Your implementation here
       pass

2. Run via Dagster:
   - In UI: Materialize the asset
   - CLI: dagster asset materialize -m dagster_qn.definitions --select my_slide_asset

DEPENDENCIES
------------
Assets may depend on:
- export_analytic_csvs: for data exports
- dbt models: for transformed data
- Other visualization assets: for reusing existing outputs
"""

import os
import subprocess
from pathlib import Path
from dagster import asset, Output, AssetExecutionContext, AssetKey
import json

PROJECT_ROOT = Path(__file__).parents[2]


# ============================================================================
# SLIDE ASSETS
# ============================================================================
# Add new slide-related assets below.

@asset(
    group_name="slides",
    deps=[
        AssetKey(["conclusions_treemap"]),
        AssetKey(["eviconc_alluvial"]),
    ]
)
def python_meetup_slides(context: AssetExecutionContext) -> Output[Path]:
    """
    Render Python meetup presentation slides from Quarto document.
    
    Depends on visualization assets to ensure figures are generated before
    rendering the presentation.
    
    Runs: quarto render python-users-talk-2026/python-meetup-canberra-august.qmd
    Output: python-users-talk-2026/python-meetup-canberra-august.html
    """
    qmd_path = PROJECT_ROOT / "python-users-talk-2026" / "python-meetup-canberra-august.qmd"
    output_path = PROJECT_ROOT / "python-users-talk-2026" / "python-meetup-canberra-august.html"
    
    # Render the Quarto document
    result = subprocess.run(
        ["quarto", "render", str(qmd_path)],
        capture_output=True,
        text=True,
        cwd=PROJECT_ROOT,
    )
    
    # Log output for debugging
    context.log.info(f"Quarto stdout: {result.stdout}")
    if result.returncode != 0:
        context.log.error(f"Quarto stderr: {result.stderr}")
        raise RuntimeError(
            f"Quarto render failed (exit {result.returncode}):\n"
            f"stderr: {result.stderr}\n"
            f"stdout: {result.stdout}"
        )
    
    # Verify the expected HTML output exists
    if not output_path.exists():
        raise RuntimeError(
            f"Quarto render succeeded but expected output not found: {output_path}"
        )
    
    context.log.info(f"Slides rendered to {output_path}")
    return Output(output_path)

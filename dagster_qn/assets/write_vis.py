"""
Dagster assets for generating visualizations from R scripts.

OVERVIEW
--------
This module defines Dagster assets that execute R visualization scripts and 
track their outputs. Each asset runs an R script from analysis-scripts/ and 
produces a PNG figure in figures/.

HOW TO USE
----------
1. Create your R visualization script in analysis-scripts/
   - Script name: my-visualization.R
   - Must save output as: figures/my-visualization.png

2. Add a new asset in this file:
   @asset(
       group_name="analysis",
       deps=[AssetKey(["export_analytic_csvs"])]  # or other dependencies
   )
   def my_visualization(context: AssetExecutionContext) -> Output[Path]:
       return run_vis_script(context, "my-visualization")

3. Run via Dagster:
   - In UI: Materialize the asset
   - CLI: dagster asset materialize -m dagster_qn.definitions --select my_visualization

R SCRIPT REQUIREMENTS
---------------------
Your R script must follow these conventions:

1. **File paths**: Use relative paths from project root
   - Input data: data/source__model__column.csv (or other CSVs in data/)
   - Output: ggsave(plot, filename = 'figures/my-visualization.png', ...)
   
2. **Output format**: Save as PNG to figures/ directory
   - Filename must match: figures/<script-name>.png
   - Use ggsave() with explicit filename parameter
   
3. **Libraries**: Load all required packages at top of script
   library(tidyverse)
   library(ggplot2)
   # etc.
   
4. **Color palettes**: Source shared palettes if needed
   source("analysis-scripts/colour-palettes.R")
   
5. **Script structure**: Should run standalone without arguments
   - No command-line arguments
   - No interactive prompts
   - All paths relative to project root
   - Must complete successfully (exit code 0)

Example R script structure:
   library(tidyverse)
   library(ggplot2)
   
   # Load data
   df <- read_csv("data/source__model__column.csv")
   
   # Create visualization
   plt <- df %>%
     ggplot(aes(x = category, y = count)) +
     geom_bar(stat = "identity")
   
   # Save output
   ggsave(plot = plt, filename = 'figures/my-visualization.png', 
          width = 10, height = 6)

NAMING CONVENTION
-----------------
- Asset name: snake_case (e.g., eviconc_alluvial)
- Script name: kebab-case (e.g., alluvial-R6.R)
- Output file: kebab-case (e.g., alluvial-R6.png)

The script name is passed to run_vis_script() and should match the R script 
filename (without .R extension).

DEPENDENCIES
------------
Assets typically depend on export_analytic_csvs to ensure data is available
before running visualizations. Add other dependencies as needed in the deps list.

TROUBLESHOOTING
---------------
- Check Dagster logs for R stdout/stderr
- Verify R script saves to correct path: figures/<script-name>.png
- Ensure R script can run standalone: Rscript analysis-scripts/my-script.R
- Check PROJECT_ROOT path is correct (should be repo root)
- Common R script errors:
  * "object not found": Check data file paths are relative to project root
  * "No such file or directory": Ensure figures/ directory exists
  * "package not installed": Install missing R packages
  * "non-zero exit status": Check R script for syntax errors or runtime failures
"""

import os
import subprocess
from pathlib import Path
from dagster import asset, Output, AssetExecutionContext, AssetKey
import json

PROJECT_ROOT = Path(__file__).parents[2]


def run_vis_script(
    context: AssetExecutionContext, script_name: str
) -> Output[Path]:
    """
    Execute an R visualization script and return the output path.
    
    The R script must:
    - Be located in analysis-scripts/<script_name>.R
    - Run without arguments from project root directory
    - Save output to figures/<script_name>.png
    - Exit with code 0 on success
    - Use relative paths from project root for all file operations
    
    Args:
        context: Dagster execution context for logging
        script_name: Name of R script (without .R extension) in analysis-scripts/
                    e.g., "conclusions--treemap" for conclusions--treemap.R
    
    Returns:
        Output[Path]: Path to generated PNG file in figures/
    
    Raises:
        RuntimeError: If R script fails or output file not created
    
    Example:
        return run_vis_script(context, "my-visualization")
        # Runs: analysis-scripts/my-visualization.R
        # Expects: figures/my-visualization.png
    """
    script_path = PROJECT_ROOT / "analysis-scripts" / f"{script_name}.R"

    # Execute R script from project root directory
    result = subprocess.run(
        ["Rscript", str(script_path)],
        capture_output=True,
        text=True,
        cwd=PROJECT_ROOT,
    )

    # Log R output for debugging
    context.log.info(f"R stdout: {result.stdout}")
    if result.returncode != 0:
        context.log.error(f"R stderr: {result.stderr}")
        raise RuntimeError(
            f"R script failed (exit {result.returncode}):\n"
            f"stderr: {result.stderr}\n"
            f"stdout: {result.stdout}"
        )

    # Verify the expected PNG output exists
    output_path = PROJECT_ROOT / "figures" / f"{script_name}.png"
    if not output_path.exists():
        raise RuntimeError(
            f"R script succeeded but expected output not found:"
            f" {output_path}"
        )

    context.log.info(f"Output written to {output_path}")
    return Output(output_path)


# ============================================================================
# VISUALIZATION ASSETS
# ============================================================================
# Add new visualization assets below following the same pattern.
# Each asset should call run_vis_script() with the script name.

@asset(
    group_name="analysis",
    deps=[
        AssetKey(["export_analytic_csvs"]),
    ]
)
def conclusions_treemap(context: AssetExecutionContext) -> Output[Path]:
    """
    Generate treemap visualization of conclusion categories.
    Runs: analysis-scripts/conclusions--treemap.R
    Output: figures/conclusions--treemap.png
    """
    return run_vis_script(context, "conclusions--treemap")


@asset(
    group_name="analysis",
    deps=[
        AssetKey(["export_analytic_csvs"]),
    ]
)
def eviconc_alluvial(context: AssetExecutionContext) -> Output[Path]:
    """
    Generate alluvial diagram showing evidence-to-conclusion flows.
    Runs: analysis-scripts/alluvial-R6.R
    Output: figures/alluvial-R6.png
    """
    return run_vis_script(context, "alluvial-R6")

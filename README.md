# questionability

This project explores analyses of how different analysts might decompose a domain question into an analytic question given the same data.

## Structure of this Project

This project uses R's `{targets}` package to manage our analysis pipeline. You don't need to understand `{targets}` in detail to contribute - just think of it as an automated way to run our analyses in the right order.

**Key files and folders:**
- [`_targets.R`](_targets.R) - The main pipeline definition (like a recipe for our analyses)
- [`R/`](R/) - All our custom R functions organized by purpose
- [`data-many-analysts/`](data-many-analysts/) - The raw datasets (eucalyptus and blue tit analyses)
- [`vis/`](vis/) - Generated plots and visualizations  
- [`docs/`](docs/) - Additional documentation and project notes
- [`validation/`](validation/) - Quality checks to ensure our analyses are working correctly

**To run the analyses:**
```r
# Install targets if you haven't already
install.packages("targets")

# Run the full pipeline 
targets::tar_make()

# View transitional data layers
targets::tar_read(analyses_eucalyptus)  # See the processed analyses data
targets::tar_read(analyses_sourcecols_eucalyptus)  # See source column usage data
```

**To view the generated visualizations:**
- Check the [`vis/`](vis/) folder for all plots (`.png` files) and saved data (`.rds` files)
- Example files: `eucalyptus_barplot.png`, `eucalyptus_hairball.png`

**To explore the pipeline:**
```r
# See all available results
targets::tar_manifest()

# Visualize how analyses connect to each other  
targets::tar_visnetwork(targets_only = TRUE)
```

The pipeline automatically handles both eucalyptus and blue tit datasets, creating comparable visualizations for each.

## Minimal Representations of Core Results

The goal is to explore **minimal representations that faithfully align with the experiment's core results, privileging interpretability**. 

## Eucalypt Analysis

The main analysis currently runs on the eucalyptus analyses dataset.
  
Inspect the eucalyptus pipeline:

```r
targets::tar_make()
tar_visnetwork(names = contains("euc"), targets_only=TRUE)
```

The bluetit is running over the same code, including it is busy to look at because every node is duplicated by the pipeline's logic.

## Graph Visualisations

A graph is a network determined by *nodes* and *edges*.

Graph visualisations illustrate the diversity of how analysts decompose. This project explores different graph presentations. 

We are using [`ggraph`](https://ggraph.data-imaginist.com/) to create the visualisations. 

> Todo: add caption highlighting most-popular source columns and outcomes

We also have several more visualisations underway or planned in `docs/storybook-outline.md`.

## Simulation Study

The simulation study was used during development to explore graph structures before real data extraction. 

📄 **[Full simulation documentation](docs/simulation-study.md)**

The simulation pipeline is modularised in [`R/simulation_factory_targets.R`](R/simulation_factory_targets.R) and can be enabled by uncommenting the relevant line in `_targets.R`.
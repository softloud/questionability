# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  seed = 45,
  # Packages required to run the targets in this pipeline:
  packages = c(
    "tibble",
    "readr",
    "dplyr",
    "purrr",
    "tidyr",
    "ggraph",
    "tidygraph",
    "stringr",
    "ggplot2"
  )
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Define targets in the pipeline
# NB use tar_visnetwork(targets_only = TRUE) to make sense of this

list(
  # colour palette
  tar_target(
    name = palette,
    list(
      source_col = "#5898c0",
      outcome = "#C9A227"
    )
  ),

  # simulation factory (modularised in R/simulation_factory_targets.R) ----
  # get_simulation_factory_targets(),

 # many-analysts datasets ----
  # NB: both paths point to same file until bluetit data is added
  tar_map(
    values = tibble::tibble(
      dataset = c("eucalyptus", "bluetit"),
      data_path = c(
        "data-many-analysts/master_data_Charles_euc.csv",
        "data-many-analysts/master_data_Charles_euc.csv"  # TODO: update when bluetit data added
      ),
      dataset_label = c("Eucalyptus", "Blue Tit")
    ),
    names = dataset,
    
    tar_target(raw, readr::read_csv(data_path)),
    tar_target(dat, se_clean_analyses(raw)),
    tar_target(column_index, get_column_index(colnames(dat))),
    tar_target(analyses_sourcecols, get_long(dat, column_index)),
    tar_target(analyses, get_analyses(dat, analyses_sourcecols)),
    tar_target(model_levels, get_model_levels(dat)),
    tar_target(model_summary, get_model_summary(model_levels)),
    tar_target(analysts, get_analysts(analyses)),
    
    # barplots (standard + slide)
    tar_target(
      barplots,
      generate_barplots(analyses_sourcecols, palette, 
        dataset_label = dataset_label, dataset_name = dataset)
    ),
    
    # hairball plots (full + filtered)
    tar_target(
      hairball_plots,
      generate_hairball_plots(analyses, column_index, dataset_name = dataset)
    )
  )

)

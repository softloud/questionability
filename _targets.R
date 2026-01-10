# Load packages required to define the pipeline:
library(targets)
# we may use this later if we deploy as a quarto site
# library(tarchetypes) # Load other packages as needed.

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
    "stringr"
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

  # empirical ----
  tar_target(
    name = emp_raw,
    read_csv("data-many-analysts/master_data_Charles_euc.csv")
  ),

  tar_target(
    name = emp_dat,
    se_clean_analyses(emp_raw)
  ),

  tar_target(
    name = emp_analyses_sourcecols,
    get_long(emp_dat, emp_column_index)
  ),

  tar_target(
    name = emp_analyses,
    get_analyses(emp_dat, emp_analyses_sourcecols)
  ),

  tar_target(
    name = emp_model_levels,
    get_model_levels(emp_dat)
  ),

  tar_target(
    name = emp_model_summary,
    get_model_summary(emp_model_levels)
  ),

  tar_target(
    name = emp_barplot,
    generate_emp_barplot_png(emp_analyses_sourcecols, palette)
  ),

  tar_target(
    name = emp_barplot_slide,
    generate_emp_barplot_png(emp_analyses_sourcecols, 
      palette, pct_cutoff = 0.35, fig_height = 10)
  ),

  tar_target(
    name = emp_column_index,
    get_column_index(colnames(emp_dat))
  ),

  # hairball
  tar_target(
    name = emp_outcome_nodes,
    get_outcome_nodes(emp_analyses)
  ),

  tar_target(
    name = emp_source_col_nodes,
    get_source_col_nodes(emp_analyses, emp_column_index)
  ),

  tar_target(
    name = emp_nodes,
    get_nodes(emp_outcome_nodes, emp_source_col_nodes)
  ),

  tar_target(
    name = emp_source_outcome_edges,
    get_source_outcome_edges(emp_analyses)
  ),

  tar_target(
    name = emp_source_source_edges,
    get_source_source_edges(emp_analyses |> dplyr::filter(n_source_cols >= 2))
  ),

  tar_target(
    name = emp_edges,
    get_edges(emp_source_outcome_edges, emp_source_source_edges)
  ),

  tar_target(
    name = emp_hairball,
    tbl_graph(nodes = emp_nodes, edges = emp_edges
    )
  ),

  tar_target(
    name = emp_hairball_plot,
    plot_horrendogram(emp_hairball)
  ),

  tar_target(
    name = save_emp_hairball,
    ggsave(
      filename = "vis/emp_hairball.png",
      plot = emp_hairball_plot,
      width = 8,
      height = 6
    )),

    tar_target(
      name = emp_hairball_expected_graph,
      # filter the graph to top 25% most analysed variables
      {emp_hairball |>
          activate(nodes) |>
          # todo debug
          filter(n_analyses >= quantile(1:nrow(emp_analyses), 0.50))
      }
    ),

    # assumption plot with expected popular nodes

    tar_target(
      name = emp_hairball_expected_plot,
      plot_horrendogram(
        emp_hairball_expected_graph, label_nodes = TRUE, label_edges = TRUE)
    ),

    tar_target(
      name = save_emp_hairball_expected,
      ggsave(
        filename = "vis/emp_hairball_expected.png",
        plot = emp_hairball_expected_plot,
        width = 8,
        height = 6
      )
    ),

    tar_target(
      emp_analysts,
      get_analysts(emp_analyses)
    )

)

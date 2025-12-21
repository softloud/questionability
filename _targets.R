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
    "tidygraph"
  )
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Define targets in the pipeline
# NB use tar_visnetwork(targets_only = TRUE) to make sense of this

list(

  # simulation parameters --- tweak these to play!
  tar_target(
    name = data_bluetit,
    read_csv("data-many-analysts/blue_tit_data_updated_2020-04-18.csv")
  ),
  tar_target(
    name = n_analyses,
    # n bluetit analyses 142, n eucalyptus 85
    142
  ),
  tar_target(
    name = source_col_range,
    c(4, 15)
  ),
  tar_target(
    source_col_dist,
    list(
      # how many source columns are
      always_used = 3,
      often_used = 4
    )
  ),
  tar_target(
    source_col_use_prob,
    list(
      # how often the often used occur
      often_used = 0.7,
      sometimes_used = 0.05
    )
  ),

  # pipeline --- here be dragons that can break
  tar_target(
    name = column_index,
    get_column_index(colnames(data_bluetit))
  ),
  tar_target(
    name = source_col_likelihood,
    set_source_col_likelihood(
      column_index, source_col_dist, source_col_use_prob)
  ),
  tar_target(
    name = simulated_analyses,
    get_sim_analyses(n_analyses, source_col_range, source_col_likelihood)
  ),
  tar_target(
    name = outcome_nodes, 
    get_outcome_nodes(simulated_analyses)
  ),
  tar_target(
    name = source_col_nodes,
    get_source_col_nodes(simulated_analyses, column_index)
  ),
  tar_target(
    name = nodes,
    get_nodes(outcome_nodes, source_col_nodes)
  ),
  tar_target(
    name = source_outcome_edges,
    get_source_outcome_edges(simulated_analyses)
  ),
  tar_target(
    name = source_source_edges,
    get_source_source_edges(simulated_analyses)
  ),
  tar_target(
    name = edges,
    get_edges(source_outcome_edges, source_source_edges)
  ),

  # graphs
  tar_target(
    name = graph,
    tbl_graph(nodes = nodes, edges = edges
    )
  ),

  tar_target(
    name = graph_popular,
    # filter the graph to top 25% most analysed variables
    {graph |>
      activate(nodes) |>
      filter(n_analyses >= quantile(n_analyses, 0.75))
    }
  ),

  # visualisations
  tar_target(
    name = horrendogram,
    plot_horrendogram(graph)
  ),
  tar_target(
    name = save_horrendogram,
    ggsave(
      filename = "vis/horrendogram.png",
      plot = horrendogram,
      width = 8,
      height = 6
  )),

  tar_target(
    name = plot_graph_popular,
    plot_horrendogram(graph_popular)
  ),

  tar_target(
    name = save_popular,
    ggsave(
      filename = "vis/popular.png",
      plot = plot_graph_popular,
      width = 8,
      height = 6
  )),

  # validation on a single analysis
  tar_target(
    name = single_analysis,
    simulated_analyses |> slice(1)
  ),
  tar_target(
    name = validation_results,
    {
      result <- validate_full(single_analysis, column_index)
      stopifnot("validation failed" = result$all_passed)
      result
    }
  )

)

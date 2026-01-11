#' Build Hairball Graph
#' 
#' Constructs the full hairball graph from analyses data.
#' Uses the existing get_* functions to ensure consistency.
#' 
#' @param analyses The analyses tibble with source_cols and outcome_type
#' @param column_index Column index mapping
#' @return A tidygraph object
build_hairball <- function(analyses, column_index) {
  # use existing functions for consistency
  outcome_nodes <- get_outcome_nodes(analyses)
  source_col_nodes <- get_source_col_nodes(analyses, column_index)
  nodes <- get_nodes(outcome_nodes, source_col_nodes)
  
  source_outcome_edges <- get_source_outcome_edges(analyses)
  source_source_edges <- get_source_source_edges(
    analyses |> dplyr::filter(n_source_cols >= 2)
  )
  edges <- get_edges(source_outcome_edges, source_source_edges)
  
  tidygraph::tbl_graph(nodes = nodes, edges = edges)
}

#' Generate Hairball Plots
#' 
#' Builds hairball graph and generates both full and filtered plots,
#' saving as PNG and RDS files
#' 
#' @param analyses The analyses tibble
#' @param column_index Column index mapping
#' @param dataset_name Machine-readable dataset name for filenames
#' @param quantile_filter Quantile threshold for "expected" filtered plot (default 0.50)
#' @return List with paths to saved files
generate_hairball_plots <- function(analyses, column_index, dataset_name, 
                                     quantile_filter = 0.50) {
  
  # build the graph
  hairball <- build_hairball(analyses, column_index)
  
  # full hairball plot
  p_full <- plot_horrendogram(hairball)
  png_full <- paste0("vis/", dataset_name, "_hairball.png")
  rds_full <- paste0("vis/", dataset_name, "_hairball.rds")
  
  ggplot2::ggsave(filename = png_full, plot = p_full, width = 8, height = 6)
  saveRDS(list(plot = p_full, graph = hairball), rds_full)
  
  # filtered hairball (expected/popular nodes)
  # use same filtering logic as original: quantile of 1:n_analyses
  n_total <- nrow(analyses)
  threshold <- stats::quantile(1:n_total, quantile_filter)
  
  hairball_filtered <- hairball |>
    tidygraph::activate(nodes) |>
    dplyr::filter(n_analyses >= threshold)
  
  p_filtered <- plot_horrendogram(hairball_filtered, label_nodes = TRUE, label_edges = TRUE)
  png_filtered <- paste0("vis/", dataset_name, "_hairball_expected.png")
  rds_filtered <- paste0("vis/", dataset_name, "_hairball_expected.rds")
  
  ggplot2::ggsave(filename = png_filtered, plot = p_filtered, width = 8, height = 6)
  saveRDS(list(plot = p_filtered, graph = hairball_filtered), rds_filtered)
  
  # return paths
  list(
    full_png = png_full,
    full_rds = rds_full,
    filtered_png = png_filtered,
    filtered_rds = rds_filtered
  )
}

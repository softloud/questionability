#' Validate a single analysis is correctly represented in the final graph
#'
#' Takes one analysis and checks that the final aggregated graph contains:
#' - The outcome node
#' - All source column nodes used
#' - All expected edges (source→outcome and source→source)
#'
#' @param single_analysis A single row from simulated_analyses
#' @param graph The final tbl_graph from the pipeline
#' @param column_index The column index lookup table
#' @return A list with validation results
validate_analysis_in_graph <- function(single_analysis, graph, column_index) {
  library(tidygraph)
  library(purrr)
  
  # Extract graph data
  graph_nodes <- graph |> activate(nodes) |> as_tibble()
  graph_edges <- graph |> activate(edges) |> as_tibble()
  
  # What this analysis should contribute
  outcome <- single_analysis$outcome_type
  source_cols <- single_analysis$source_cols[[1]]
  n_source_cols <- length(source_cols)
  
  # Get column names for source cols
  source_col_names <- column_index |>
    filter(col_index %in% source_cols) |>
    pull(col_name)
  
  # Check nodes exist
  outcome_node_exists <- outcome %in% graph_nodes$node
  source_nodes_exist <- all(source_cols %in% graph_nodes$node)
  
  # Check source → outcome edges exist
  so_edges_exist <- all(vapply(source_cols, function(sc) {
    from_idx <- which(graph_nodes$node == sc)
    to_idx <- which(graph_nodes$node == outcome)
    if (length(from_idx) == 0 || length(to_idx) == 0) return(FALSE)
    any(graph_edges$from == from_idx & graph_edges$to == to_idx)
  }, logical(1)))
  
  # Check source → source edges exist (pairwise)
  if (n_source_cols >= 2) {
    source_pairs <- combn(source_cols, 2, simplify = FALSE)
    ss_edges_exist <- all(vapply(source_pairs, function(pair) {
      idx1 <- which(graph_nodes$node == pair[1])
      idx2 <- which(graph_nodes$node == pair[2])
      if (length(idx1) == 0 || length(idx2) == 0) return(FALSE)
      any(
        (graph_edges$from == idx1 & graph_edges$to == idx2) |
        (graph_edges$from == idx2 & graph_edges$to == idx1)
      )
    }, logical(1)))
  } else {
    ss_edges_exist <- TRUE
  }
  
  checks <- list(
    outcome_node_exists = outcome_node_exists,
    all_source_nodes_exist = source_nodes_exist,
    all_source_outcome_edges_exist = so_edges_exist,
    all_source_source_edges_exist = ss_edges_exist
  )
  
  list(
    analysis = single_analysis,
    outcome = outcome,
    source_cols = source_cols,
    source_col_names = source_col_names,
    checks = checks,
    all_passed = all(unlist(checks))
  )
}

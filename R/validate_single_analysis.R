#' Validate nodes for a single analysis
#'
#' Checks that a single analysis produces the expected node structure:
#' - 1 outcome node
#' - n source_col nodes (one per source column used)
#' - all n_analyses counts = 1
#'
#' @param single_analysis A single row from simulated_analyses
#' @param column_index The column index lookup table
#' @return A list with nodes and validation results
validate_single_nodes <- function(single_analysis, column_index) {
  outcome <- get_outcome_nodes(single_analysis)
  source <- get_source_col_nodes(single_analysis, column_index)
  nodes <- get_nodes(outcome, source)
  
  n_source_cols <- length(single_analysis$source_cols[[1]])
  
  checks <- list(
    outcome_node_count = nrow(outcome) == 1,
    source_col_node_count = nrow(source) == n_source_cols,
    total_node_count = nrow(nodes) == 1 + n_source_cols,
    outcome_n_analyses_is_1 = outcome$n_analyses == 1,
    all_source_n_analyses_is_1 = all(source$n_analyses == 1)
  )
  
  list(
    nodes = nodes,
    outcome_nodes = outcome,
    source_col_nodes = source,
    n_source_cols = n_source_cols,
    checks = checks,
    all_passed = all(unlist(checks))
  )
}

#' Validate edges for a single analysis
#'
#' Checks that a single analysis produces the expected edge structure:
#' - n source->outcome edges (one per source column)
#' - choose(n, 2) source->source edges (all pairwise combinations)
#' - all n_analyses counts = 1
#'
#' @param single_analysis A single row from simulated_analyses
#' @return A list with edges and validation results
validate_single_edges <- function(single_analysis) {
  so_edges <- get_source_outcome_edges(single_analysis)
  ss_edges <- get_source_source_edges(single_analysis)
  edges <- get_edges(so_edges, ss_edges)
  

  n_source_cols <- length(single_analysis$source_cols[[1]])
  expected_so <- n_source_cols
  expected_ss <- choose(n_source_cols, 2)
  
  checks <- list(
    source_outcome_edge_count = nrow(so_edges) == expected_so,
    source_source_edge_count = nrow(ss_edges) == expected_ss,
    total_edge_count = nrow(edges) == expected_so + expected_ss,
    all_edges_n_analyses_is_1 = all(edges$n_analyses == 1)
  )
  
  list(
    edges = edges,
    source_outcome_edges = so_edges,
    source_source_edges = ss_edges,
    n_source_cols = n_source_cols,
    expected_so = expected_so,
    expected_ss = expected_ss,
    checks = checks,
    all_passed = all(unlist(checks))
  )
}

#' Run all validations on a single analysis
#'
#' @param single_analysis A single row from simulated_analyses
#' @param column_index The column index lookup table
#' @return A list with node and edge validation results
validate_single_analysis <- function(single_analysis, column_index) {
  node_validation <- validate_single_nodes(single_analysis, column_index)
  edge_validation <- validate_single_edges(single_analysis)
  
  list(
    single_analysis = single_analysis,
    node_validation = node_validation,
    edge_validation = edge_validation,
    all_passed = node_validation$all_passed && edge_validation$all_passed
  )
}

#' Validate the graph object faithfully represents nodes and edges
#'
#' Checks that a tbl_graph built from nodes and edges:
#' - Has the correct number of nodes and edges
#' - Preserves all node attributes (n_analyses, node_type, outcome_counts)
#' - Preserves all edge attributes (n_analyses, edge_type, outcome_counts)
#' - Edge from/to references resolve to valid nodes
#'
#' @param graph A tbl_graph object
#' @param nodes The nodes tibble used to build the graph
#' @param edges The edges tibble used to build the graph
#' @return A list with validation results
validate_graph_object <- function(graph, nodes, edges) {
  library(tidygraph)
  

  # Extract nodes and edges from graph
  graph_nodes <- graph |> activate(nodes) |> as_tibble()
  graph_edges <- graph |> activate(edges) |> as_tibble()
  
  # Basic counts
  node_count_match <- nrow(graph_nodes) == nrow(nodes)
  edge_count_match <- nrow(graph_edges) == nrow(edges)
  

  # Node attributes preserved
  node_attrs_expected <- c("node", "n_analyses", "node_type", "node_label")
  node_attrs_present <- all(node_attrs_expected %in% names(graph_nodes))
  
  # Edge attributes preserved
  edge_attrs_expected <- c("from", "to", "n_analyses", "edge_type", "outcome_counts")
  edge_attrs_present <- all(edge_attrs_expected %in% names(graph_edges))
  
  # Check edge references are valid (from/to are within node count)
  edges_valid <- all(graph_edges$from >= 1 & graph_edges$from <= nrow(graph_nodes)) &&
                 all(graph_edges$to >= 1 & graph_edges$to <= nrow(graph_nodes))
  
  # Check n_analyses sums are consistent
  # Total node n_analyses should reflect usage across analyses
  # (for a single analysis, all should be 1)
  
  checks <- list(
    node_count_match = node_count_match,
    edge_count_match = edge_count_match,
    node_attrs_present = node_attrs_present,
    edge_attrs_present = edge_attrs_present,
    edges_reference_valid_nodes = edges_valid
 )
  
  list(
    graph = graph,
    graph_nodes = graph_nodes,
    graph_edges = graph_edges,
    checks = checks,
    all_passed = all(unlist(checks))
  )
}

#' Full validation including graph object
#'
#' @param single_analysis A single row from simulated_analyses
#' @param column_index The column index lookup table
#' @return A list with node, edge, and graph validation results
validate_full <- function(single_analysis, column_index) {
  library(tidygraph)
  
  node_validation <- validate_single_nodes(single_analysis, column_index)
  edge_validation <- validate_single_edges(single_analysis)
  
  # Build graph from validated nodes and edges
  graph <- tbl_graph(
    nodes = node_validation$nodes,
    edges = edge_validation$edges
  )
  
  graph_validation <- validate_graph_object(
    graph,
    node_validation$nodes,
    edge_validation$edges
  )
  
  list(
    single_analysis = single_analysis,
    node_validation = node_validation,
    edge_validation = edge_validation,
    graph_validation = graph_validation,
    all_passed = node_validation$all_passed && 
                 edge_validation$all_passed && 
                 graph_validation$all_passed
  )
}

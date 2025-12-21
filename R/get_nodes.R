get_outcome_nodes <- function(analyses) {
  # count how many analyses used each outcome
  analyses |>
    group_by(outcome_type) |>
    summarise(
      # count how many analyses used each outcome
      n_analyses = n()
    ) |>
    mutate(
      node_label = outcome_type,
      node_type = 'outcome'
    )
}

get_source_col_nodes <- function(analyses, column_index) {
  # count how many analyses used each source_col
  analyses |>
    select(analysis_id, source_cols, outcome_type) |>
    unnest(c(source_cols)) |>
    select(analysis_id, source_col = source_cols) |>
    group_by(source_col) |>
    summarise(n_analyses = n()) |>
    left_join(column_index, by = c("source_col" = "col_index")) |>
    mutate(
      node_type = 'source_col') |>
    rename(node_label = col_name)
}

get_nodes <- function(outcome_nodes, source_col_nodes) {
  bind_rows(
    outcome_nodes |>
      rename(node = outcome_type),
    source_col_nodes |>
      rename(node = source_col))
}


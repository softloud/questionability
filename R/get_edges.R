get_source_outcome_edges <- function(analyses) {
  analyses |>
  select(source_cols, outcome_type, analysis_id) |>
  unnest(source_cols) |>
  rename(from = source_cols,
         to = outcome_type) |>
  mutate(edge_type = 'source_outcome') 
}

get_source_source_edges <- function(analyses) {
  analyses |>
  select(analysis_id, source_cols, outcome_type) |>
  mutate(
    edges = map(source_cols,
      ~combn(.x, 2, simplify = FALSE) |> 
        map(~tibble(
          from = .x[1],
          to   = .x[2]
        )
    )
  )) |>
  select(edges, analysis_id, outcome_type) |>
  unnest(edges) |>
  unnest(edges) |>
  ungroup() |>
  mutate(edge_type = 'source_source')
}

get_edges <- function(source_outcome_edges, source_source_edges) {
  bind_rows(
    source_outcome_edges,
    source_source_edges
  ) |>
  group_by(from, to, edge_type, outcome_type) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(from, to, edge_type) |>
  summarise(
    n_analyses = sum(n),
    outcome_counts = list(setNames(n, outcome_type)),
    .groups = "drop"
  )
}
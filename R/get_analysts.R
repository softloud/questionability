get_analysts <- function(analyses) {
  analyses |>
    dplyr::group_by(analyst_id) |>
    dplyr::summarise(
      n_analyses = n(),
      source_cols = list(unique(unlist(source_cols))),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      n_unique_source_cols = lengths(source_cols)
    ) |>
    arrange(desc(n_analyses))
}
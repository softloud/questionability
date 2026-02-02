get_analysis_sourcecols <- function(analysis_id, sourcecols_dat) {
  sourcecols_dat |>
    dplyr::filter(analysis_id == !!analysis_id, col_used == 1) |>
    dplyr::pull(source_col)
}

get_analyses <- function(analyses_dat, sourcecols_dat) {
  analyses_dat |>
  mutate(model_id = str_c(
    linear_model, "--", link_function_reported, "--", model_subclass),
    model_id = if_else(is.na(model_id), "NA", model_id),
    # this determines the outcome nodes
    outcome_type = model_id,
    source_cols = purrr::map(
      analysis_id,
      ~ get_analysis_sourcecols(.x, sourcecols_dat)
    ),
    n_source_cols = purrr::map_int(
      source_cols,
      ~ length(.x)
    )) |>
  select(contains("_id"), source_cols, n_source_cols, outcome_type)
}
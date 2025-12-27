get_analysis_sourcecols <- function(analysis_id, sourcecols_dat) {
  sourcecols_dat |>
    dplyr::filter(analysis_id == !!analysis_id, col_used == 1) |>
    dplyr::pull(source_col)
}

get_analyses <- function(analyses_dat, sourcecols_dat) {
  analyses_dat |>
  mutate(model_id = str_c(
    linear_model, "--", link_function_reported, "--", model_subclass),
    source_cols = purrr::map(
      analysis_id,
      ~ get_analysis_sourcecols(.x, sourcecols_dat)
    )) |>
  select(contains("_id"), source_cols)
}
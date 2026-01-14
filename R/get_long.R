get_long <- function(wide_dat, column_index) {
  wide_dat %>%
  dplyr::select(
    -analyst_id, -estimate, -link_function_reported, -linear_model, -model_subclass) %>%
    tidyr::pivot_longer(
      cols = -analysis_id, 
      names_to = "source_col",
      values_to = "col_used"
    ) |>
    dplyr::mutate(
      col_used = if_else(is.na(col_used), 0, col_used)
    ) |>
    dplyr::left_join(column_index, by = c("source_col" = "col_name"))
}
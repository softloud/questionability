get_long <- function(wide_dat) {
  wide_dat %>%
  dplyr::select(
    -estimate, -link_function_reported, -linear_model, -model_subclass) %>%
    tidyr::pivot_longer(
      cols = -analysis_id, 
      names_to = "source_col",
      values_to = "col_used"
    ) |>
    dplyr::mutate(
      col_used = if_else(is.na(col_used), 0, col_used)
    )
}
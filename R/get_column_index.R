get_column_index <- function(column_names) {
  tibble(
    col_name = column_names,
    col_index = paste0("col_", seq_len(length(column_names)))
  )
}
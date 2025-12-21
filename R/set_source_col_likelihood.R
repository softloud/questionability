set_source_col_likelihood <- function(
  column_index, source_col_dist, source_col_use_prob) {

column_index |>
  # shuffle so that there's a randomness to which source_cols are chosen
  slice_sample(n = nrow(column_index), replace = FALSE) |>
  # attach a selection probability to each source_col
  # this is where we tweak how many are used in all
  # how many are used in some
  # how many are sometimes used
  mutate(
    selection_probability =
      c(rep(1, source_col_dist$always_used),
      rep(source_col_use_prob$often_used, source_col_dist$often_used),
      rep(
        source_col_use_prob$sometimes_used, 
        nrow(column_index) - source_col_dist$always_used -
          source_col_dist$often_used))
  ) 
}


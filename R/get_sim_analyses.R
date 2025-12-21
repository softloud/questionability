source_cols_trial <- function(source_col_likelihood, source_col_n) {
  # a more refined sampling technique could be used
  # but I think it would be overengineering with no purpose 
  # as we already have the experimental results
  source_col_likelihood |>
    mutate(
      # sample source_cols
      selected = map_lgl(selection_probability, 
        ~sample(c(TRUE, FALSE), prob =c(.x, 1 - .x), size = 1)
        )
    ) |>
    filter(selected == TRUE) |>
    head(source_col_n) |>
    pull(col_index)
}

get_sim_analyses <- function(
  n_analyses, source_col_range, source_col_likelihood) {
  tibble(
  analysis_id = paste0('analysis_', seq(1, n_analyses)),
  # same sampling reasoning as above
  n_source_cols = sample(
    source_col_range[1]:source_col_range[2],
    size = n_analyses, replace = TRUE),
  # randomly assign four distributions for the outcome
  outcome_type = sample(c('binomial', 'gaussian', 'poisson', 'logit'),
    size = n_analyses, replace = TRUE)
) |>
  mutate(
    source_cols = map(n_source_cols, 
      ~source_cols_trial(source_col_likelihood, source_col_n = .x)
      )
  )
}
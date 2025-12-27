get_model_levels <- function(dat) {
  dat |>
    dplyr::group_by(
      link_function_reported, linear_model, model_subclass
    ) |>
    dplyr::summarise(n_analyses = dplyr::n(), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(n_analyses))
}

get_model_summary <- function(model_levels) {
  model_levels |>
    summarise(
      link_distinct = dplyr::n_distinct(link_function_reported),
      linear_distinct = dplyr::n_distinct(linear_model),
      subclass_distinct = dplyr::n_distinct(model_subclass)
    )
} 
get_analysts <- function(analyses) {
  analyses |>
    dplyr::mutate(
      analyst = stringr::str_extract(analysis_id, "^[A-Za-z]+")
    ) |>
    dplyr::count(analyst, name = "n_analyses") |>
    arrange(desc(n_analyses))
}
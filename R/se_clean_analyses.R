#' Clean source entity: wide by analysis data

se_clean_analyses <- function(wide_by_analysis) {
  wide_by_analysis |>
    rename(analysis_id = id_col) |>
    dplyr::mutate(
      analyst_id = stringr::str_extract(analysis_id, "^[A-Za-z]+")
    )

}
#' Generate a single barplot
#' 
#' Internal helper to create one barplot variant
#' @keywords internal
make_barplot <- function(sourcecols_dat, palette, pct_cutoff, fig_height, dataset_label) {
  
  total_analyses <- dplyr::n_distinct(sourcecols_dat$analysis_id)

  plot_dat <- sourcecols_dat |>
    dplyr::group_by(source_col) |>
    dplyr::summarise(n_used = sum(col_used), .groups = "drop") |>
    dplyr::mutate(
      prop = n_used / total_analyses,
      prop_label = stringr::str_c(round(prop * 100), "%"),
      prop_facet = stringr::str_c("~", round(prop * 10), "0%"),
      prop_facet = factor(prop_facet, levels = sort(unique(prop_facet), decreasing = TRUE)),
      over_pct_cutoff = prop > pct_cutoff
    ) 
  
  source_cols_omitted <- plot_dat |>
    dplyr::filter(!over_pct_cutoff) |>
    dplyr::pull(source_col) |>
    length()

  cap_text <- stringr::str_c(
    "Size of bar relative to proportion of proportion group. ",
    "Source columns used in under ", 
    round(pct_cutoff * 100), "% of analyses omitted: ",
    source_cols_omitted, " source cols not shown. ",
    "Variability in transformation of source columns not considered."
  ) |> 
    stringr::str_wrap(width = 100)
  
  subtitle_text <- stringr::str_c(
    "By count of analyses (",
     total_analyses,
    " total analyses), grouped and labelled by proportion"
  ) |> 
    stringr::str_wrap(width = 60)

  title_text <- stringr::str_c(
    "Source column preferences: ",
    dataset_label,
    " analyses"
  ) |> 
    stringr::str_wrap(width = 50)

  plot_dat |>
    dplyr::filter(over_pct_cutoff) |>
    ggplot2::ggplot(ggplot2::aes(x = reorder(source_col, n_used), y = n_used)) +
    ggplot2::geom_col(alpha = 0.5, fill = palette$source_col) +
    ggplot2::geom_text(ggplot2::aes(label = prop_label), color = "black", hjust = -0.2) +
    ggplot2::facet_grid(prop_facet ~ ., scales = "free") +
    ggplot2::coord_flip() +
    ggplot2::labs(x = "", 
      y = "Number of analyses in which source column used", 
      title = title_text, 
      subtitle = subtitle_text, 
      caption = cap_text) +
    ggplot2::theme_minimal(base_size = 20) +
    ggplot2::theme(strip.text.y = ggplot2::element_text(angle = 0, size = 25))
}

#' Generate All Barplots for a Dataset
#' 
#' Creates both standard and slide barplots, saving as PNG and RDS
#' 
#' @param sourcecols_dat Long-format data with source column usage
#' @param palette Colour palette list
#' @param dataset_label Human-readable dataset name for plot title
#' @param dataset_name Machine-readable dataset name for filename
#' @return List with paths to saved files
generate_barplots <- function(sourcecols_dat, palette, dataset_label, dataset_name) {
  
  # Standard barplot (15% cutoff)
  p_standard <- make_barplot(sourcecols_dat, palette, 
                              pct_cutoff = 0.15, fig_height = 15, 
                              dataset_label = dataset_label)
  png_standard <- paste0("vis/", dataset_name, "_barplot.png")
  rds_standard <- paste0("vis/", dataset_name, "_barplot.rds")
  ggplot2::ggsave(filename = png_standard, plot = p_standard, width = 12, height = 15)
  saveRDS(p_standard, rds_standard)
  
 # Slide barplot (35% cutoff, shorter)
  p_slide <- make_barplot(sourcecols_dat, palette, 
                           pct_cutoff = 0.35, fig_height = 10, 
                           dataset_label = dataset_label)
  png_slide <- paste0("vis/", dataset_name, "_barplot_slide.png")
  rds_slide <- paste0("vis/", dataset_name, "_barplot_slide.rds")
  ggplot2::ggsave(filename = png_slide, plot = p_slide, width = 12, height = 10)
  saveRDS(p_slide, rds_slide)
  
  list(
    standard_png = png_standard,
    standard_rds = rds_standard,
    slide_png = png_slide,
    slide_rds = rds_slide
  )
}

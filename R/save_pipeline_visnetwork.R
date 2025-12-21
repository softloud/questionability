#' Save pipeline visualisation as PNG
#'
#' This function generates the targets pipeline visualisation and saves it as a PNG for use in the README.
#' Requires the webshot2 and htmlwidgets packages.
#' @param out_png Path to save the PNG file (default: "vis/pipeline.png")
#' @param out_html Path to save the intermediate HTML file (default: "vis/pipeline.html")
#' @param ... Additional arguments passed to tar_visnetwork()
save_pipeline_visnetwork <- function(out_png = "vis/pipeline.png", out_html = "vis/pipeline.html", ...) {
  net <- targets::tar_visnetwork(targets_only = TRUE, ...)
  htmlwidgets::saveWidget(net, out_html, selfcontained = TRUE)
  webshot2::webshot(out_html, file = out_png, vwidth = 1200, vheight = 900)
  message("Pipeline visualisation saved to ", out_png)
  invisible(out_png)
}

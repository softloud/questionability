plot_horrendogram <- function(graph, label_edges = FALSE, label_nodes = FALSE) {

  p <-
    ggraph(graph, 
    layout = "fr", weights = n_analyses
    ) +
      geom_edge_link(aes(
        alpha = n_analyses,
        linetype = edge_type,
        label = if (label_edges) n_analyses else NULL
        ),
        colour = "grey60",
        angle_calc = "along",
        label_dodge = unit(2, "mm"),
        label_size = 3
        ) +
      geom_node_point(aes(
        colour = node_type,
        size = n_analyses, 
        shape = node_type)) +
      scale_edge_linetype_manual(
        # change source_source edges to blank to just see outcomes
        values = c("source_source" = "dotted", "source_outcome" = "solid")
      ) + 
      theme_graph() +
        scale_colour_manual(
        values = c("source_col" = "#5898c0", "outcome" = "#C9A227")
      )

    if (label_nodes) {
      p <- p +
        geom_node_text(aes(label = node_label), repel = TRUE, size = 3)
    }
  
  return(p)

}
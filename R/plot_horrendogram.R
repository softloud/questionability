plot_horrendogram <- function(graph) {
  ggraph(graph, layout = "fr") +
    geom_edge_link(aes(
      alpha = n_analyses,
      linetype = edge_type
      ),
      colour = "grey60"
      ) +
    geom_node_point(aes(
      colour = node_type,
      size = n_analyses, 
      shape = node_type)) +
    scale_edge_linetype_manual(
      values = c("source_source" = "dashed", "source_outcome" = "solid")
    ) +
    theme_graph() +
    scale_colour_manual(values = c("source_col" = "#6699CC", "outcome" = "#CC6677"))
}
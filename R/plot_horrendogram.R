plot_horrendogram <- function(graph) {
  ggraph(graph, 
  layout = "fr", weights = n_analyses
  ) +
  # geom_edge_link(aes(alpha = n_analyses, label = n_analyses), angle_calc = "along", label_dodge = unit(2, "mm")) +
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
      # change source_source edges to blank to just see outcomes
      values = c("source_source" = "dotted", "source_outcome" = "solid")
    ) + #geom_node_text(aes(label = node_label), repel = TRUE, size = 3) +
    theme_graph() +
      scale_colour_manual(
      values = c("source_col" = "#5898c0", "outcome" = "#C9A227")
    )
}
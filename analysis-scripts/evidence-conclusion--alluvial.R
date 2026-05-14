library(tidyverse)
library(ggalluvial)

# left side: evidence categories (column_category)
# right side: conclusion directions (conclusion_direction)
# flow: number of teams (n_teams)

df <- read_csv("data/source__model__column.csv") %>%
  group_by(source_label, column_category, conclusion_category_label, conclusion_direction) %>%
  summarise(n_teams = n_distinct(team_id)) %>%
  ungroup()

plt_fn <- function(df, filtered_n = NULL) {
  if (!is.null(filtered_n)) {
    df <- df %>%
      filter(n_teams > filtered_n)
    caption <- paste0("Combinations < ", filtered_n, " teams are not shown")
  } else {
    caption <- "All combinations are shown"
  }

  df %>%
    # filter(n_teams > 10) %>%
    mutate(
      column_category = 
        str_replace_all(column_category, "_", " ") %>% str_wrap(width = 10),
      conclusion_category_label = 
        str_replace_all(conclusion_category_label, "_", " ") %>% 
        str_wrap(width = 10),
    ) %>%
  ggplot(
    aes(
      axis1 = column_category,
      axis2 = conclusion_category_label,
      axis3 = conclusion_direction,
      y = n_teams
    )
  ) +
    geom_alluvium(aes(fill = conclusion_direction), 
      width = 0.5) +
    geom_stratum(width = 0.5) +
    geom_text(
      size = 2,
      stat = "stratum", aes(label = after_stat(stratum))) +
    scale_x_discrete(
      limits = c("column_category", "conclusion_category_label", "conclusion_direction"),
      labels = c("Evidence type", "Conclusion", "Direction"),
      expand = c(0.1, 0.1)
    ) +
    labs(
      title = "Proportion of teams that chose evidence, conclusion, and direction combinations",
      fill = "Conclusion direction",
      y = "",
      caption = caption) +
    theme_minimal(
      base_size = 15
    ) +
    facet_grid(. ~ source_label) +
    theme(
      panel.grid = element_blank(),
      axis.text.y = element_blank(),
      legend.position = "bottom")
}
ggsave(plot = plt_fn(df), filename = 'figures/conclusions-alluvial.png', width = 12, height = 8)
ggsave(plot = plt_fn(df, filtered_n = 10), filename = 'figures/conclusions-alluvial-filtered-10.png', width = 12, height = 8)
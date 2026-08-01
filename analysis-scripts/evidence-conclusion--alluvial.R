library(tidyverse)
library(ggalluvial)

# left side: evidence categories (column_category)
# right side: conclusion directions (conclusion_direction)
# flow: number of teams (n_teams)

raw_df <- read_csv("data/source__model__column.csv") 

# load conclusions palette
source("analysis-scripts/colour-palettes.R")

df <- raw_df %>%
  filter(conclusion_certainty == "conclusive") %>%
  group_by(source_label, column_category, conclusion_certainty, conclusion_direction) %>%
  summarise(n_teams = n_distinct(team_id)) %>%
  ungroup()

raw_df |>
  filter(conclusion_certainty == "conclusive") %>%
  group_by(source_label) |>
  summarise(total_teams = n_distinct(team_id)) 
  
plt_fn <- function(df, filtered_n = NULL) {
  if (!is.null(filtered_n)) {
    df <- df %>%
      filter(n_teams > filtered_n)
    caption <- paste0("Combinations < ", filtered_n, " teams are not shown")
  } else {
    caption <- "All combinations are shown"
  }
  
  # Calculate actual unique teams per category (accounting for teams choosing multiple categories)
  col_cat_counts <- raw_df %>%
    filter(conclusion_certainty == "conclusive") %>%
    group_by(source_label, column_category) %>%
    summarise(unique_teams = n_distinct(team_id), .groups = "drop")
  
  concl_dir_counts <- raw_df %>%
    filter(conclusion_certainty == "conclusive") %>%
    group_by(source_label, conclusion_direction) %>%
    summarise(unique_teams = n_distinct(team_id), .groups = "drop")

  plot_df <- df %>%
    # Join the unique team counts
    left_join(col_cat_counts, by = c("source_label", "column_category")) %>%
    rename(col_cat_unique = unique_teams) %>%
    left_join(concl_dir_counts, by = c("source_label", "conclusion_direction")) %>%
    rename(concl_dir_unique = unique_teams) %>%
    mutate(
      # Create labeled factors with unique team counts
      column_category_labeled = paste0(
        str_replace_all(column_category, "_", " ") %>% str_wrap(width = 10),
        " (", col_cat_unique, ")"
      ) %>%
        fct_reorder(n_teams, sum, .desc = TRUE),
      
      conclusion_direction_labeled = paste0(
        conclusion_direction, " (", concl_dir_unique, ")"
      ) %>%
        fct_reorder(n_teams, sum, .desc = TRUE),
      
      conclusion_certainty = 
        str_replace_all(conclusion_certainty, "_", " ") %>% 
        str_wrap(width = 10)
    )

  plot_df %>%
  ggplot(
    aes(
      axis1 = column_category_labeled,
      axis2 = conclusion_direction_labeled,
      y = n_teams
    )
  ) +
    geom_alluvium(aes(fill = conclusion_direction_labeled), 
      width = 0.5) +
    geom_stratum(width = 0.5) +
    geom_text(
      size = 2,
      stat = "stratum", 
      aes(label = after_stat(stratum))) +
    scale_x_discrete(
      limits = c("column_category", "conclusion_certainty"),
      labels = c("Evidence type", "Conclusion"),
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
    scale_fill_manual(values = conclusion_palette) +
    facet_grid(. ~ source_label) +
    theme(
      panel.grid = element_blank(),
      axis.text.y = element_blank(),
      legend.position = "bottom")
}
ggsave(plot = plt_fn(df), filename = 'figures/conclusions-alluvial.png', width = 12, height = 8)
ggsave(plot = plt_fn(df, filtered_n = 10), filename = 'figures/conclusions-alluvial-filtered-10.png', width = 12, height = 8)

## debugging exploration

raw_df |> 
  select(source_id, column_category, team_id) |>
  nest(column_categories = column_category) |>
  mutate(
    grass_in = map_lgl(column_categories, ~ "grass" %in% .x$column_category),
  ) |>
  filter(!grass_in, source_id != "tit")


library(tidyverse)
library(treemapify)

# Load the data
data <- read_csv("data/source__team.csv")

# load conclusions palette
source("analysis-scripts/colour-palettes.R")

# treemap
treemap_plot <- function(source_team_data) {
    source_team_data %>%
  group_by(source_label, conclusion_direction, conclusion_certainty) %>%
  summarise(n_teams = n()) %>%
  mutate(
    n_teams_label = str_c ("teams = ", n_teams)
  ) %>%
  ggplot(aes(
    area = n_teams, 
    fill = conclusion_direction,
    subgroup = conclusion_direction, 
    label = conclusion_certainty)) +
  geom_treemap() +
  geom_treemap_text(colour = "white", size = 15) +
  geom_treemap_text(
    aes(label = n_teams_label), colour = "white", place = "bottom", size = 10) +
  scale_fill_manual(values = conclusion_palette) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.background = element_rect(fill = "transparent", color = NA),
    legend.position = "bottom",
    legend.direction = "horizontal"
  )
  }

all_data_treemap <- treemap_plot(data) + facet_wrap(~source_label)

ggsave('figures/conclusions--treemap.png', 
  plot = all_data_treemap, width = 10, height = 6, bg = "transparent")
write_rds(all_data_treemap, file = "figures/rds/conclusions--treemap.rds")


conclusive_qualified_treemap <- data %>%
  filter(conclusion_certainty %in% c("conclusive", "qualified")) %>%
  treemap_plot() + 
  facet_wrap(conclusion_certainty ~ source_label)

ggsave('figures/conclusions--treemap--conclusive-qualified.png', 
  plot = conclusive_qualified_treemap, width = 10, height = 6, bg = "transparent")
write_rds(conclusive_qualified_treemap, file = "figures/rds/conclusions--treemap--conclusive-qualified.rds")

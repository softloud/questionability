library(tidyverse)
library(treemapify)

# Load the data
data <- read_csv("data/source__team.csv")

# load conclusions palette
source("analysis-scripts/colour-palettes.R")

# treemap
data %>%
  filter(conclusion_direction != "missing") %>%
  group_by(source_label, conclusion_direction, conclusion_category) %>%
  summarise(n_teams = n()) %>%
  mutate(
    n_teams_label = str_c ("teams = ", n_teams)
  ) %>%
  ggplot(aes(
    area = n_teams, 
    fill = conclusion_direction,
    subgroup = conclusion_direction, 
    label = conclusion_category)) +
  geom_treemap() +
  geom_treemap_text(colour = "white", size = 15) +
  geom_treemap_text(
    aes(label = n_teams_label), colour = "white", place = "bottom", size = 10) +
  scale_fill_manual(values = conclusion_palette) +
  facet_wrap(~source_label) +
  theme_minimal()

ggsave('figures/conclusions-treemap.png', width = 10, height = 6)

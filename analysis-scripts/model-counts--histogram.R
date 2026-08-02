library(tidyverse)

raw_dat <- read_csv("data/source__model.csv")
source_dat <- read_csv("data/source.csv")

histplot <- raw_dat %>%
  left_join(source_dat, by = "source_id") %>%
  group_by(source_id, source_label, team_id) %>%
  summarise(
    n_models = n_distinct(model_id)
  ) %>%
  ungroup() %>%
  ggplot(aes(x = n_models)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(
    title = "Distribution of the number of models per team",
    x = "Number of models",
    y = "Count of teams"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    axis.ticks = element_line(color = "gray80")
  ) +
  facet_wrap(~source_label, scales = "free_y")


ggsave("figures/model-counts--histogram.png", 
  plot = histplot, width = 10, height = 6, dpi = 300)
write_rds(histplot, file = "figures/rds/model-counts--histogram.rds")

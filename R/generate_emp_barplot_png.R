generate_emp_barplot_png <- function(
  sourcecols_dat, palette, pct_cutoff = 0.15, fig_height = 15, 
  domain_question_label = "Eucalyptus") {

  # plot data
  total_analyses <- n_distinct(sourcecols_dat$analysis_id)

  plot_dat <- sourcecols_dat |>
  group_by(source_col) |>
  summarise(n_used = sum(col_used), .groups = "drop") |>
  mutate(
    prop = n_used / total_analyses,
    prop_label = str_c(round(prop * 100), "%"),
    prop_facet = str_c("~", round(prop * 10), "0%"),
    prop_facet = factor(
      prop_facet, levels = sort(unique(prop_facet), decreasing = TRUE)),
    over_pct_cutoff = prop > pct_cutoff
  ) 
  
  # plot text
  source_cols_omitted <- plot_dat |>
    filter(!over_pct_cutoff) |>
    pull(source_col) |>
    length()

  cap_text <- str_c(
    "Size of bar relative to proportion of proportion group. ",
    "Source columns used in under ", 
    round(pct_cutoff * 100), "% of analyses omitted: ",
    source_cols_omitted, " source cols not shown. ",
    "Variability in transformation of source columns not considered."
  ) |> 
    str_wrap(width = 100)
  
  subtitle_text <- str_c(
    "By count of analyses (",
     total_analyses,
    " total analyses), grouped and labelled by proportion"
  ) |> 
    str_wrap(width = 60)

  title_text <- str_c(
    "Source column preferences: ",
    domain_question_label,
    " analyses"
  ) |> 
    str_wrap(width = 50)

  # generate plot
  plot_dat|>
  filter(over_pct_cutoff) |>
  ggplot(aes(x = reorder(source_col, n_used), y = n_used)) +
  # geom_col(aes(x = reorder(source_col, ghost_used), y = ghost_used), colour = "white") +
  geom_col(alpha = 0.5, fill = palette$source_col) +
  geom_text(aes(label = prop_label), color = "black", hjust = -0.2) +
  facet_grid(prop_facet ~ ., scales = "free") +
  coord_flip() +
  labs(x = "", 
    y = "Number of analyses in which source column used", 
    title = title_text, 
    subtitle = subtitle_text, 
    caption = cap_text) +
  theme_minimal(base_size = 20) +
  theme(
    strip.text.y = element_text(angle = 0, size = 25)
  )

  # write plot
  plot_filename <- paste0("vis/emp_barplot_", round(pct_cutoff * 100), ".png")

  ggsave(
    filename = plot_filename,
    width = 12,
    height = fig_height
  )
}
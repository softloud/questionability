library(tidyverse)
set.seed(45)

# naive construction
# simulation to explore vis


# number of analyses
n_analyses <- 174

# get columns
chick_dat <- read_csv("data-many-analysts/blue_tit_data_updated_2020-04-18.csv")
chick_cols <- colnames(chick_dat)

# number of columns: 38
length(chick_cols)

# sample size: 3720
nrow(chick_dat)

# naive probability of selection

# suppose there are 2 source columns used in every analysis
# and another 4 candidates that turn up in 60% of analyses
# and all other columns have a 10% chance of being included in the study

col_index <- seq(1, 38)

selection_likelihood <- tibble(
  # shuffle the columns
  col_index = sample(col_index, size = 38, replace = FALSE),
  # assign naive selection probability
  selection_probability = c(rep(1, 3), rep(0.7, 4), rep(0.05, 31))
) |>
  mutate(
      # give col index a prefix
    col_index = str_c('col_', col_index)
  )

head(selection_likelihood)

# create an analysis simulator that selects variables
# using the selection_likelihood, assigns random transformation,
# and randomy selects an outcome
# I am probably overthinking the sampling procedure
# can return to

analysis_sim <- function(selection_likelihood, source_col_n) {
  selection_likelihood |>
    mutate(
      # sample source_cols
      selected = map_lgl(selection_probability, 
        ~sample(c(TRUE, FALSE), prob =c(.x, 1 - .x), size = 1)
        )
    ) |>
    filter(selected == TRUE) |>
    head(source_col_n) |>
    pull(col_index)
}

analysis_sim(selection_likelihood, source_col_n = 5)

tibble(
  analysis_id = paste0('analysis_', seq(1, n_analyses)),
  n_source_cols = sample(4:15, size = n_analyses, replace = TRUE),
  # randomly assign four distributions for the outcome
  outcome_type = sample(c('binomial', 'gaussian', 'poisson', 'logit'), 
    size = n_analyses, replace = TRUE)
) |>
  mutate(
    source_cols = map(n_source_cols, 
      ~analysis_sim(selection_likelihood, source_col_n = .x)
      )
  ) -> analyses

analyses

analyses_by_source_cols <- analyses |>
  select(analysis_id, source_cols, outcome_type) |>
  unnest(source_col = c(source_cols))

# nodes df

# get outcome nodes
analyses |>
  group_by(outcome_type) |>
  summarise(
    # count how many analyses used each outcome
    n_analyses = n()
  ) -> outcome_nodes

# get source_col nodes
analyses_by_source_cols |>
  select(analysis_id, source_col) |>
  group_by(source_col) |>
  summarise(
    # count how many analyses used each source_col
    n_analyses = n()
  ) -> source_col_nodes

nodes <- bind_rows(
  outcome_nodes |>
    rename(node = outcome_type) |>
    mutate(node_type = 'outcome'),
  source_col_nodes |>
    rename(node = source_col) |>
    mutate(node_type = 'source_col')
)

# outcome edges
analyses |>
  select(analysis_id, outcome_type) |>
  rename(from = analysis_id,
         to = outcome_type) -> outcome_edges

# source_col edges
# create an edge row connecting every source_col in the same analysis
# source_col edges
# create an edge row connecting every source_col in the same analysis
source_col_edges <- analyses |>
  select(analysis_id, source_cols) |>
  rowwise() |>
  mutate(
    edges = list(tibble(
      from = combn(source_cols, 2, simplify = FALSE) |> map(1),
      to   = combn(source_cols, 2, simplify = FALSE) |> map(2)
    ))
  ) |>
  unnest(edge) |>
  ungroup()

source_col_edges <- analyses |>
  select(analysis_id, source_cols) |>
  mutate(
    edges = map(source_cols,
      ~combn(.x, 2, simplify = FALSE) |> 
        map(~tibble(
          from = .x[1],
          to   = .x[2]
        )
    )
  )) |>
  unnest(edges) |>
  unnest(edges)
  
analyses |> 
  arrange(n_source_cols) |>
  head(1) |>
  pull(source_cols)

source_col_edges |>
  filter(analysis_id == 'analysis_8')

library(R6)
library(tidyverse)
library(ggalluvial)

Eviconc_alluvial <- R6Class("Eviconc_alluvial",
  public = list(
    raw_df = NULL,
    palette = NULL,
    
    initialize = function(filepath = "data/source__model__column.csv", 
                         palette = NULL) {
      self$raw_df <- read_csv(filepath)
      self$palette <- palette %||% private$default_palette()
    },
    
    # Main public method to create the plot
    plot = function() {
      data <- private$prepare_plot_data()
      
      data %>%
        ggplot(
          aes(
            axis1 = column_category_labeled,
            axis2 = conclusion_direction_labeled,
            y = n_teams
          )
        ) +
        geom_alluvium(aes(fill = conclusion_direction), 
                     width = 0.5) +
        geom_stratum(width = 0.5) +
        geom_text(
          size = 2,
          stat = "stratum", 
          aes(label = after_stat(stratum))
        ) +
        scale_x_discrete(
          limits = c("column_category", "conclusion_direction"),
          labels = c("Evidence type", "Conclusion"),
          expand = c(0.1, 0.1)
        ) +
        labs(
          title = "Proportion of teams that chose evidence, conclusion, and direction combinations",
          fill = "Conclusion direction",
          y = ""
        ) +
        theme_minimal(base_size = 15) +
        scale_fill_manual(values = self$palette) +
        facet_grid(. ~ source_label) +
        theme(
          panel.grid = element_blank(),
          axis.text.y = element_blank(),
          legend.position = "bottom"
        )
    },
    
    # Public accessor methods to inspect intermediate data
    get_summary_data = function() {
      private$prepare_summary_data()
    },
    
    get_category_counts = function() {
      private$calc_col_cat_counts()
    },
    
    get_direction_counts = function() {
      private$calc_concl_dir_counts()
    },
    
    get_plot_data = function() {
      private$prepare_plot_data()
    },
    
    # Method to save the plot
    save_plot = function(filename = 'figures/conclusions-alluvial.png', 
                        width = 12, height = 8) {
      ggsave(plot = self$plot(), filename = filename, 
             width = width, height = height)
    }
  ),
  
  private = list(
    # Cache for computed data (lazy evaluation)
    .summary_data = NULL,
    .col_cat_counts = NULL,
    .concl_dir_counts = NULL,
    .plot_data = NULL,
    
    # Private methods for data preparation
    prepare_summary_data = function() {
      if (is.null(private$.summary_data)) {
        private$.summary_data <- self$raw_df %>%
          # filter(conclusion_certainty == "conclusive") %>%
          group_by(
            source_label, 
            column_category, 
            conclusion_certainty, 
            conclusion_direction
          ) %>%
          summarise(n_teams = n_distinct(team_id), .groups = "drop")
      }
      private$.summary_data
    },
    
    calc_col_cat_counts = function() {
      if (is.null(private$.col_cat_counts)) {
        private$.col_cat_counts <- self$raw_df %>%
          # filter(conclusion_certainty == "conclusive") %>%
          group_by(source_label, column_category) %>%
          summarise(unique_teams = n_distinct(team_id), .groups = "drop")
      }
      private$.col_cat_counts
    },
    
    calc_concl_dir_counts = function() {
      if (is.null(private$.concl_dir_counts)) {
        private$.concl_dir_counts <- self$raw_df %>%
          # filter(conclusion_certainty == "conclusive") %>%
          group_by(source_label, conclusion_direction) %>%
          summarise(unique_teams = n_distinct(team_id), .groups = "drop")
      }
      private$.concl_dir_counts
    },
    
    prepare_plot_data = function() {
      if (is.null(private$.plot_data)) {
        private$.plot_data <- private$prepare_summary_data() %>%
          left_join(
            private$calc_col_cat_counts(), 
            by = c("source_label", "column_category")
          ) %>%
          rename(col_cat_unique = unique_teams) %>%
          left_join(
            private$calc_concl_dir_counts(), 
            by = c("source_label", "conclusion_direction")
          ) %>%
          rename(concl_dir_unique = unique_teams) %>%
          mutate(
            column_category_labeled = paste0(
              str_replace_all(column_category, "_", " ") %>% 
                str_wrap(width = 10),
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
      }
      private$.plot_data
    },
    
    default_palette = function() {
      # Load from file or define default
      source("analysis-scripts/colour-palettes.R", local = TRUE)
      conclusion_palette
    },
    
    # Method to clear cache if raw_df changes
    clear_cache = function() {
      private$.summary_data <- NULL
      private$.col_cat_counts <- NULL
      private$.concl_dir_counts <- NULL
      private$.plot_data <- NULL
    }
  )
)

# Example usage:
eviconc <- Eviconc_alluvial$new()
eviconc$get_category_counts()
eviconc$get_direction_counts()
eviconc$get_plot_data()
eviconc$plot()
eviconc$save_plot()

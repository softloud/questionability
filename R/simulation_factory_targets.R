#' Simulation Factory Targets
#' 
#' Returns a list of targets for the simulation pipeline.
#' This was originally the main analysis approach, but now that we have
#' real data, it's kept for reference and comparison purposes.
#' 
#' @param data_bluetit The bluetit dataset (used to get column names)
#' @param n_analyses Number of analyses to simulate (default 142, matching bluetit)
#' @return A list of targets for the simulation pipeline

get_simulation_factory_targets <- function() {
  list(
    # simulation parameters
    tar_target(
      name = data_bluetit,
      readr::read_csv("data-many-analysts/blue_tit_data_updated_2020-04-18.csv")
    ),
    tar_target(
      name = sim_n_analyses,
      # n bluetit analyses 142, n eucalyptus 85
      142
    ),
    tar_target(
      name = sim_source_col_range,
      c(4, 15)
    ),
    tar_target(
      sim_source_col_dist,
      list(
        # how many source columns are
        always_used = 3,
        often_used = 4
      )
    ),
    tar_target(
      name = sim_source_col_use_prob,
      list(
        # how often the often used occur
        often_used = 0.4,
        sometimes_used = 0.05
      )
    ),
    
    # pipeline
    tar_target(
      name = sim_column_index,
      get_column_index(colnames(data_bluetit))
    ),
    tar_target(
      name = sim_source_col_likelihood,
      set_source_col_likelihood(
        sim_column_index, sim_source_col_dist, sim_source_col_use_prob)
    ),
    tar_target(
      name = simulated_analyses,
      get_sim_analyses(sim_n_analyses, sim_source_col_range, sim_source_col_likelihood)
    ),
    tar_target(
      name = sim_outcome_nodes, 
      get_outcome_nodes(simulated_analyses)
    ),
    tar_target(
      name = sim_source_col_nodes,
      get_source_col_nodes(simulated_analyses, sim_column_index)
    ),
    tar_target(
      name = sim_nodes,
      get_nodes(sim_outcome_nodes, sim_source_col_nodes)
    ),
    tar_target(
      name = sim_source_outcome_edges,
      get_source_outcome_edges(simulated_analyses)
    ),
    tar_target(
      name = sim_source_source_edges,
      get_source_source_edges(simulated_analyses)
    ),
    tar_target(
      name = sim_edges,
      get_edges(sim_source_outcome_edges, sim_source_source_edges)
    ),
    
    # graphs
    tar_target(
      name = sim_graph,
      tidygraph::tbl_graph(nodes = sim_nodes, edges = sim_edges)
    ),
    tar_target(
      name = sim_graph_popular,
      # filter the graph to top 25% most analysed variables
      {sim_graph |>
          tidygraph::activate(nodes) |>
          dplyr::filter(n_analyses >= quantile(1:sim_n_analyses, 0.75))
      }
    ),
    
    # visualisations
    tar_target(
      name = sim_horrendogram,
      plot_horrendogram(sim_graph)
    ),
    tar_target(
      name = sim_save_horrendogram,
      ggplot2::ggsave(
        filename = "vis/horrendogram.png",
        plot = sim_horrendogram,
        width = 8,
        height = 6
      )),
    tar_target(
      name = sim_plot_graph_popular,
      plot_horrendogram(sim_graph_popular)
    ),
    tar_target(
      name = sim_save_popular,
      ggplot2::ggsave(
        filename = "vis/popular.png",
        plot = sim_plot_graph_popular,
        width = 8,
        height = 6
      )),
    
    # validation: check one analysis is correctly in the final graph
    tar_target(
      name = single_analysis,
      simulated_analyses |> dplyr::slice(1)
    ),
    tar_target(
      name = validation_results,
      {
        result <- validate_analysis_in_graph(
          single_analysis, sim_graph, sim_column_index)
        stopifnot("validation failed" = result$all_passed)
        result
      }
    )
  )
}

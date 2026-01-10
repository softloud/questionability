# questionability

This project explores graphical analyses of how different analysts might decompose a domain question into an analytic question given the same data.

A graph is a network determined by *nodes* and *edges*.

## Minimal Representations of Core Results

The goal is to explore **minimal representations that faithfully align with the experiment's core results, privileging interpretability**. 

## Eucalypt Analysis

The main analysis pipeline uses the eucalypt many-analysts dataset.

Inspect the eucalypt data analysis:

```r
targets::tar_make()
tar_visnetwork(names = starts_with("emp"), targets_only = TRUE)
```

## Graph Visualisations

Graph visualisations illustrate the diversity of how analysts decompose. This project explores different graph presentations. 

We are using [`ggraph`](https://ggraph.data-imaginist.com/) to create the visualisations. 

> Todo: add caption highlighting most-popular source columns and outcomes

## Simulation Study

The simulation study was used during development to explore graph structures before real data extraction. 

📄 **[Full simulation documentation](docs/simulation-study.md)**

The simulation pipeline is modularised in [`R/simulation_factory_targets.R`](R/simulation_factory_targets.R) and can be enabled by uncommenting the relevant line in `_targets.R`.
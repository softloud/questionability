# questionability

This project explores analyses of how different analysts might decompose a domain question into an analytic question given the same data.

## Structure of this Project

**Key files and folders:**
- [`R/`](R/) - R analysis scripts
- [`source-data/`](source-data/) - Primary source of truth for raw datasets
- [`dbt/`](dbt/) - Data transformation (seeds, models)
- [`dagster_qn/`](dagster_qn/) - Dagster orchestration
- [`vis/`](vis/) - Generated plots and visualizations
- [`docs/`](docs/) - Documentation
- [`validation/`](validation/) - Quality checks
- [`manuscript/`](manuscript/) - LaTeX manuscript — see [manuscript/README.md](manuscript/README.md)

## For R Contributors

> Coming soon: where to put R scripts and how to pull data from the database.

## Platform Documentation

The data pipeline is documented in [`docs/platform.md`](docs/platform.md) — covers Dagster, dbt, PostgreSQL setup, and adding new datasets.

---

## Minimal Representations of Core Results

The goal is to explore **minimal representations that faithfully align with the experiment's core results, privileging interpretability**.

## Eucalypt Analysis

The main analysis currently runs on the eucalyptus analyses dataset.

## Graph Visualisations

Graph visualisations illustrate the diversity of how analysts decompose. This project uses [`ggraph`](https://ggraph.data-imaginist.com/).

We also have several more visualisations underway or planned in [`docs/storybook-outline.md`](docs/storybook-outline.md).

## Simulation Study

The simulation study was used during development to explore graph structures before real data extraction.

📄 **[Full simulation documentation](docs/simulation-study.md)**


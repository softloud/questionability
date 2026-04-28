# data entities (candy shop)

Data entities are tables as rows and columns at different transformational layers:

- **Analytic entities**: Data tables summarising analyses run on entities, ready for visualisation or exploration.
- **Entities**: Processed data tables that join or transform source entities in similar ways.
- **Source entities**: Organised in the way they arrived by source.

## raw

### data sources

Raw input files in [`source-data/`](../source-data/) — this is the canonical location. Do not edit files in `dbt/seeds/` directly; they are managed by `sync_seeds.sh`.

source | file | grain (unique row)
--- | --- | ---
eucalyptus | `source-data/euc_team_model.csv` | team, model
eucalyptus | `source-data/euc_team.csv` | team
eucalyptus | `source-data/euc_column.csv` | column
bluetit | `source-data/tit_team_model.csv` | team, model
bluetit | `source-data/tit_team.csv` | team
bluetit | `source-data/tit_column.csv` | column
other | `source-data/conclusions.csv` | team, model, conclusion

See [README.md — Adding new datasets](../README.md#adding-new-datasets) for how to add new source files.

## analytic

### analytic entities

Visualisation-ready datasets

Produced by Dagster assets and written to `data/`. Each dataset combines both sources via a `source` column.

`data/` file | grain (unique row)
--- | ---
`data/source_model.csv` | source, team, model
`data/source_column.csv` | source, column, model
`data/source_variable.csv` | source, family, column
`data/source_variable_edges.csv` | source, from_variable, to_variable

### entities

Semantic-layer dbt models combining the two source datasets.

dbt model | grain (unique row)
--- | ---
`source__team__model` | source, team, model
`model__column` | model, column

### source entities

dbt seed tables loaded from `source-data/` via `sync_seeds.sh`, corresponding to the source layer in the pipeline.

source | dbt seed | grain (unique row)
--- | --- | ---
eucalyptus | `euc__team__model` | team, model
eucalyptus | `euc__column` | column
bluetit | `tit__team__model` | team, model
bluetit | `tit__column` | column


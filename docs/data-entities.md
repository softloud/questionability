# data entities (candy shop)

Data entities are tables as rows and columns at different transformational layers:

- **Analytic entities**: Data tables summarising analyses run on entities, ready for visualisation or exploration.
- **Entities**: Processed data tables that join or transform source entities in similar ways.
- **Source entities**: Organised in the way they arrived by source.

## analytic entities

source | columns that define a unique row | `targets` command
--- | --- | ---
eucalyptus | team, model | `tar_read(analyses_eucalyptus)`
eucalyptus | team | `tar_read(analysts_eucalyptus)`
eucalyptus | source column, model | `tar_read(analyses_sourcecols_eucalyptus)`
bluetit | team, model | `tar_read(analyses_bluetit)`
bluetit | team | `tar_read(analysts_bluetit)`
bluetit | source column, model | `tar_read(analyses_sourcecols_bluetit)`

## entities

In this pipeline, we currently do not have any analyses aggregating across the two datasets, but likely there will be in future. 

The wrangled entities are still decomposed by source in the pipeline.

source | columns that define a unique row | `targets` command
--- | --- | ---
eucalyptus | source column | `tar_read(column_index_eucalyptus)`
bluetit | source column | `tar_read(column_index_bluetit)`

## source entities

We will work with several raw datasets for both `eucalypt` and `bluetit` analyses. Raw data lives in [`source-data/`](../source-data/) — this is the canonical location. Do not edit files in `dbt/seeds/` directly; they are managed by `sync_seeds.sh`.

source | columns that define a unique row | `source-data` file
--- | --- | ---
eucalyptus | team, model | `source-data/master_data_Charles_euc.csv`
bluetit | team, model | `source-data/blue_tit_data_updated_2020-04-18.csv`

See [README.md — Adding new datasets](../README.md#adding-new-datasets) for how to add new source files.


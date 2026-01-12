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

We will work with several raw datasets for both `eucalypt` and `bluetit` analyses.

source | columns that define a unique row | `source-data` file
--- | --- | ---
eucalyptus | team, model | source-data/master_data_Charles_euc.csv
eucalyptus | team | pending
eucalyptus | source column | pending
bluetit | team, model | source-data/master_data_Charles_euc.csv
bluetit | team | pending
bluetit | source column | pending

> TODO: Hannah, please update this table as you proceed with uploading the data. Give the datasets sensible file names. I haven't changed the eucalyptus dataset name yet because I wanted to be explicit with you about what the code is currently running on. The code currently runs on the euclaypt dataset for the bluetit pipeline, but we will change that once the bluetit data is uploaded.

> Suggested naming convention: source--column1-column2.csv

> Worth considering naming conventions carefully for each entity: source, team, model, source column, etc.


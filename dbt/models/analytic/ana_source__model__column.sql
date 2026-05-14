with model_columns as (
  select *
  from {{ ref('sem_source__model__column') }}
),
teams as (
  select *
  from {{ ref('sem_source__team') }}
),
team_model as (
  select *
  from {{ ref('sem_source__team__model') }}
),
columns as (
  select *
  from {{ ref('sem_source__column') }}
),
source_label as (
  select *
  from {{ ref('sem_source') }}
),
aggregated as (
  select 
    model_columns.*,
    team_model.team_id,
    columns.column_category,
    teams.conclusion_category,
    teams.conclusion_direction,
    teams.conclusion_category_label,
    source_label.source_label
  from model_columns  
  join team_model 
    on model_columns.model_id = team_model.model_id
    and model_columns.source_id = team_model.source_id
  join columns 
    on model_columns.column_id = columns.column_id
    and model_columns.source_id = columns.source_id
  join teams 
    on team_model.team_id = teams.team_id
    and team_model.source_id = teams.source_id
  join source_label
    on model_columns.source_id = source_label.source_id
)
select *
from aggregated
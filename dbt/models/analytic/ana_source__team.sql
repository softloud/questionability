with teams as (
  select 
    *
  from {{ ref("sem_source__team") }}
),
sources as (
  select *
  from {{ ref('sem_source') }}
)

select 
  teams.*,
  sources.source_label
from teams
left join sources
  on teams.source_id = sources.source_id

with teams as (
  select 
    *, 
    case when conclusion_category like 'neg%' then 'negative' 
         when conclusion_category like 'pos%' then 'positive'
         when conclusion_category like 'mixed%' then 'mixed'
         when conclusion_category like 'none%' then 'none' 
       else 'missing' end as conclusion_direction  
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

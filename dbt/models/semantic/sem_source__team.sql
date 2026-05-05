with euc as (
  select 
    source_id,
    team_id, 
    conclusion_category
  from {{ ref('se_euc__team') }}
),
tit as (
  select 
    source_id,
    team_id,
    conclusion_category
  from {{ ref('se_tit__team') }}
)
select *
from euc
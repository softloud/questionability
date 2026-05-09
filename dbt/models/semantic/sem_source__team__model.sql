-- euc team model
with euc as (
  select source_id, team_id, model_id
  from {{ ref("se_euc__team__model") }}
),

-- tit team model
tit as (
  select source_id, team_id, model_id
  from {{ ref ("se_tit__team__model") }}
),

-- aggregate
aggregated as (
  select *
  from euc
  union all
  select *
  from tit

)

-- select
select *
from aggregated
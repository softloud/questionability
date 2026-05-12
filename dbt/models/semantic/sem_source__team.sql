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
),
unioned as (
  select * from euc
  union all
  select * from tit
),
category_label as (
  select *
  from {{ ref("se_conclusions") }}
)
select 
  unioned.*,
  conclusions.conclusion_category_label
from unioned
left join
category_label as conclusions
  on unioned.conclusion_category = conclusions.conclusion_category
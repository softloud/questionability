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
),
labelled as (
  select 
    unioned.*,
    conclusions.conclusion_category_label
  from unioned
  left join
  category_label as conclusions
    on unioned.conclusion_category = conclusions.conclusion_category
)
select *,
    case when conclusion_category like 'neg%' then 'negative' 
         when conclusion_category like 'pos%' then 'positive'
         when conclusion_category like 'mixed%' then 'mixed'
         when conclusion_category like 'none%' then 'none' 
       else conclusion_category end as conclusion_direction
from labelled
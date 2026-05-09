-- euc columns
with euc as (
  select * 
  from {{ ref('se_euc__column') }}
),
-- tit columns
tit as (
  select * 
  from {{ ref('se_tit__column') }}
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

with counts as (select team_id, count(*) as duplicates
from {{ ref('euc_team') }}
group by team_id
having count(*) > 1),
results as (
  select *
  from {{ ref('euc_team') }}
  where team_id in ('Bundeena', 'Bangalow')
)
select *
from results

with counted as (
  select source_id, count(team_id) as num_teams
  from {{ ref( "sem_source__team") }}
  group by source_id
)
select 
  *,
  case when source_id = 'euc' then 'eucalpytus (teams = ' || num_teams || ')'
       when source_id = 'tit' then 'bluetit (teams = ' || num_teams || ')'
       else source_id end as source_label
from counted
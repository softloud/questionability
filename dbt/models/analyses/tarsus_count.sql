with whichcol as (
  select *
  from {{ ref('tit_column') }}
  where entity = 'tarsus'
),
raw_team_model as (
  select team_id, day_14_tarsus_length
  from {{ ref('tit_team_model') }}
  where day_14_tarsus_length = 'day_14_tarsus_length'
)
select count(distinct team_id) as tarsus_teams
from raw_team_model 

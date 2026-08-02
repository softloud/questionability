select count(team_id) as teams
from {{ ref("euc_team")}}
where Conclusion_direction = 'none'
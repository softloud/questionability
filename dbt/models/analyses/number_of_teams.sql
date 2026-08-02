select count(distinct team_id) 
from {{ ref("sem_source__team")}}
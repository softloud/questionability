select source_id, count(team_id) as n from {{ ref("sem_source__team")}}
group by source_id
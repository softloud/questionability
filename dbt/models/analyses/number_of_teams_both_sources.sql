select team_id, count(source_id) as n from {{ ref("sem_source__team")}}
group by team_id
having n > 1
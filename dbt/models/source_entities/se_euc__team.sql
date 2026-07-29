with renamed as(
  select 
    'euc' as source_id,
    team_id,
    Conclusion_direction as conclusion_direction,
    conclusion_certainty as conclusion_certainty,
    ConclusionS1 as conclusion_text
  from {{ ref('euc_team') }}
)
select *
from renamed
where team_id != 'Bungonia'
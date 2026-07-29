select 
  'tit' as source_id,
  team_id,
  Conclusion_direction as conclusion_direction,
  conclusion_certainty as conclusion_certainty,
  ConclusionS1 as conclusion_text
from {{ ref('tit_team') }}

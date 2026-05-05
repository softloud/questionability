select 
  'tit' as source_id,
  team_id,
  Conclusion as conclusion_category,
  ConclusionS1 as conclusion_text
from {{ ref('tit_team') }}

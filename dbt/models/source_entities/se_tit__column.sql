select 
  'tit' as source_id, 
  column_id,
  entity as column_category
from {{ ref('tit_column') }}

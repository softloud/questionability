select 
  'euc' as source_id, 
  column_id,
  entity as column_category
from {{ ref('euc_column') }}

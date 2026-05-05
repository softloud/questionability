select 'euc' as source_id, *
from {{ ref('euc_column') }}

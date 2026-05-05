select 'tit' as source_id, *
from {{ ref('tit_column') }}

select 'euc' as source_id, *
from {{ ref('euc_team_model') }}

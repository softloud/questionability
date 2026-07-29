select 'euc' as source_id, *
from {{ ref('euc_team_model') }}
where team_id != 'Bungonia'
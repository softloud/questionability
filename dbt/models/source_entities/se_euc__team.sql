select *
from {{ ref('euc_team') }}
where team_id is not null
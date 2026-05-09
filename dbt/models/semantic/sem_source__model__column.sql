select 
  source_id,
  model_id,
  column_id
from {{ ref('se_euc__model__column') }}
union all
select
  source_id,
  model_id,
  column_id
from {{ ref('se_tit__model__column') }}

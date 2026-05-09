with columns as (
  select 
    source_id,
    'column' as variable_type,
    column_id as variable_id
from {{ ref('sem_source__column') }})

-- todo add model variables 
select *
from columns
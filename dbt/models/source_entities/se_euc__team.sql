with renamed as(
  select 
    'euc' as source_id,
    team_id,
    Conclusion as conclusion_category,
    ConclusionS1 as conclusion_text
  from {{ ref('euc_team') }}
),
counted as (
  select 
    *, 
    -- hack to remove duplicates until we can fix the source data
    row_number() over (partition by team_id order by team_id) as row_num
  from renamed
)
select *
from counted
where team_id is not null
-- hack to remove duplicates until we can fix the source data
and row_num = 1
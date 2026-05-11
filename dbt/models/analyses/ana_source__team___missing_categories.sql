select *
from {{ ref("ana_source__team") }}
where conclusion_direction = 'missing'
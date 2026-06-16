SELECT
  if(item_003 LIKE '%MOTION連携中%', '', item_003) AS item_003_trans,
  CAST(item_001 AS Int64) AS item_001
from {selected_table}
where 
  toDateTime(updated_on, 'Asia/Tokyo') >= now('Asia/Tokyo') - INTERVAL 30 MINUTE
AND (
    item_003 LIKE '%MOTION連携中%'
    OR toString(item_003) != ''
)
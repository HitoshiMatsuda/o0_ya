SELECT
  if (
    item_003 LIKE '%MOTION連携中%',
    '',
    item_003
  ) AS item_003_trans,
  CAST(item_001 AS Int64) AS item_001
FROM
  {selected_table}
WHERE
  toDateTime (updated_on, 'Asia/Tokyo') >= toStartOfDay (now ('Asia/Tokyo'))
  AND toDateTime (updated_on, 'Asia/Tokyo') < toStartOfDay (now ('Asia/Tokyo')) + INTERVAL 8 HOUR + INTERVAL 20 MINUTE
  AND (
    item_003 LIKE '%MOTION連携中%'
    OR toString (item_003) != ''
  )
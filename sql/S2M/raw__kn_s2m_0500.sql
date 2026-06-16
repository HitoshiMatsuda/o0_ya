SELECT
*
FROM
  {selected_table}
where 
    toDateTime(updated_on, 'Asia/Tokyo') >= (toStartOfDay(now('Asia/Tokyo')) - INTERVAL 1 DAY + INTERVAL 20 HOUR + INTERVAL 20 MINUTE)
AND 
    toDateTime(updated_on, 'Asia/Tokyo') < toStartOfDay(now('Asia/Tokyo'))
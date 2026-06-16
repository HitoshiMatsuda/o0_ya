SELECT
  -- 必須カラム
  'initial_role' AS role_id,
  -- '69b8fb5831fe16c65cd5891f' AS role_id,

  -- 故人名
  deceased_list,

  -- UK生成
  concat(
    lpad(coalesce(toString(item_016), ''), 8, '0'),
    '_',
    coalesce(deceased_list, ''),
    '_',
    coalesce(item_002, '')
  ) AS unique_key,

  -- 顧客番号
  -- lpad(coalesce(toString(item_016), ''), 8, '0') AS item_016,

  -- 喪主名
  item_007,

  -- 葬儀申込番号
  item_001,
  item_008,
  item_003,
  
  ---------------
  -- 日付変換処理
  ---------------
  -- 死亡日
  ifnull(
    formatDateTime(
      parseDateTimeBestEffortOrNull(item_009),
      '%Y/%m/%d'
    ),
    ''
  ) AS item_009,

  -- 葬儀施行日
  ifnull(
    formatDateTime(
      parseDateTimeBestEffortOrNull(item_002),
      '%Y/%m/%d'
    ),
    ''
  ) AS item_002,

  -- 備考
  item_010

FROM {selected_table}
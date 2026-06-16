select
    -- 顧客番号
    item_003

    -- 顧客名
    , company_name
    -- 顧客名フリガナ
    , item_224
    -- ロール
    , '69b8fb5831fe16c65cd5891f' as role_id

    -------------------
    -- 日付変換対象
    -------------------
    -- 石碑 完成引渡し日
    , ifnull(
        formatDateTime(
            parseDateTimeBestEffortOrNull(item_056),
            '%Y/%m/%d'
        ),
        ''
    ) as item_056
    -- 内金・残金支払い【入金処理日】
    , ifnull(
        formatDateTime(
            parseDateTimeBestEffortOrNull(item_067),
            '%Y/%m/%d'
        ),
        ''
    ) as item_067
    -- 個別工事進捗状況【検査日】
    , ifnull(
        formatDateTime(
            parseDateTimeBestEffortOrNull(item_069),
            '%Y/%m/%d'
        ),
        ''
    ) as item_069

    -------------------
    -- コードマスタ変換対象
    -------------------
    -- 内金・残金支払い（最新工事受注）
    , transform(
        ifnull(toString(item_066), ''),
        ['1','2','3','4','5'],
        ['内金','中１','手付','中２','残金'],
        ''
    ) as item_066
    -- 個別工事進捗状況（最新工事受注）
    , transform(
        ifnull(toString(item_068), ''),
        [
        '1','2','3','4','5','6','7','8','9','10',
        '11','12','13','14','15','16','17','18','19','20',
        '21','22','23','24'
        ],
        [
            '基礎',
            '外柵',
            '石碑',
            '石棺',
            '付属',
            '書家文字',
            '顧客確認',
            '彫刻',
            '流動／補助',
            '据付工程',
            '受注その他',
            '依頼書',
            '改葬造成',
            '改築基礎',
            '改葬石材１',
            '改葬石材２',
            '改葬石材３',
            '改葬石材４',
            '改葬書家',
            '改葬彫刻',
            '改葬据付',
            '改葬その他１',
            '改葬その他２',
            '完成検査'
        ],
        ''
    ) as item_068
from
  {selected_table}
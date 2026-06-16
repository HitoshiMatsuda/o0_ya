SELECT
    t.*,

    -- エラー理由
    arrayStringConcat(
        arrayFilter(x -> x != '', [

            -- =====================
            -- 重複チェック
            -- =====================
            IF(item_003 != '0' AND cnt_003 > 1,
               'item_003: duplicate', ''),

            IF(item_001_tenki != '0' AND cnt_001 > 1,
               'item_001_tenki: duplicate', ''),

            -- =====================
            -- 郵便番号系（trimあり）
            -- =====================
            IF(length(trim(item_004)) > 0
               AND length(replaceAll(item_004, '-', '')) != 7,
               'item_004: length!=7(after trim & removing -)', ''),

            IF(length(trim(item_233)) > 0
               AND length(replaceAll(item_233, '-', '')) != 7,
               'item_233: length!=7(after trim & removing -)', ''),

            -- =====================
            -- 特殊郵便番号系（0のみOK）
            -- =====================
            IF(item_026 != '0'
               AND length(replaceAll(item_026, '/', '')) != 8,
               'item_026: length!=8(after removing /)', ''),

            IF(item_227 != '0'
               AND length(replaceAll(item_227, '/', '')) != 8,
               'item_227: length!=8(after removing /)', ''),

            -- =====================
            -- 電話番号系（trim + '-'除去）
            -- =====================
            IF(length(trim(phone_no)) > 0
               AND length(replaceAll(phone_no, '-', '')) NOT IN (10, 11),
               'phone_no: length!=10/11(after trim & removing -)', ''),

            IF(length(trim(item_007)) > 0
               AND length(replaceAll(item_007, '-', '')) NOT IN (10, 11),
               'item_007: length!=10/11(after trim & removing -)', ''),

            IF(length(trim(item_235)) > 0
               AND length(replaceAll(item_235, '-', '')) NOT IN (10, 11),
               'item_235: length!=10/11(after trim & removing -)', '')

        ]),
        '; '
    ) AS error_reason

FROM
(
    SELECT *,
        count() OVER (PARTITION BY item_003) AS cnt_003,
        count() OVER (PARTITION BY item_001_tenki) AS cnt_001
    FROM {selected_table}
) t

WHERE

    -- =====================
    -- 重複チェック
    -- =====================
    (item_003 != '0' AND cnt_003 > 1)
    OR
    (item_001_tenki != '0' AND cnt_001 > 1)

    -- =====================
    -- 郵便番号系（trimあり）
    -- =====================
    OR (length(trim(item_004)) > 0
        AND length(replaceAll(item_004, '-', '')) != 7)

    OR (length(trim(item_233)) > 0
        AND length(replaceAll(item_233, '-', '')) != 7)

    -- =====================
    -- 特殊郵便番号系（0のみOK）
    -- =====================
    OR (item_026 != '0'
        AND length(replaceAll(item_026, '/', '')) != 8)

    OR (item_227 != '0'
        AND length(replaceAll(item_227, '/', '')) != 8)

    -- =====================
    -- 電話番号系
    -- =====================
    OR (length(trim(phone_no)) > 0
        AND length(replaceAll(phone_no, '-', '')) NOT IN (10, 11))

    OR (length(trim(item_007)) > 0
        AND length(replaceAll(item_007, '-', '')) NOT IN (10, 11))

    OR (length(trim(item_235)) > 0
        AND length(replaceAll(item_235, '-', '')) NOT IN (10, 11));
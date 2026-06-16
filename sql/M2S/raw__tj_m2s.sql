SELECT
    company_name,
    item_224,
    'initial_role' AS role_id,
    lpad(toString(item_003), 8, '0') AS item_003,
    item_043,
    item_044,
    item_045,
    item_048b,

    --------------------
    -- コードマスタ変換対象カラム
    --------------------
    -- 外柵 工事状況区分
    transform(item_054, ['1','2','3'], ['未受注','受注承認','工事必要なし'], '') AS item_054,

    -- 石碑 工事状況区分
    transform(item_055, ['1','2','3'], ['未受注','受注承認','工事必要なし'], '') AS item_055,

    -- 仏壇 取引有無区分
    transform(item_145, ['1','2'], ['無','有'], '') AS item_145,

    -- 葬儀 取引有無区分
    transform(item_096, ['1','2'], ['無','有'], '') AS item_096,

    -- 墓地形式
    transform(
        item_050,
        ['1','2','3','4','5','6','7','8'],
        ['芝生（含砂利）','一般','壁面','ロッカー','永代墓','両家墓','室内墓所','粉骨'],
        ''
    ) AS item_050,

    -- 顧客種類区分
    transform(
        item_051,
        ['1','2','3','4'],
        ['一般客','完墓作成客','改葬依頼客','他社取得客'],
        ''
    ) AS item_051,

    -- 工事種別（最新工事受注）
    transform(
        item_252,
        ['1','2','3','4','5','6','7'],
        ['一般一式','一般外柵','一般石碑','一般その他','一般特殊Ａ','建替工事','改葬工事'],
        ''
    ) AS item_252,

    --------------------
    -- 日付整形
    --------------------
    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_058), '%Y/%m/%d'), '') AS item_058,
    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_059), '%Y/%m/%d'), '') AS item_059,
    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_060), '%Y/%m/%d'), '') AS item_060,

    --------------------
    -- テキスト整形（改行＋スペース削除）
    --------------------
    replaceAll(
        replaceAll(
            replaceAll(item_063, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_063,

    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_064), '%Y/%m/%d'), '') AS item_064,

    replaceAll(
        replaceAll(
            replaceAll(item_065, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_065,

    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_158), '%Y/%m/%d'), '') AS item_158,
    item_159,

    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_097), '%Y/%m/%d'), '') AS item_097,

    item_046,
    item_047,

    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_053), '%Y/%m/%d'), '') AS item_053,

    replaceAll(
        replaceAll(
            replaceAll(item_208, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_208,

    replaceAll(
        replaceAll(
            replaceAll(item_209, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_209,

    replaceAll(
        replaceAll(
            replaceAll(item_210, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_210,

    replaceAll(
        replaceAll(
            replaceAll(item_207, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_207,

    replaceAll(
        replaceAll(
            replaceAll(item_206, ' ', ''),
            '　', ''
        ),
        '&lt;BR&gt;', '\n'
    ) AS item_206,

    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_205), '%Y/%m/%d'), '') AS item_205,
    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_204), '%Y/%m/%d'), '') AS item_204,

    item_049,
    item_061,
    item_062

    ifNull(formatDateTime(parseDateTimeBestEffortOrNull(item_052), '%Y/%m/%d'), '') AS item_052,

    item_057

FROM
    {selected_table};
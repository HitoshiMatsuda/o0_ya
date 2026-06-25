-- ==========================================
-- = 重複チェックWF
-- = ① 重複件数の付与（サブクエリ）
-- = ② 各種バリデーションチェック
-- = ③ エラー理由の文字列生成
-- = ④ エラーがあるレコードのみ抽出
-- = 
-- = 郵便番号カラム(item_004: 郵便番号, item_233: 送付先 郵便番号)
-- = 空でない → ハイフン除去 → 7桁でないとNG
-- = 
-- = DATEカラム(item_026: 見込客初回登録日, item_227: 生年月日)
-- = 0ではない → 8桁でないとNG
-- = 
-- = 電話番号カラム(phone_no: TEL, item_007: 携帯, item_235: 送付先 TEL)
-- = 空白除去 → ハイフン除去 → 10桁or11桁でないとNG
-- ==========================================

select
  t.*
from
(
  select
    *
    , count() over (partition by item_003) as cnt_003
    , count() over (partition by item_001_tenki) as cnt_001
  from {selected_table}
) t

where

  -- =====================
  -- 重複チェック
  -- =====================
  (item_003 != '0' and cnt_003 > 1)
  or
  (item_001_tenki != '0' and cnt_001 > 1)

  -- =====================
  -- 郵便番号系（trimあり）
  -- =====================
  or (
    length(trim(item_004)) > 0
    and length(replaceAll(item_004, '-', '')) != 7
  )

  or (
    length(trim(item_233)) > 0
    and length(replaceAll(item_233, '-', '')) != 7
  )

  -- =====================
  -- 特殊郵便番号系（0のみOK）
  -- =====================
  or (
    item_026 != '0'
    and length(replaceAll(item_026, '/', '')) != 8
  )

  or (
    item_227 != '0'
    and length(replaceAll(item_227, '/', '')) != 8
  )

  -- =====================
  -- 電話番号系（trim + '-'除去）
  -- =====================
  or (
    length(trim(phone_no)) > 0
    and length(replaceAll(phone_no, '-', '')) not in (10, 11)
  )

  or (
    length(trim(item_007)) > 0
    and length(replaceAll(item_007, '-', '')) not in (10, 11)
  )

  or (
    length(trim(item_235)) > 0
    and length(replaceAll(item_235, '-', '')) not in (10, 11)
  );
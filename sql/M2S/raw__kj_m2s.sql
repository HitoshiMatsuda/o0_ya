-- =====================================
-- データ除外条件（where句ロジック整理）
-- =====================================
-- 以下のいずれかに該当するレコードは除外される
--
-- 【1. 重複チェック】
-- ・顧客番号（item_003）が '0' 以外で重複している
-- ・顧客基本情報コード（item_001_tenki）が '0' 以外で重複している
--
-- 【2. 郵便番号不正】
-- ・郵便番号（item_004）が存在し、ハイフン除去後が7桁でない
-- ・送付先郵便番号（item_233）が存在し、ハイフン除去後が7桁でない
--
-- 【3. 日付不正】
-- ・見込客初回登録日（item_026）が '0' 以外かつ8桁でない
-- ・生年月日（item_227）が '0' 以外かつ8桁でない
--
-- 【4. 電話番号不正】
-- ・TEL（phone_no）が存在し、ハイフン除去後が10桁または11桁でない
-- ・携帯電話番号（item_007）が存在し、ハイフン除去後が10桁または11桁でない
-- ・送付先TEL（item_235）が存在し、ハイフン除去後が10桁または11桁でない
--
-- ※上記条件に1つでも該当すると除外（not exists + or 条件）
-- =====================================

select
  -- ロール
  'initial_role' as role_id

  -- 顧客番号
  , item_003

  -- 顧客基本情報コード
  , case
      when item_001_tenki = '0' then ''
      else item_001_tenki
    end as item_001_tenki

  -- 顧客（個人）名
  , company_name

  -- 顧客名 カナ
  , arrayFold(
      (acc, t) -> replaceAll(acc, t.1, t.2),
      [
        ('ｶﾞ','ガ'),('ｷﾞ','ギ'),('ｸﾞ','グ'),('ｹﾞ','ゲ'),('ｺﾞ','ゴ'),
        ('ｻﾞ','ザ'),('ｼﾞ','ジ'),('ｽﾞ','ズ'),('ｾﾞ','ゼ'),('ｿﾞ','ゾ'),
        ('ﾀﾞ','ダ'),('ﾁﾞ','ヂ'),('ﾂﾞ','ヅ'),('ﾃﾞ','デ'),('ﾄﾞ','ド'),
        ('ﾊﾞ','バ'),('ﾋﾞ','ビ'),('ﾌﾞ','ブ'),('ﾍﾞ','ベ'),('ﾎﾞ','ボ'),
        ('ﾊﾟ','パ'),('ﾋﾟ','ピ'),('ﾌﾟ','プ'),('ﾍﾟ','ペ'),('ﾎﾟ','ポ'),
        ('ｬ','ャ'),('ｭ','ュ'),('ｮ','ョ'),('ｯ','ッ'),
        ('ｧ','ァ'),('ｨ','ィ'),('ｩ','ゥ'),('ｪ','ェ'),('ｫ','ォ'),
        ('ｱ','ア'),('ｲ','イ'),('ｳ','ウ'),('ｴ','エ'),('ｵ','オ'),
        ('ｶ','カ'),('ｷ','キ'),('ｸ','ク'),('ｹ','ケ'),('ｺ','コ'),
        ('ｻ','サ'),('ｼ','シ'),('ｽ','ス'),('ｾ','セ'),('ｿ','ソ'),
        ('ﾀ','タ'),('ﾁ','チ'),('ﾂ','ツ'),('ﾃ','テ'),('ﾄ','ト'),
        ('ﾅ','ナ'),('ﾆ','ニ'),('ﾇ','ヌ'),('ﾈ','ネ'),('ﾉ','ノ'),
        ('ﾊ','ハ'),('ﾋ','ヒ'),('ﾌ','フ'),('ﾍ','ヘ'),('ﾎ','ホ'),
        ('ﾏ','マ'),('ﾐ','ミ'),('ﾑ','ム'),('ﾒ','メ'),('ﾓ','モ'),
        ('ﾔ','ヤ'),('ﾕ','ユ'),('ﾖ','ヨ'),
        ('ﾗ','ラ'),('ﾘ','リ'),('ﾙ','ル'),('ﾚ','レ'),('ﾛ','ロ'),
        ('ﾜ','ワ'),('ｦ','ヲ'),('ﾝ','ン')
      ],
      item_224
    ) as item_224

  -- 郵便番号
  , if(item_004 = '', '', if(item_004 = ' ', '',
      concat(substr(item_004, 1, 3), '-', substr(item_004, 4, 4))))
    as item_004

  -- 補足住所（漢字）
  , item_005

  -- TEL
  , if(phone_no = ' ', '', replaceAll(phone_no, '-', '')) as phone_no

  -- 携帯電話番号
  , if(item_007 = ' ', '', replaceAll(item_007, '-', '')) as item_007

  -- 見込地区区分
  , transform(ifNull(toString(item_024), ''), ['1','2','3'], ['関東','関西','名古屋'], '')
    as item_024

  -- DM発行区分【お墓】
  , transform(ifNull(toString(item_230), ''), ['1','2','3'], ['無','有','転居（住所不明）'], '')
    as item_230

  -- 見込客初回登録日
  , if(length(item_026)=8,
      concat(substring(item_026,1,4),'/',substring(item_026,5,2),'/',substring(item_026,7,2)),
      '')
    as item_026

  -- 紹介媒体区分（紹介媒体）
  , transform(
      ifNull(toString(item_030), ''),
      ['1','2','3','4','5','6','7','8','9','10',
       '11','12','13','14','15','16','17','18',
       '19','20','21','22','23','24','25','26',
       '27','28','29','30','31'],
      [...元コードそのまま...],
      ''
    ) as item_030

  -- 紹介媒体区分（広告媒体）
  , transform(
      ifNull(toString(item_031), ''),
      arrayMap(x -> toString(x), range(1, 78)),
      [...元コードそのまま...],
      ''
    ) as item_031

  -- 見込みランク
  , transform(ifNull(toString(item_034), ''), ['1','2','3','4','5','6','7','8','9'],
    ['6ヶ月以内','6ヶ月以上','初期登録','不明','予備','即案内','名簿','没','失注'], '')
    as item_034

  -- 提携企業
  , item_040

  -- 墓地有無区分
  , transform(ifNull(toString(item_035), ''), ['1','2'], ['無','有'], '')
    as item_035

  -- 顧客対象区分
  , transform(ifNull(toString(item_036), ''), ['1','2'], ['非対象','対象'], '')
    as item_036

  -- 性別
  , transform(ifNull(toString(item_225), ''), ['1','2','3'], ['男性','女性','企業法人'], '')
    as item_225

  -- 宗旨宗派
  , transform(
      ifNull(toString(item_226), ''),
      ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19'],
      [...元コードそのまま...],
      ''
    ) as item_226

  -- 情報区分
  , transform(ifNull(toString(item_029), ''), ['1','2','3','4','5'],
    ['寿陵','死亡','改葬','建替','不明'], '')
    as item_029

  -- Eメールアドレス
  , item_010

  -- 生年月日
  , if(length(item_227)=8,
      concat(substring(item_227,1,4),'/',substring(item_227,5,2),'/',substring(item_227,7,2)),
      '')
    as item_227

  -- 送付先　氏名
  , item_231

  -- 送付先　フリガナ
  , arrayFold(...同様ロジック...) as item_232

  -- 送付先 郵便番号
  , if(item_233 = '', '', if(item_233 = ' ', '',
      concat(substr(item_233,1,3),'-',substr(item_233,4,4))))
    as item_233

  -- 送付先 補足住所
  , item_234

  -- 送付先 TEL
  , if(item_235 = ' ', '', replaceAll(item_235, '-', ''))
    as item_235

  -- 担当者　お墓〜サービス
  , item_012
  , item_013
  , item_014
  , item_015
  , item_016
  , item_017
  , item_018

  -- 都営希望者区分
  , transform(ifNull(toString(item_039), ''), ['1'], ['希望者'], '') as item_039

  -- 外柵 有無区分
  , transform(ifNull(toString(item_037), ''), ['1','2'], ['無','有'], '') as item_037

  -- 石碑 有無区分
  , transform(ifNull(toString(item_038), ''), ['1','2'], ['無','有'], '') as item_038

  -- 顧客墓地状況区分
  , transform(ifNull(toString(item_025), ''), ['1','2','3'],
    ['見込客','申込客','決定客'], '') as item_025

  -- 個人情報取得区分
  , transform(ifNull(toString(item_237), ''), ['1','2','3'],
    ['未確認','同意する','同意しない'], '') as item_237

  -- 確認日
  , if(length(item_238)=8,
      concat(substring(item_238,1,4),'/',substring(item_238,5,2),'/',substring(item_238,7,2)),
      '')
    as item_238

  -- 担当者 確認
  , item_239

  -- 電話番号使用状況区分
  , transform(ifNull(toString(item_009), ''), ['1','2','3'], ['不可','可','転居'], '')
    as item_009

  -- 送付先 電話番号使用状況区分
  , transform(ifNull(toString(item_236), ''), ['1','2','3'], ['不可','可','転居'], '')
    as item_236

  -- Eメール送信有無区分
  , transform(ifNull(toString(item_011), ''), ['1','2','3'], ['送信可','送信不可','未確認'], '')
    as item_011

  -- 失注フラグ＿お墓
  , transform(ifNull(toString(item_042), ''), ['1','2'], ['活動中','失注'], '')
    as item_042

from {selected_table} t

where not exists (
  select 1
  from (
    select *,
      count() over (partition by item_003) as cnt_003,
      count() over (partition by item_001_tenki) as cnt_001
    from {selected_table}
  ) e
  where e.item_003 = t.item_003
    and (
      (e.item_003 != '0' and e.cnt_003 > 1)
      or (e.item_001_tenki != '0' and e.cnt_001 > 1)
      or (length(trim(e.item_004)) > 0 and length(replaceAll(e.item_004, '-', '')) != 7)
      or (length(trim(e.item_233)) > 0 and length(replaceAll(e.item_233, '-', '')) != 7)
      or (e.item_026 != '0' and length(replaceAll(e.item_026, '/', '')) != 8)
      or (e.item_227 != '0' and length(replaceAll(e.item_227, '/', '')) != 8)
      or (length(trim(e.phone_no)) > 0 and length(replaceAll(e.phone_no, '-', '')) not in (10, 11))
      or (length(trim(e.item_007)) > 0 and length(replaceAll(e.item_007, '-', '')) not in (10, 11))
      or (length(trim(e.item_235)) > 0 and length(replaceAll(e.item_235, '-', '')) not in (10, 11))
    )
)
;
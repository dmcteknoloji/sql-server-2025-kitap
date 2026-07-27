-- ============================================================================
-- 02-json-uzanan-fonksiyonlar.sql
-- ----------------------------------------------------------------------------
-- JSON tipinin derin kullanımı: path expressions, modify, OPENJSON.
-- ============================================================================

USE demo;
GO

-- 1) OPENJSON ile JSON satırlarını tabloya çevir
DECLARE @doc JSON = N'[
    {"sku":"BK-001","name":"Veri Mimarisi","price":450},
    {"sku":"BK-002","name":"Performans Tuning","price":520},
    {"sku":"EL-001","name":"Klavye","price":1850}
]';

SELECT sku, name, price
FROM OPENJSON(@doc)
WITH (
    sku NVARCHAR(40)  '$.sku',
    name NVARCHAR(200) '$.name',
    price DECIMAL(12,2) '$.price'
);
GO

-- 2) JSON_MODIFY ile nested update
USE demo;
DECLARE @prefs JSON = N'{
    "language":"tr",
    "notifications":{
        "email":true,
        "sms":false
    },
    "favorite_categories":["Kitap","Elektronik"]
}';

-- SMS'i aç, yeni kategori ekle
-- JSON_MODIFY ile boolean atamak için BIT tipi kullanılır (true → 1)
SET @prefs = JSON_MODIFY(@prefs, '$.notifications.sms', CAST(1 AS BIT));
SET @prefs = JSON_MODIFY(@prefs, 'append $.favorite_categories', N'Gıda');

SELECT @prefs AS updated_prefs;
GO

-- 3) ISJSON: bir string geçerli JSON mı?
SELECT
    ISJSON(N'{"valid":"json"}')   AS is_valid,
    ISJSON(N'{not-json}')          AS is_invalid,
    ISJSON(N'{"key":"val"}', OBJECT) AS is_object,
    ISJSON(N'[1,2,3]', ARRAY)      AS is_array;
GO

-- 4) JSON sorgularını index'le (bilgisayar sütunu üstünden)
ALTER TABLE sales.customer_preferences
ADD lang AS JSON_VALUE(prefs, '$.language') PERSISTED;
GO

CREATE INDEX ix_customer_prefs_lang
    ON sales.customer_preferences (lang);

SELECT cp.customer_id, cp.lang
FROM sales.customer_preferences cp
WHERE cp.lang = N'tr';
GO

-- ============================================================================
-- 03-yeni-2025-dil-fonksiyonlari.sql
-- ----------------------------------------------------------------------------
-- SQL Server 2025 dil seviyesinde getirdiği eklemeler.
-- ============================================================================

USE demo;
GO

-- GREATEST / LEAST (skaler)
SELECT
    GREATEST(10, 20, 5, 30, 15) AS en_buyuk,
    LEAST(10, 20, 5, 30, 15)    AS en_kucuk;
GO

-- ANSI string concatenation operatörü ||
SELECT
    full_name || N' (' || city || N')' AS musteri_etiketi
FROM sales.customers;
GO

-- CURRENT_DATE (ANSI standardı; SYSDATETIME() yerine sade alternatif)
SELECT
    CURRENT_DATE       AS bugun,
    CURRENT_TIMESTAMP  AS simdi,
    SYSDATETIME()      AS sysdate_yedek;
GO

-- PRODUCT aggregate
SELECT
    p.category,
    PRODUCT(p.price) AS price_product
FROM sales.products p
GROUP BY p.category;
GO

-- UNISTR (unicode literal)
SELECT
    UNISTR(N'\015e\0061\0068\0069\006E') AS sahin_unicode,
    UNISTR(N'\00c7a\011fl\0061r') AS caglar_unicode;
GO

-- DATEADD bigint (büyük millisecond ekleme)
SELECT
    DATEADD(MILLISECOND, CAST(2147483648 AS BIGINT), CAST('2025-01-01' AS DATETIME2)) AS gelecek_zaman;
GO

-- BASE64 encode/decode
-- BASE64_ENCODE varbinary ister; nvarchar/varchar geçirilirse Msg 8116.
-- Önce CAST AS VARBINARY, sonra encode et.
SELECT
    BASE64_ENCODE(CAST(N'SQL Server 2025' AS VARBINARY(MAX))) AS encoded,
    CAST(BASE64_DECODE('U1FMIFNlcnZlciAyMDI1') AS NVARCHAR(MAX)) AS decoded;
GO

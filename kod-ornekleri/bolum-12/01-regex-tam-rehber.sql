-- ============================================================================
-- 01-regex-tam-rehber.sql
-- ----------------------------------------------------------------------------
-- SQL Server 2025'te native regex desteği (7 fonksiyon).
-- Önkoşul: compat level 170.
-- ============================================================================

USE demo;
GO

-- 1) REGEXP_LIKE — predicate (CASE içinde veya WHERE clause'da kullanılır)
SELECT
    CASE WHEN REGEXP_LIKE(N'caglar@dmcteknoloji.com', N'^[a-z0-9.]+@[a-z0-9.-]+\.[a-z]{2,}$') THEN 1 ELSE 0 END AS valid_email,
    CASE WHEN REGEXP_LIKE(N'not-an-email', N'^[a-z0-9.]+@[a-z0-9.-]+\.[a-z]{2,}$') THEN 1 ELSE 0 END AS valid2;
GO

-- WHERE clause örneği (predicate doğal kullanım)
SELECT email FROM sales.customers
WHERE REGEXP_LIKE(email, N'^[a-z0-9._%-]+@[a-z0-9.-]+\.[a-z]{2,}$');
GO

-- 2) REGEXP_REPLACE — pattern eşleşenleri değiştir
SELECT REGEXP_REPLACE(N'TC: 12345678901, doğum: 1985', N'\d{11}', N'***********') AS maskeli;
GO

-- 3) REGEXP_SUBSTR — pattern eşleşmesinin kendisini döndür
SELECT REGEXP_SUBSTR(N'Tel: +90 (532) 000 0001', N'\+90\s\(\d{3}\)\s\d{3}\s\d{4}') AS tel;
GO

-- 4) REGEXP_INSTR — pattern'in başladığı pozisyon
SELECT REGEXP_INSTR(N'sipariş 12345 onaylandı', N'\d+') AS pos;
GO

-- 5) REGEXP_COUNT — eşleşme sayısı
SELECT REGEXP_COUNT(N'a1b2c3d4e5', N'\d') AS digit_count;
GO

-- 6) REGEXP_MATCHES — TVF, tüm eşleşmeler
SELECT match_value, match_position
FROM REGEXP_MATCHES(N'Üç ürün: BK-001, EL-002, KH-001', N'[A-Z]{2}-\d{3}');
GO

-- 7) REGEXP_SPLIT_TO_TABLE — string'i tabloya böl
SELECT value, ordinal
FROM REGEXP_SPLIT_TO_TABLE(N'kahve;çay;süt;şeker;tuz', N';');
GO

-- Pratik: ürün açıklamalarında URL bul
INSERT INTO sales.products (sku, name, category, price, description)
VALUES (N'TST-001', N'Test Ürün', N'Test', 100,
        N'Detay: https://example.com/p1 veya https://example.com/p2');

SELECT
    p.name,
    rm.match_value AS url
FROM sales.products p
CROSS APPLY REGEXP_MATCHES(p.description, N'https?://\S+') rm
WHERE p.sku = N'TST-001';

DELETE FROM sales.products WHERE sku = N'TST-001';
GO

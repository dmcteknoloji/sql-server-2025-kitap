-- ============================================================================
-- 01-temel-crud.sql
-- ----------------------------------------------------------------------------
-- Klasik SELECT, INSERT, UPDATE, DELETE örnekleri.
-- ============================================================================

USE demo;
GO

-- SELECT: tüm müşteriler
SELECT customer_id, full_name, email, city
FROM sales.customers
ORDER BY full_name;
GO

-- WHERE: belirli şehirden müşteriler
SELECT full_name, email
FROM sales.customers
WHERE city IN (N'İstanbul', N'Ankara')
ORDER BY full_name;
GO

-- INSERT
INSERT INTO sales.customers (full_name, email, phone, city)
VALUES (N'Test Müşteri', N'test.musteri@example.com', N'+90 532 999 9999', N'Test');
GO

-- UPDATE
UPDATE sales.customers
SET city = N'İzmir'
WHERE email = N'test.musteri@example.com';
GO

-- DELETE
DELETE FROM sales.customers
WHERE email = N'test.musteri@example.com';
GO

-- MERGE (upsert pattern)
CREATE TABLE #incoming_customers (
    email NVARCHAR(254) PRIMARY KEY,
    full_name NVARCHAR(200) NOT NULL,
    city NVARCHAR(80)
);

INSERT INTO #incoming_customers VALUES
(N'ayse.demir@example.com', N'Ayşe Demir', N'İstanbul'),
(N'yeni.musteri@example.com', N'Yeni Müşteri', N'Bursa');

MERGE sales.customers AS target
USING #incoming_customers AS source
   ON target.email = source.email
WHEN MATCHED THEN
    UPDATE SET full_name = source.full_name, city = source.city
WHEN NOT MATCHED THEN
    INSERT (full_name, email, city) VALUES (source.full_name, source.email, source.city);

DROP TABLE #incoming_customers;
GO

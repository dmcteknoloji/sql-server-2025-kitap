-- ============================================================================
-- 01-clustered-columnstore.sql
-- ----------------------------------------------------------------------------
-- Büyük fact table için clustered columnstore.
-- ============================================================================

USE demo;
GO

-- Fact tablo oluştur (örnek: günlük satış özeti)
CREATE TABLE sales.fact_sales (
    sale_date DATE NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    total DECIMAL(14,2) NOT NULL
);

-- 1 milyon satır mock data (rowstore baseline)
WITH numbers AS (
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO sales.fact_sales (sale_date, product_id, customer_id, quantity, unit_price, total)
SELECT
    DATEADD(DAY, n % 365, '2025-01-01'),
    1 + (n % 5),
    1 + (n % 5),
    1 + (n % 10),
    CAST(100 + (n % 900) AS DECIMAL(12,2)),
    CAST((1 + (n % 10)) * (100 + (n % 900)) AS DECIMAL(14,2))
FROM numbers;
GO

-- Rowstore boyut
EXEC sp_spaceused 'sales.fact_sales';
GO

-- Clustered columnstore'a dönüştür
CREATE CLUSTERED COLUMNSTORE INDEX cci_fact_sales
    ON sales.fact_sales
    WITH (DROP_EXISTING = OFF);
GO

-- Sıkıştırılmış boyut karşılaştır (genelde 5-10x küçük)
EXEC sp_spaceused 'sales.fact_sales';
GO

-- Analitik sorgu (batch mode'da çalışır)
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    YEAR(sale_date) AS yr,
    MONTH(sale_date) AS mn,
    product_id,
    SUM(total) AS revenue,
    COUNT(*) AS tx_count
FROM sales.fact_sales
WHERE sale_date >= '2025-01-01' AND sale_date < '2026-01-01'
GROUP BY YEAR(sale_date), MONTH(sale_date), product_id
ORDER BY yr, mn, product_id;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

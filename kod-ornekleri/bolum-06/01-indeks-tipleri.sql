-- ============================================================================
-- 01-indeks-tipleri.sql
-- ----------------------------------------------------------------------------
-- Clustered, nonclustered, included, filtered, columnstore.
-- ============================================================================

USE demo;
GO

-- Clustered index zaten PK üzerinden var (sales.orders.order_id)
-- Nonclustered index: en yaygın WHERE'lerde
CREATE NONCLUSTERED INDEX ix_orders_customer
    ON sales.orders (customer_id)
    INCLUDE (order_date, total_amount, status);
GO

-- Filtered index: sadece aktif siparişler
CREATE NONCLUSTERED INDEX ix_orders_pending
    ON sales.orders (order_date)
    INCLUDE (customer_id, total_amount)
    WHERE status = N'pending';
GO

-- Columnstore: analitik sorgular için
CREATE NONCLUSTERED COLUMNSTORE INDEX ncci_orders
    ON sales.orders (customer_id, order_date, total_amount, status);
GO

-- Index kullanım istatistiği (CPU'ya bedel-fayda analizi)
SELECT
    OBJECT_NAME(s.object_id) AS table_name,
    i.name AS index_name,
    s.user_seeks, s.user_scans, s.user_lookups, s.user_updates,
    i.type_desc
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE s.database_id = DB_ID()
ORDER BY (s.user_seeks + s.user_scans + s.user_lookups) DESC;
GO

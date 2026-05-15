-- ============================================================================
-- 02-nonclustered-columnstore.sql
-- ----------------------------------------------------------------------------
-- OLTP tablosu üstünde NCCI: aynı tablo hem transactional hem analitik.
-- ============================================================================

USE demo;
GO

-- sales.orders OLTP olarak rowstore; NCCI ile analitik hızlı
-- (Tekrar çalıştırılırsa drop ile başla)
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'ncci_orders' AND object_id = OBJECT_ID('sales.orders'))
    DROP INDEX ncci_orders ON sales.orders;

CREATE NONCLUSTERED COLUMNSTORE INDEX ncci_orders
    ON sales.orders (customer_id, order_date, total_amount, status);
GO

-- Filter ile NCCI (sadece tamamlanmış siparişler)
DROP INDEX ncci_orders ON sales.orders;

CREATE NONCLUSTERED COLUMNSTORE INDEX ncci_orders_completed
    ON sales.orders (customer_id, order_date, total_amount)
    WHERE status = N'completed'
    WITH (DROP_EXISTING = OFF);
GO

-- 2025: NCCI online rebuild
ALTER INDEX ncci_orders_completed ON sales.orders
REBUILD WITH (ONLINE = ON, MAXDOP = 4);
GO

-- Hibrit query: OLTP filter + analitik agreg
SELECT
    o.customer_id,
    COUNT(*) AS completed_orders,
    SUM(o.total_amount) AS total_revenue
FROM sales.orders o
WHERE o.status = N'completed'
GROUP BY o.customer_id
ORDER BY total_revenue DESC;
GO

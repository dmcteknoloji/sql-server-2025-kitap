-- ============================================================================
-- 02-join-aggregate.sql
-- ----------------------------------------------------------------------------
-- JOIN tipleri, aggregate, window functions.
-- ============================================================================

USE demo;
GO

-- INNER JOIN: sipariş veren müşteriler
SELECT c.full_name, o.order_id, o.total_amount
FROM sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;
GO

-- LEFT JOIN: tüm müşteriler + (varsa) siparişleri
SELECT c.full_name, COUNT(o.order_id) AS order_count, ISNULL(SUM(o.total_amount), 0) AS total_spent
FROM sales.customers c
LEFT JOIN sales.orders o ON o.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_spent DESC;
GO

-- Window function: müşteri başına sipariş sırası
SELECT
    c.full_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS order_seq,
    SUM(o.total_amount) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS running_total
FROM sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id
ORDER BY c.full_name, order_seq;
GO

-- En çok satılan 3 ürün
SELECT TOP 3
    p.name,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM sales.products p
INNER JOIN sales.order_items oi ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC;
GO

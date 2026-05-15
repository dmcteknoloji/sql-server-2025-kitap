-- ============================================================================
-- 02-compat-level-davranisi.sql
-- ----------------------------------------------------------------------------
-- Aynı sorgunun farklı compatibility level'da nasıl farklı plan ürettiğini
-- gösterir. 2025'te default 170 (yeni IQP davranışları aktif).
-- ============================================================================

USE demo;
GO

-- Mevcut compat level'ı not et
SELECT compatibility_level FROM sys.databases WHERE name = N'demo';
GO

-- Compat 140 (SQL 2017) ile bir sorgu çalıştır
ALTER DATABASE demo SET COMPATIBILITY_LEVEL = 140;
GO

SET STATISTICS XML ON;
SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM sales.customers c
JOIN sales.orders o ON o.customer_id = c.customer_id
WHERE o.status = N'completed'
GROUP BY c.full_name;
SET STATISTICS XML OFF;
GO

-- 2025'in default'una (170) geç ve aynı sorguyu çalıştır
ALTER DATABASE demo SET COMPATIBILITY_LEVEL = 170;
GO

SET STATISTICS XML ON;
SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM sales.customers c
JOIN sales.orders o ON o.customer_id = c.customer_id
WHERE o.status = N'completed'
GROUP BY c.full_name;
SET STATISTICS XML OFF;
GO

-- Bekledikleriniz: plan farklılıkları, memory grant feedback, batch mode on rowstore
-- gibi 170'in getirdiği IQP davranışları gözlemlenir. Plan XML'i incelemek için
-- SSMS'de "Include Actual Execution Plan" açın.

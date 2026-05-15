-- ============================================================================
-- 03-batch-mode-rowstore.sql
-- ----------------------------------------------------------------------------
-- Batch mode on rowstore — 2025'te compatibility level 170 default ON.
-- Columnstore olmadan da batch mode hızı.
-- ============================================================================

USE demo;
GO

-- Compatibility level kontrol
SELECT name, compatibility_level FROM sys.databases WHERE name = N'demo';
GO

-- Batch mode'u açık/kapalı zorlamak için hint'ler
SELECT
    customer_id,
    COUNT(*) AS orders,
    SUM(total_amount) AS total
FROM sales.orders
GROUP BY customer_id
OPTION (USE HINT('ALLOW_BATCH_MODE'));
GO

-- Batch mode disabled
SELECT
    customer_id,
    COUNT(*) AS orders,
    SUM(total_amount) AS total
FROM sales.orders
GROUP BY customer_id
OPTION (USE HINT('DISALLOW_BATCH_MODE'));
GO

-- Plan'da "ActualExecutionMode" Batch görmelisin (XML/Graphical)
-- SET STATISTICS XML ON;
-- ... query ...
-- SET STATISTICS XML OFF;

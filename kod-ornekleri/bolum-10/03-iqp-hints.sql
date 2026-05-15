-- ============================================================================
-- 03-iqp-hints.sql
-- ----------------------------------------------------------------------------
-- 2025'in yeni IQP davranışları + USE HINT seçenekleri.
-- ============================================================================

USE demo;
GO

-- 1) OPPO (Optional Parameter Plan Optimization) — 2025'te otomatik
-- Bu davranış default; ama hint ile zorlanabilir
DECLARE @cust INT = 1;  -- gerçekte sproc parametresi olur
SELECT * FROM sales.orders
WHERE customer_id = @cust OR @cust IS NULL
OPTION (USE HINT('DISABLE_OPTIMIZED_PLAN_FORCING'));  -- davranışı kontrol et
GO

-- 2) ABORT_QUERY_EXECUTION hint (2025) — kötü sorgu otomatik iptal
SELECT * FROM sales.orders
WHERE customer_id IN (SELECT customer_id FROM sales.customers WHERE full_name LIKE N'A%')
OPTION (USE HINT('ABORT_QUERY_EXECUTION'),
        MAX_GRANT_PERCENT = 5);
GO

-- 3) Diğer faydalı IQP hint'leri
SELECT * FROM sales.orders o
JOIN sales.customers c ON c.customer_id = o.customer_id
WHERE c.city = N'İstanbul'
OPTION (
    USE HINT('FORCE_DEFAULT_CARDINALITY_ESTIMATION'),
    USE HINT('DISABLE_BATCH_MODE_ADAPTIVE_JOINS')
);
GO

-- Tüm USE HINT seçenekleri
SELECT * FROM sys.dm_exec_valid_use_hints;
GO

-- 4) Compatibility-level-bazlı IQP feature kontrolü
SELECT
    name,
    compatibility_level,
    is_query_store_on
FROM sys.databases
WHERE database_id > 4;
GO

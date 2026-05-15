-- ============================================================================
-- 04-resumable-index.sql
-- ----------------------------------------------------------------------------
-- Online + resumable index build / rebuild — büyük tablolarda kritik.
-- ============================================================================

USE demo;
GO

-- Online + Resumable index build
CREATE NONCLUSTERED INDEX ix_products_category_resumable
    ON sales.products (category)
    INCLUDE (name, price)
    WITH (ONLINE = ON, RESUMABLE = ON, MAX_DURATION = 60);  -- 60 dakika max
GO

-- Bir resumable işlemi pause/resume/abort
-- ALTER INDEX ix_products_category_resumable ON sales.products PAUSE;
-- ALTER INDEX ix_products_category_resumable ON sales.products RESUME;
-- ALTER INDEX ix_products_category_resumable ON sales.products ABORT;

-- Aktif resumable operasyonlar
SELECT
    object_id,
    OBJECT_NAME(object_id) AS table_name,
    name AS index_name,
    state_desc,
    percent_complete,
    start_time,
    last_pause_time,
    page_count,
    total_execution_time
FROM sys.index_resumable_operations;
GO

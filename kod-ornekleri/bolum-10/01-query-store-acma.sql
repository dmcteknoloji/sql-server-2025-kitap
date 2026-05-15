-- ============================================================================
-- 01-query-store-acma.sql
-- ----------------------------------------------------------------------------
-- Query Store: 2025'te varsayılan ON; ama retention ve capture ayarları
-- workload'a göre tuning gerektirir.
-- ============================================================================

USE demo;
GO

ALTER DATABASE demo SET QUERY_STORE = ON;
GO

ALTER DATABASE demo SET QUERY_STORE (
    OPERATION_MODE = READ_WRITE,
    CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),
    DATA_FLUSH_INTERVAL_SECONDS = 900,
    MAX_STORAGE_SIZE_MB = 1024,
    INTERVAL_LENGTH_MINUTES = 60,
    SIZE_BASED_CLEANUP_MODE = AUTO,
    QUERY_CAPTURE_MODE = AUTO,
    MAX_PLANS_PER_QUERY = 200,
    WAIT_STATS_CAPTURE_MODE = ON
);
GO

-- 2025: secondary replica'da da QS aktif olabilir
-- Doğru sözdizimi: QUERY_STORE seçenekleri içinde CAPTURE_MODE_FOR_SECONDARY
-- (ayrı bir SET QUERY_STORE_FOR_SECONDARY = ON komutu değil)
ALTER DATABASE demo SET QUERY_STORE = ON (
    OPERATION_MODE = READ_WRITE,
    CAPTURE_MODE_FOR_SECONDARY = AUTO     -- 2025: readable secondary'larda QS
);
GO

-- En çok kaynak tüketen sorgular (CPU)
SELECT TOP 10
    q.query_id,
    qt.query_sql_text,
    SUM(rs.count_executions) AS total_exec,
    SUM(rs.avg_cpu_time * rs.count_executions) / 1000.0 AS total_cpu_ms,
    SUM(rs.avg_duration * rs.count_executions) / 1000.0 AS total_duration_ms
FROM sys.query_store_query q
JOIN sys.query_store_query_text qt ON qt.query_text_id = q.query_text_id
JOIN sys.query_store_plan p ON p.query_id = q.query_id
JOIN sys.query_store_runtime_stats rs ON rs.plan_id = p.plan_id
GROUP BY q.query_id, qt.query_sql_text
ORDER BY total_cpu_ms DESC;
GO

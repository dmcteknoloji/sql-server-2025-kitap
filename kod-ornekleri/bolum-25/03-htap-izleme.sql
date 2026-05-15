-- ============================================================================
-- 03-htap-izleme.sql
-- ----------------------------------------------------------------------------
-- HTAP iş yükünün gözlenmesi: hangi pool ne kadar tüketiyor, wait stats,
-- lock contention, NCCI hot/cold rowgroup oranı.
-- ============================================================================

USE demo;
GO

-- 1) Pool kullanımı
SELECT
    rp.name AS pool,
    rp.statistics_start_time,
    rp.total_cpu_usage_ms,
    rp.used_memory_kb / 1024 AS used_mb,
    rp.target_memory_kb / 1024 AS target_mb
FROM sys.dm_resource_governor_resource_pools rp;

-- 2) Workload group istatistikleri
SELECT
    wg.name AS workload_group,
    wg.total_request_count,
    wg.total_cpu_usage_ms,
    wg.total_lock_wait_time_ms,
    wg.active_request_count
FROM sys.dm_resource_governor_workload_groups wg;

-- 3) Wait stats: HTAP'ı bozan en yaygın wait'ler
SELECT TOP(10)
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    wait_time_ms / NULLIF(waiting_tasks_count, 0) AS avg_wait_ms
FROM sys.dm_os_wait_stats
WHERE wait_type IN (
    'PAGELATCH_EX', 'PAGELATCH_SH', 'PAGEIOLATCH_SH',
    'LCK_M_X', 'LCK_M_S', 'LCK_M_U',
    'HADR_SYNC_COMMIT', 'RESOURCE_SEMAPHORE',
    'CXPACKET', 'CXCONSUMER',
    'SOS_SCHEDULER_YIELD'
)
ORDER BY wait_time_ms DESC;

-- 4) NCCI rowgroup sağlığı (HTAP için kritik)
SELECT
    object_name(s.object_id) AS table_name,
    s.state_desc,
    COUNT(*) AS rg_count,
    SUM(s.total_rows) AS total_rows,
    SUM(s.deleted_rows) AS deleted_rows,
    CAST(SUM(s.deleted_rows) * 100.0 / NULLIF(SUM(s.total_rows), 0) AS DECIMAL(5,2)) AS deleted_pct
FROM sys.dm_db_column_store_row_group_physical_stats s
GROUP BY s.object_id, s.state_desc
ORDER BY total_rows DESC;

-- 5) Lock contention (Optimized Locking sonrası)
SELECT TOP(20)
    request_session_id,
    resource_type,
    request_mode,
    request_status,
    wait_duration_ms
FROM sys.dm_os_waiting_tasks
WHERE wait_type LIKE 'LCK_%';
GO

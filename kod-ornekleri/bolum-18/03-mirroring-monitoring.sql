-- ============================================================================
-- 03-mirroring-monitoring.sql
-- ----------------------------------------------------------------------------
-- Mirroring durumu, gecikme, scan progress.
-- ============================================================================

-- DMV listesi (sürüme göre değişebilir; doğrulayın)
-- Microsoft Learn referans:
-- https://learn.microsoft.com/en-us/fabric/mirroring/sql-server-performance

-- 1) Aktif mirror objeler
SELECT *
FROM sys.dm_change_feeds_log_scan_sessions
ORDER BY start_time DESC;
GO

-- 2) Scan throughput
SELECT
    DB_NAME(database_id) AS db_name,
    last_scan_start_time,
    last_scan_end_time,
    last_scan_lsn,
    total_transactions,
    total_log_records
FROM sys.dm_change_feeds_log_scan_sessions
WHERE database_id = DB_ID();
GO

-- 3) Mirroring trace
SELECT *
FROM sys.fn_trace_gettable(
    CONVERT(VARCHAR(MAX),
        (SELECT TOP 1 path FROM sys.traces WHERE is_default = 1)),
    DEFAULT
)
WHERE event_class IN (
    SELECT trace_event_id FROM sys.trace_events
    WHERE name LIKE N'%Mirror%' OR name LIKE N'%Change Feed%'
)
ORDER BY start_time DESC;
GO

-- 4) Transaction log boyutu (autoreseed devreye girer mi?)
DBCC SQLPERF(LOGSPACE);
GO

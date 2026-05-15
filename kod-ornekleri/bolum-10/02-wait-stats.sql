-- ============================================================================
-- 02-wait-stats.sql
-- ----------------------------------------------------------------------------
-- Wait stats analizi: SQL Server neyi bekliyor?
-- ============================================================================

-- Toplam wait stats (instance start'tan beri)
SELECT TOP 20
    wait_type,
    waiting_tasks_count,
    wait_time_ms / 1000.0 AS wait_seconds,
    (wait_time_ms - signal_wait_time_ms) / 1000.0 AS resource_wait_seconds,
    signal_wait_time_ms / 1000.0 AS signal_wait_seconds,
    100.0 * wait_time_ms / SUM(wait_time_ms) OVER () AS pct_total
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    -- Benign wait'ler — ignore listesi (Paul Randal'ın yaklaşımı)
    'CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE',
    'SLEEP_TASK','SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH',
    'WAITFOR','LOGMGR_QUEUE','CHECKPOINT_QUEUE',
    'REQUEST_FOR_DEADLOCK_SEARCH','XE_TIMER_EVENT','BROKER_TO_FLUSH',
    'BROKER_TASK_STOP','CLR_MANUAL_EVENT','CLR_AUTO_EVENT',
    'DISPATCHER_QUEUE_SEMAPHORE','FT_IFTS_SCHEDULER_IDLE_WAIT',
    'XE_DISPATCHER_WAIT','XE_DISPATCHER_JOIN','BROKER_EVENTHANDLER',
    'TRACEWRITE','FT_IFTSHC_MUTEX','SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
    'BROKER_RECEIVE_WAITFOR','ONDEMAND_TASK_QUEUE','DBMIRROR_EVENTS_QUEUE',
    'DBMIRRORING_CMD','BROKER_TRANSMITTER','SQLTRACE_WAIT_ENTRIES',
    'SLEEP_BPOOL_FLUSH','HADR_FILESTREAM_IOMGR_IOCOMPLETION',
    'DIRTY_PAGE_POLL','SP_SERVER_DIAGNOSTICS_SLEEP'
) AND wait_time_ms > 0
ORDER BY wait_time_ms DESC;
GO

-- Per-statement wait analizi (Query Store)
SELECT TOP 20
    ws.wait_category_desc,
    SUM(ws.total_query_wait_time_ms) AS total_wait_ms,
    COUNT(DISTINCT q.query_id) AS distinct_queries
FROM sys.query_store_wait_stats ws
JOIN sys.query_store_plan p ON p.plan_id = ws.plan_id
JOIN sys.query_store_query q ON q.query_id = p.query_id
GROUP BY ws.wait_category_desc
ORDER BY total_wait_ms DESC;
GO

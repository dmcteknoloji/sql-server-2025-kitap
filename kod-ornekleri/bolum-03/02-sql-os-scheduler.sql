-- ============================================================================
-- 02-sql-os-scheduler.sql
-- ----------------------------------------------------------------------------
-- SQLOS scheduler'lar, worker thread'ler.
-- ============================================================================

-- Aktif scheduler'lar (CPU başına bir tane)
SELECT
    scheduler_id,
    cpu_id,
    status,
    is_online,
    current_tasks_count,
    runnable_tasks_count,
    work_queue_count,
    active_workers_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255
ORDER BY scheduler_id;
GO

-- Toplam worker thread sayısı
SELECT
    max_workers_count,
    SUM(active_workers_count) AS total_active_workers
FROM sys.dm_os_sys_info
CROSS JOIN sys.dm_os_schedulers
WHERE scheduler_id < 255
GROUP BY max_workers_count;
GO

-- En çok CPU tüketen oturumlar
SELECT TOP 10
    session_id,
    cpu_time,
    total_elapsed_time,
    DB_NAME(database_id) AS db,
    program_name,
    login_name,
    status
FROM sys.dm_exec_sessions
WHERE is_user_process = 1
ORDER BY cpu_time DESC;
GO

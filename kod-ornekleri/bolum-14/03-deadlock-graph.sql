-- ============================================================================
-- 03-deadlock-graph.sql
-- ----------------------------------------------------------------------------
-- Deadlock yakala ve analiz et.
-- ============================================================================

USE master;
GO

-- 1) Deadlock graph yakalayan Extended Events session
IF EXISTS (SELECT 1 FROM sys.server_event_sessions WHERE name = N'deadlock_capture')
    DROP EVENT SESSION [deadlock_capture] ON SERVER;
GO

CREATE EVENT SESSION [deadlock_capture] ON SERVER
ADD EVENT sqlserver.xml_deadlock_report
ADD TARGET package0.event_file (
    SET filename = N'C:\XEvents\deadlocks.xel',
        max_file_size = 64,
        max_rollover_files = 10
)
WITH (
    STARTUP_STATE = ON,
    MAX_MEMORY = 4096 KB
);
GO

ALTER EVENT SESSION [deadlock_capture] ON SERVER STATE = START;
GO

-- 2) System health session'dan deadlock'ları çek (her zaman çalışıyor)
WITH dl AS (
    SELECT CAST(event_data AS XML) AS event_data
    FROM sys.fn_xe_file_target_read_file('system_health*.xel', NULL, NULL, NULL)
    WHERE OBJECT_NAME = 'xml_deadlock_report'
)
SELECT TOP 10
    event_data.value('(/event/@timestamp)[1]','datetime2') AS deadlock_time,
    event_data.value('(/event/data/value/deadlock/victim-list/victimProcess/@id)[1]','varchar(50)') AS victim,
    event_data
FROM dl
ORDER BY deadlock_time DESC;
GO

-- 3) Deadlock priority ayarı (transaction'ı victim olmaktan korumak için)
-- SET DEADLOCK_PRIORITY HIGH;   -- veya LOW, NORMAL, sayısal -10..+10

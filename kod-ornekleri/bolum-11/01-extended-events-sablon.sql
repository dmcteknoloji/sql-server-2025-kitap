-- ============================================================================
-- 01-extended-events-sablon.sql
-- ----------------------------------------------------------------------------
-- Extended Events session: yavaş sorguları yakala, dosyaya yaz.
-- 2025: time-bound XE session (otomatik durur).
-- ============================================================================

USE master;
GO

-- Eski session varsa düşür
IF EXISTS (SELECT 1 FROM sys.server_event_sessions WHERE name = N'slow_queries')
    DROP EVENT SESSION [slow_queries] ON SERVER;
GO

CREATE EVENT SESSION [slow_queries] ON SERVER
ADD EVENT sqlserver.rpc_completed (
    ACTION (sqlserver.client_app_name, sqlserver.username, sqlserver.database_name)
    WHERE ([duration] > (5000000))   -- 5 saniye (microsecond); [duration] reserved bracket'lı
),
ADD EVENT sqlserver.sql_batch_completed (
    ACTION (sqlserver.client_app_name, sqlserver.username, sqlserver.database_name)
    WHERE ([duration] > (5000000))
)
ADD TARGET package0.event_file (
    SET filename = N'C:\XEvents\slow_queries.xel',
        max_file_size = 256,
        max_rollover_files = 5
)
WITH (
    MAX_MEMORY = 4096 KB,
    EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY = 5 SECONDS,
    TRACK_CAUSALITY = ON,
    STARTUP_STATE = OFF
    -- 2025 time-bound XE: WITH (DURATION = N SECONDS) son CU notlarında teyit edin.
    -- Preview ise PREVIEW_FEATURES gerek.
);
GO

ALTER EVENT SESSION [slow_queries] ON SERVER STATE = START;
GO

-- Toplanan event'leri oku
SELECT TOP 100
    event_data.value('(/event/@name)[1]','varchar(50)') AS event_name,
    event_data.value('(/event/@timestamp)[1]','datetime2') AS event_time,
    event_data.value('(/event/data[@name="duration"]/value)[1]','bigint') / 1000.0 AS duration_ms,
    event_data.value('(/event/action[@name="database_name"]/value)[1]','nvarchar(100)') AS db_name,
    event_data.value('(/event/data[@name="statement"]/value)[1]','nvarchar(max)') AS statement
FROM (
    SELECT CAST(event_data AS XML) AS event_data
    FROM sys.fn_xe_file_target_read_file('C:\XEvents\slow_queries*.xel', NULL, NULL, NULL)
) e
ORDER BY event_time DESC;
GO

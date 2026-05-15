-- ============================================================================
-- 02-agent-audit-rate-limit.sql
-- ----------------------------------------------------------------------------
-- Agent erişimini izleme + rate limit + anomali tespiti.
-- ============================================================================

USE demo;
GO

-- Agent audit tablosu
IF OBJECT_ID('agent_view.audit_log','U') IS NULL
BEGIN
    CREATE TABLE agent_view.audit_log (
        log_id        BIGINT       NOT NULL IDENTITY PRIMARY KEY,
        agent_id      NVARCHAR(80) NOT NULL,
        client_ip     NVARCHAR(45) NULL,
        request_kind  NVARCHAR(40) NOT NULL,  -- 'list_tables', 'execute_query', vb.
        tool_name     NVARCHAR(80) NULL,
        request_body  NVARCHAR(MAX) NULL,
        status_code   INT          NULL,
        latency_ms    INT          NULL,
        flagged       BIT          NOT NULL DEFAULT 0,
        flag_reason   NVARCHAR(200) NULL,
        created_at    DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
        INDEX ix_audit_agent_time (agent_id, created_at)
    );
END
GO

-- Rate-limit kontrolü (sliding window)
CREATE OR ALTER PROCEDURE agent_view.usp_check_rate_limit
    @agent_id NVARCHAR(80),
    @max_per_minute INT = 60,
    @ok BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @cnt INT;

    SELECT @cnt = COUNT(*)
    FROM agent_view.audit_log
    WHERE agent_id = @agent_id
      AND created_at >= DATEADD(MINUTE, -1, SYSUTCDATETIME());

    IF @cnt >= @max_per_minute
    BEGIN
        SET @ok = 0;
        INSERT INTO agent_view.audit_log (agent_id, request_kind, flagged, flag_reason)
        VALUES (@agent_id, N'rate_limit_block', 1,
                CONCAT(N'Limit aşıldı: ', @cnt, N' istek/dk'));
    END
    ELSE
        SET @ok = 1;
END
GO

-- Anomali tespiti: gece yarısı saatleri yoğun erişim, tek bir agent çok kayda dokunuyor
CREATE OR ALTER VIEW agent_view.anomalies
AS
WITH hourly AS (
    SELECT
        agent_id,
        DATEPART(HOUR, created_at) AS hour_of_day,
        COUNT(*) AS req_count
    FROM agent_view.audit_log
    WHERE created_at >= DATEADD(DAY, -7, SYSUTCDATETIME())
    GROUP BY agent_id, DATEPART(HOUR, created_at)
)
SELECT
    agent_id,
    hour_of_day,
    req_count,
    AVG(req_count) OVER (PARTITION BY agent_id) AS avg_per_hour,
    CASE
        WHEN req_count > AVG(req_count) OVER (PARTITION BY agent_id) * 3 THEN N'SPIKE'
        WHEN hour_of_day BETWEEN 0 AND 5 AND req_count > 10 THEN N'NIGHT_ACTIVITY'
        ELSE NULL
    END AS anomaly_flag
FROM hourly;
GO

PRINT N'Agent audit + rate limit + anomali tespiti hazır';
GO

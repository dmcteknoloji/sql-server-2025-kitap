-- ============================================================================
-- 05-resource-governor.sql
-- ----------------------------------------------------------------------------
-- Resource Governor: workload izolasyonu. 2025 Standard edition'da da var.
-- ============================================================================

USE master;
GO

-- 1) Resource pool
CREATE RESOURCE POOL pool_analytics
WITH (
    MIN_CPU_PERCENT = 0,
    MAX_CPU_PERCENT = 30,
    MIN_MEMORY_PERCENT = 0,
    MAX_MEMORY_PERCENT = 25
);
GO

-- 2) Workload group
CREATE WORKLOAD GROUP wg_reporting
WITH (
    IMPORTANCE = LOW,
    REQUEST_MAX_CPU_TIME_SEC = 600,
    REQUEST_MAX_MEMORY_GRANT_PERCENT = 10,
    MAX_DOP = 4
)
USING pool_analytics;
GO

-- 3) Classifier function: hangi connection hangi workload group'a gider
CREATE OR ALTER FUNCTION dbo.fn_rg_classifier()
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @group SYSNAME;
    IF (SUSER_NAME() LIKE '%reporting%' OR APP_NAME() LIKE '%PowerBI%')
        SET @group = N'wg_reporting';
    ELSE
        SET @group = N'default';
    RETURN @group;
END;
GO

-- 4) Resource Governor'ı aktive et
ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = dbo.fn_rg_classifier);
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO

-- 5) Aktif workload group'lar
SELECT
    pool.name AS pool_name,
    pool.max_cpu_percent,
    pool.max_memory_percent,
    wg.name AS workload_group,
    wg.importance,
    wg.max_dop
FROM sys.dm_resource_governor_resource_pools pool
JOIN sys.dm_resource_governor_workload_groups wg ON wg.pool_id = pool.pool_id;
GO

-- ============================================================================
-- 01-resource-governor-htap.sql
-- ----------------------------------------------------------------------------
-- HTAP için Resource Governor pool'ları: OLTP / OLAP / AI üçlüsü.
-- 2025'te Standard edition'a açıldı.
-- ============================================================================

USE master;
GO

-- Mevcut yapılandırmayı temizle (test için)
ALTER RESOURCE GOVERNOR DISABLE;
GO

-- 1) Resource pool'lar
IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_resource_pools WHERE name = 'oltp_pool')
    CREATE RESOURCE POOL oltp_pool
    WITH (MAX_MEMORY_PERCENT = 30, MAX_CPU_PERCENT = 50);

IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_resource_pools WHERE name = 'olap_pool')
    CREATE RESOURCE POOL olap_pool
    WITH (MAX_MEMORY_PERCENT = 40, MAX_CPU_PERCENT = 60,
          REQUEST_MAX_MEMORY_GRANT_PERCENT = 25);

IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_resource_pools WHERE name = 'ai_pool')
    CREATE RESOURCE POOL ai_pool
    WITH (MAX_MEMORY_PERCENT = 20, MAX_CPU_PERCENT = 30);
GO

-- 2) Workload group'lar
IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_workload_groups WHERE name = 'oltp_wg')
    CREATE WORKLOAD GROUP oltp_wg USING oltp_pool
    WITH (IMPORTANCE = HIGH, REQUEST_MAX_CPU_TIME_SEC = 30);

IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_workload_groups WHERE name = 'olap_wg')
    CREATE WORKLOAD GROUP olap_wg USING olap_pool
    WITH (IMPORTANCE = MEDIUM, REQUEST_MAX_CPU_TIME_SEC = 900);

IF NOT EXISTS (SELECT 1 FROM sys.resource_governor_workload_groups WHERE name = 'ai_wg')
    CREATE WORKLOAD GROUP ai_wg USING ai_pool
    WITH (IMPORTANCE = LOW, REQUEST_MAX_CPU_TIME_SEC = 3600);
GO

-- 3) Classifier function
IF OBJECT_ID('dbo.fn_classify_workload','FN') IS NOT NULL
    DROP FUNCTION dbo.fn_classify_workload;
GO

CREATE FUNCTION dbo.fn_classify_workload()
RETURNS SYSNAME WITH SCHEMABINDING
AS
BEGIN
    DECLARE @group SYSNAME = N'default';
    DECLARE @app NVARCHAR(128) = APP_NAME();
    DECLARE @login NVARCHAR(128) = SUSER_SNAME();

    IF @app LIKE N'%API%' OR @app LIKE N'%Web%'
        SET @group = N'oltp_wg';
    ELSE IF @app LIKE N'%Reporting%' OR @app LIKE N'%PowerBI%'
        SET @group = N'olap_wg';
    ELSE IF @app LIKE N'%Embedding%' OR @login LIKE N'%ai_batch%'
        SET @group = N'ai_wg';

    RETURN @group;
END
GO

-- 4) Bağla ve aktif et
ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = dbo.fn_classify_workload);
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO

-- Doğrulama
SELECT name, statistics_start_time FROM sys.dm_resource_governor_resource_pools;
SELECT name, total_request_count FROM sys.dm_resource_governor_workload_groups;
GO

PRINT N'Resource Governor HTAP yapılandırması aktif: oltp_wg + olap_wg + ai_wg';
GO

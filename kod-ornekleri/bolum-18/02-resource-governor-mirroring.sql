-- ============================================================================
-- 02-resource-governor-mirroring.sql
-- ----------------------------------------------------------------------------
-- Mirroring scan worker'ı için dedicated workload group.
-- Ana OLTP yüküne etki etmesin.
-- ============================================================================

USE master;
GO

-- Dedicated resource pool
IF EXISTS (SELECT 1 FROM sys.dm_resource_governor_resource_pools WHERE name = N'pool_mirror')
    DROP RESOURCE POOL pool_mirror;

CREATE RESOURCE POOL pool_mirror
WITH (
    MIN_CPU_PERCENT = 0,
    MAX_CPU_PERCENT = 20,
    MIN_MEMORY_PERCENT = 0,
    MAX_MEMORY_PERCENT = 15
);
GO

-- Workload group
IF EXISTS (SELECT 1 FROM sys.dm_resource_governor_workload_groups WHERE name = N'wg_mirror')
    DROP WORKLOAD GROUP wg_mirror;

CREATE WORKLOAD GROUP wg_mirror
WITH (
    IMPORTANCE = LOW,
    REQUEST_MAX_CPU_TIME_SEC = 0,
    REQUEST_MAX_MEMORY_GRANT_PERCENT = 10,
    MAX_DOP = 2
)
USING pool_mirror;
GO

-- Classifier: Fabric mirroring scan worker'ını yakala
-- Microsoft Learn'in "Optimize Performance of Mirrored Databases" sayfasında
-- Fabric scan worker'ının program name pattern'i belirtilir; o pattern'i kullanın.

CREATE OR ALTER FUNCTION dbo.fn_rg_classifier_mirror()
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @group SYSNAME;
    IF APP_NAME() LIKE N'%MirrorScan%' OR ORIGINAL_LOGIN() LIKE N'%mirror%'
        SET @group = N'wg_mirror';
    ELSE
        SET @group = N'default';
    RETURN @group;
END;
GO

ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = dbo.fn_rg_classifier_mirror);
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO

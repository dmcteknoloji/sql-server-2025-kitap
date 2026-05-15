-- ============================================================================
-- 01-mirroring-onkosullar.sql
-- ----------------------------------------------------------------------------
-- Fabric Mirroring için bir veritabanını uygunluk kontrolünden geçirir.
-- ============================================================================

USE demo;
GO

-- 1) Arc-enabled instance kontrolü
SELECT
    SERVERPROPERTY('ProductVersion') AS version,
    SERVERPROPERTY('AzureMachineName') AS arc_machine,
    SERVERPROPERTY('AzureResourceGroupName') AS arc_rg;
GO

-- 2) Primary key olmayan tablolar (mirror'a alınamaz)
SELECT
    SCHEMA_NAME(t.schema_id) + '.' + t.name AS table_name,
    'PK yok — mirror edilemez' AS issue
FROM sys.tables t
LEFT JOIN sys.indexes i ON i.object_id = t.object_id AND i.is_primary_key = 1
WHERE i.index_id IS NULL
  AND t.is_ms_shipped = 0;
GO

-- 3) Desteklenmeyen tip içeren tablolar
SELECT DISTINCT
    SCHEMA_NAME(t.schema_id) + '.' + t.name AS table_name,
    c.name AS column_name,
    TYPE_NAME(c.user_type_id) AS data_type
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id
WHERE TYPE_NAME(c.user_type_id) IN (
    'geometry', 'geography', 'hierarchyid', 'sql_variant',
    'xml', 'timestamp', 'rowversion'
);
GO

-- 4) Change Data Capture / Change Tracking çakışma kontrolü
SELECT
    DB_NAME(database_id) AS db_name,
    is_cdc_enabled,
    is_change_tracking_on
FROM sys.databases
WHERE database_id = DB_ID();
GO

-- 5) Tablo bazlı CDC enabled
SELECT
    SCHEMA_NAME(schema_id) + '.' + OBJECT_NAME(object_id) AS table_name,
    is_tracked_by_cdc
FROM sys.tables
WHERE is_tracked_by_cdc = 1;
GO

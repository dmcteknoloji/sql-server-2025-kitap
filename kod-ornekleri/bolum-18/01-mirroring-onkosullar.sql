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
-- Not: sys.databases'te is_change_tracking_on diye bir sütun YOKTUR.
-- Change tracking durumu ayrı bir katalog görünümünde tutulur:
-- sys.change_tracking_databases (satır varsa CT açıktır).
SELECT
    DB_NAME(d.database_id) AS db_name,
    d.is_cdc_enabled,
    CAST(CASE WHEN ct.database_id IS NULL THEN 0 ELSE 1 END AS BIT) AS is_change_tracking_on,
    ct.retention_period,
    ct.retention_period_units
FROM sys.databases d
LEFT JOIN sys.change_tracking_databases ct
    ON ct.database_id = d.database_id
WHERE d.database_id = DB_ID();
GO

-- 5) Tablo bazlı CDC enabled
SELECT
    SCHEMA_NAME(schema_id) + '.' + OBJECT_NAME(object_id) AS table_name,
    is_tracked_by_cdc
FROM sys.tables
WHERE is_tracked_by_cdc = 1;
GO

-- ============================================================================
-- 03-ledger-temporal-filestream.sql
-- ----------------------------------------------------------------------------
-- Süregelen özelliklerin durumu: ledger, temporal, filestream, change tracking.
-- ============================================================================

-- Ledger tablolar (2022+)
SELECT
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS table_name,
    is_ledger,
    ledger_type_desc,
    is_dropped_ledger_table  -- sys.tables sütun adı _table eki ile bitiyor
FROM sys.tables
WHERE is_ledger = 1;
GO

-- Temporal (system-versioned) tablolar
SELECT
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS table_name,
    temporal_type_desc,
    history_table_id
FROM sys.tables
WHERE temporal_type > 0;
GO

-- FILESTREAM filegroup'lar
SELECT
    name AS filegroup_name,
    type_desc
FROM sys.filegroups
WHERE type IN ('FX','FD');
GO

-- Change Tracking enabled databases
SELECT
    DB_NAME(database_id) AS db_name,
    is_auto_cleanup_on,
    retention_period,
    retention_period_units_desc
FROM sys.change_tracking_databases;
GO

-- Service Broker durumu
SELECT
    DB_NAME(database_id) AS db_name,
    is_broker_enabled
FROM sys.databases
WHERE database_id > 4;
GO

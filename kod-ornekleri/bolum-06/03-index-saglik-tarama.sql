-- ============================================================================
-- 03-index-saglik-tarama.sql
-- ----------------------------------------------------------------------------
-- Fragmentation, missing index, unused index taraması.
-- ============================================================================

USE demo;
GO

-- 1) Fragmentation
SELECT
    OBJECT_SCHEMA_NAME(ips.object_id) AS schema_name,
    OBJECT_NAME(ips.object_id) AS table_name,
    i.name AS index_name,
    ips.index_type_desc,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count > 100
  AND ips.avg_fragmentation_in_percent > 10
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO

-- 2) Missing index önerileri
SELECT TOP 20
    DB_NAME(mid.database_id) AS db_name,
    OBJECT_NAME(mid.object_id, mid.database_id) AS table_name,
    migs.user_seeks * (migs.avg_total_user_cost * migs.avg_user_impact / 100.0) AS estimated_benefit,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_groups mig
JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON mid.index_handle = mig.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY estimated_benefit DESC;
GO

-- 3) Unused index'ler
SELECT
    OBJECT_SCHEMA_NAME(i.object_id) + '.' + OBJECT_NAME(i.object_id) AS object_name,
    i.name AS index_name,
    i.type_desc,
    ISNULL(s.user_seeks, 0) + ISNULL(s.user_scans, 0) + ISNULL(s.user_lookups, 0) AS reads,
    ISNULL(s.user_updates, 0) AS writes
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats s
       ON s.object_id = i.object_id AND s.index_id = i.index_id AND s.database_id = DB_ID()
WHERE i.is_primary_key = 0 AND i.is_unique_constraint = 0
  AND OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
  AND ISNULL(s.user_seeks, 0) + ISNULL(s.user_scans, 0) + ISNULL(s.user_lookups, 0) = 0
  AND ISNULL(s.user_updates, 0) > 0
ORDER BY writes DESC;
GO

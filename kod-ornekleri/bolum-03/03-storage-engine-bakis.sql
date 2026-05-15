-- ============================================================================
-- 03-storage-engine-bakis.sql
-- ----------------------------------------------------------------------------
-- Buffer pool dağılımı, plan cache, dosya boyutları.
-- ============================================================================

-- Buffer pool: hangi veritabanı ne kadar memory kullanıyor?
SELECT
    DB_NAME(database_id) AS db_name,
    COUNT(*) * 8 / 1024.0 AS buffer_mb
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4
GROUP BY DB_NAME(database_id)
ORDER BY buffer_mb DESC;
GO

-- Plan cache: hangi sorgu tipi ne kadar yer kapatıyor?
SELECT
    cacheobjtype,
    objtype,
    COUNT(*) AS cnt,
    SUM(size_in_bytes) / 1024.0 / 1024.0 AS size_mb
FROM sys.dm_exec_cached_plans
GROUP BY cacheobjtype, objtype
ORDER BY size_mb DESC;
GO

-- Data file'lar: boyut ve auto-growth
SELECT
    DB_NAME(database_id) AS db_name,
    type_desc,
    name AS logical_name,
    physical_name,
    size * 8 / 1024.0 AS size_mb,
    CASE WHEN is_percent_growth = 1
         THEN CAST(growth AS NVARCHAR(20)) + N' %'
         ELSE CAST(growth * 8 / 1024.0 AS NVARCHAR(20)) + N' MB'
    END AS growth
FROM sys.master_files
WHERE database_id > 4
ORDER BY db_name, type_desc;
GO

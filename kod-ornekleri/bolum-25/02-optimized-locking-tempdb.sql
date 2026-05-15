-- ============================================================================
-- 02-optimized-locking-tempdb.sql
-- ----------------------------------------------------------------------------
-- HTAP için Optimized Locking + tempdb governance yapılandırması.
-- ============================================================================

-- Optimized Locking veritabanı seviyesinde
ALTER DATABASE demo SET READ_COMMITTED_SNAPSHOT = ON;
GO
USE demo;
GO
ALTER DATABASE SCOPED CONFIGURATION SET OPTIMIZED_LOCKING = ON;
GO

-- Doğrulama
SELECT name,
       is_read_committed_snapshot_on,
       is_accelerated_database_recovery_on
FROM sys.databases
WHERE name = N'demo';
GO

-- tempdb governance (workload group başına kota)
USE master;
GO

ALTER WORKLOAD GROUP olap_wg
WITH (REQUEST_MAX_TEMPDB_GRANT_PERCENT = 30);

ALTER WORKLOAD GROUP oltp_wg
WITH (REQUEST_MAX_TEMPDB_GRANT_PERCENT = 5);

ALTER WORKLOAD GROUP ai_wg
WITH (REQUEST_MAX_TEMPDB_GRANT_PERCENT = 15);

ALTER RESOURCE GOVERNOR RECONFIGURE;
GO

-- tempdb fiziksel sağlık
SELECT file_id, name, type_desc,
       size * 8 / 1024 AS size_mb,
       max_size,
       is_percent_growth, growth
FROM tempdb.sys.database_files;
GO

-- tempdb için ADR (2025'te destekleniyor)
ALTER DATABASE tempdb SET ACCELERATED_DATABASE_RECOVERY = ON;
GO

PRINT N'Optimized Locking aktif; tempdb governance kotaları ayarlandı';
GO

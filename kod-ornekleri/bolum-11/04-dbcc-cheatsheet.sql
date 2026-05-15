-- ============================================================================
-- 04-dbcc-cheatsheet.sql
-- ----------------------------------------------------------------------------
-- DBA'in günlük cebinde olması gereken DBCC komutları.
-- ============================================================================

-- 1) Veritabanı bütünlük kontrolü
DBCC CHECKDB ('demo') WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO

-- 2) Sadece bir tablo kontrolü
DBCC CHECKTABLE ('sales.orders') WITH NO_INFOMSGS;
GO

-- 3) Memory durumu
DBCC MEMORYSTATUS;
GO

-- 4) Buffer cache içeriği
DBCC SQLPERF (LOGSPACE);
GO

-- 5) Çalışan istatistikleri
-- PK constraint isimleri otomatik hash'lidir (PK__orders__<hash>);
-- dinamik bul ve sp_executesql ile çalıştır.
DECLARE @stats_name SYSNAME =
    (SELECT TOP(1) name FROM sys.stats
     WHERE object_id = OBJECT_ID('sales.orders') AND auto_created = 0
     ORDER BY stats_id);
DECLARE @sql NVARCHAR(MAX) =
    N'DBCC SHOW_STATISTICS (''sales.orders'', ''' + @stats_name + N''') WITH HISTOGRAM;';
EXEC sp_executesql @sql;
GO

-- 6) Free pages
DBCC SHOWFILESTATS;
GO

-- 7) Cache'i temizle (DEV/TEST only — production'da kullanma)
-- DBCC DROPCLEANBUFFERS;
-- DBCC FREEPROCCACHE;

-- 8) Plan cache durumu
SELECT
    SUM(cntr_value) / 1024.0 AS plan_cache_mb
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Cache Pages' AND object_name LIKE '%Plan Cache%';
GO

-- 9) Tüm sistem DB'lerin son sağlık tarihi
SELECT
    DB_NAME(database_id) AS db_name,
    state_desc,
    log_reuse_wait_desc,
    is_read_committed_snapshot_on,
    is_accelerated_database_recovery_on
FROM sys.databases;
GO

-- ============================================================================
-- 03-restore-point-in-time.sql
-- ----------------------------------------------------------------------------
-- Geri yükleme + STOPAT ile belirli zamana geri dönüş.
-- ============================================================================

USE master;
GO

-- DB'yi single user moda al
ALTER DATABASE demo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- 1) Full restore (NORECOVERY ile — sonraki backup'ları uygulayacağız)
RESTORE DATABASE demo
FROM DISK = N'C:\Backup\demo_full.bak'
WITH NORECOVERY, REPLACE, STATS = 10;
GO

-- 2) Differential restore
RESTORE DATABASE demo
FROM DISK = N'C:\Backup\demo_diff.bak'
WITH NORECOVERY, STATS = 10;
GO

-- 3) Log restore (point-in-time için STOPAT)
RESTORE LOG demo
FROM DISK = N'C:\Backup\demo_log_1.trn'
WITH STOPAT = N'2026-05-15 11:30:00',  -- istediğiniz an
     RECOVERY,
     STATS = 10;
GO

-- DB'yi multi-user moda geri al
ALTER DATABASE demo SET MULTI_USER;
GO

-- Backup zincirinin son halini görüntüle
SELECT
    bs.database_name,
    bs.backup_start_date,
    bs.backup_finish_date,
    bs.type AS backup_type,  -- D: full, I: diff, L: log
    bs.backup_size / 1024.0 / 1024.0 AS size_mb,
    bs.compressed_backup_size / 1024.0 / 1024.0 AS compressed_mb
FROM msdb.dbo.backupset bs
WHERE bs.database_name = N'demo'
ORDER BY bs.backup_finish_date DESC;
GO

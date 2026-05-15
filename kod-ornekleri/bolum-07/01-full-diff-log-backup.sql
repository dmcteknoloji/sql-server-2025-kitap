-- ============================================================================
-- 01-full-diff-log-backup.sql
-- ----------------------------------------------------------------------------
-- Standart yedek zinciri: full + differential + log.
-- Önkoşul: demo veritabanı FULL recovery model'da olmalı.
-- ============================================================================

USE master;
GO

ALTER DATABASE demo SET RECOVERY FULL;
GO

-- 1) Full backup
BACKUP DATABASE demo
TO DISK = N'C:\Backup\demo_full.bak'
WITH FORMAT, INIT,
     NAME = N'demo full backup',
     COMPRESSION,
     CHECKSUM,
     STATS = 10;
GO

-- 2) Differential backup (full sonrası değişimler)
BACKUP DATABASE demo
TO DISK = N'C:\Backup\demo_diff.bak'
WITH DIFFERENTIAL, FORMAT, INIT,
     NAME = N'demo diff backup',
     COMPRESSION,
     CHECKSUM,
     STATS = 10;
GO

-- 3) Transaction log backup (point-in-time recovery için)
BACKUP LOG demo
TO DISK = N'C:\Backup\demo_log_1.trn'
WITH FORMAT, INIT,
     NAME = N'demo log backup 1',
     COMPRESSION,
     CHECKSUM,
     STATS = 10;
GO

-- BUFFERCOUNT, MAXTRANSFERSIZE ile tuning (büyük DB'lerde)
/*
BACKUP DATABASE demo
TO DISK = N'C:\Backup\demo_full_tuned.bak'
WITH FORMAT, INIT,
     COMPRESSION,
     CHECKSUM,
     BUFFERCOUNT = 50,
     MAXTRANSFERSIZE = 4194304,  -- 4 MB
     BLOCKSIZE = 65536,
     STATS = 10;
*/

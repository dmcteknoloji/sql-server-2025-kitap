-- ============================================================================
-- 04-immutable-blob-backup.sql
-- ----------------------------------------------------------------------------
-- Azure immutable blob'a backup (ransomware koruma).
-- Önkoşul: Azure Storage hesabı + immutable policy (time-based retention).
-- ============================================================================

-- 1) Azure Storage'a credential
CREATE CREDENTIAL [https://yourstorage.blob.core.windows.net/backups]
    WITH IDENTITY = 'Managed Identity';   -- Arc-enabled SQL Server üstünde
GO

-- 2) URL'e backup (BACKUP TO URL)
BACKUP DATABASE demo
TO URL = N'https://yourstorage.blob.core.windows.net/backups/demo_full_2026-05-15.bak'
WITH FORMAT, INIT,
     COMPRESSION (ALGORITHM = ZSTD),
     CHECKSUM,
     MAXTRANSFERSIZE = 4194304,
     STATS = 10;
GO

-- 3) Immutable policy Azure tarafında ayarlanır:
--    az storage container immutability-policy create \
--        --account-name yourstorage \
--        --container-name backups \
--        --period 30   # 30 gün silinemez

-- 4) Yedek alındığında doğrula
RESTORE VERIFYONLY
FROM URL = N'https://yourstorage.blob.core.windows.net/backups/demo_full_2026-05-15.bak';
GO

-- Microsoft Learn referans:
-- https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url

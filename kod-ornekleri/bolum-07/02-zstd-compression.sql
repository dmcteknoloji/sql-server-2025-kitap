-- ============================================================================
-- 02-zstd-compression.sql
-- ----------------------------------------------------------------------------
-- ZSTD backup compression (2025) — varsayılan MS_XPRESS yerine daha iyi oran.
-- ============================================================================

-- Backup compression algorithm seçimi
BACKUP DATABASE demo
TO DISK = N'C:\Backup\demo_zstd.bak'
WITH FORMAT, INIT,
     COMPRESSION (ALGORITHM = ZSTD),
     CHECKSUM,
     STATS = 10;
GO

-- ZSTD level karşılaştırma (1: hızlı, 22: en sıkı — default 1)
BACKUP DATABASE demo
TO DISK = N'C:\Backup\demo_zstd_l3.bak'
WITH FORMAT, INIT,
     COMPRESSION (ALGORITHM = ZSTD, LEVEL = 3),
     CHECKSUM,
     STATS = 10;
GO

-- Backup boyutlarını karşılaştır
EXEC xp_cmdshell 'dir C:\Backup\*.bak';
GO

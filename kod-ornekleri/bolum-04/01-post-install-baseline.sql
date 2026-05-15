-- ============================================================================
-- 01-post-install-baseline.sql
-- ----------------------------------------------------------------------------
-- SQL Server 2025 kurulumundan sonra mutlaka uygulanacak baseline ayarlar.
-- Production'da bu script'i çalıştırmadan instance'ı kullanıma alma.
-- ============================================================================

USE master;
GO

-- 1) Advanced options aç
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

-- 2) Max server memory (toplam RAM'in %75-90'ı, OS için en az 4 GB bırak)
-- Örnek: 32 GB RAM olan makine için 28 GB
EXEC sp_configure 'max server memory (MB)', 28672;
RECONFIGURE;
GO

-- 3) MAXDOP: CPU başına 1, max 8 (Microsoft önerisi)
-- 8 CPU veya altı: CPU sayısı kadar
-- 9+ CPU: 8
DECLARE @cpu_count INT = (SELECT cpu_count FROM sys.dm_os_sys_info);
DECLARE @maxdop INT = CASE WHEN @cpu_count <= 8 THEN @cpu_count ELSE 8 END;
EXEC sp_configure 'max degree of parallelism', @maxdop;
RECONFIGURE;
GO

-- 4) Cost threshold for parallelism: default 5 çok düşük; 50 öneri
EXEC sp_configure 'cost threshold for parallelism', 50;
RECONFIGURE;
GO

-- 5) Optimize for ad hoc workloads: ON
EXEC sp_configure 'optimize for ad hoc workloads', 1;
RECONFIGURE;
GO

-- 6) Backup compression default: ON (2025'te ZSTD destekli)
EXEC sp_configure 'backup compression default', 1;
RECONFIGURE;
GO

PRINT 'Baseline ayarları uygulandı.';
GO

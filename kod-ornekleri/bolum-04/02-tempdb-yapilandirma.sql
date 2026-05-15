-- ============================================================================
-- 02-tempdb-yapilandirma.sql
-- ----------------------------------------------------------------------------
-- tempdb yapılandırma kontrolü. 2025 ile birlikte memory-optimized tempdb
-- metadata default ON; ADR in tempdb yeni özellik.
-- ============================================================================

-- Mevcut tempdb dosyaları
SELECT
    name,
    physical_name,
    size * 8 / 1024.0 AS size_mb,
    CASE WHEN is_percent_growth = 1
         THEN CAST(growth AS NVARCHAR(20)) + N' %'
         ELSE CAST(growth * 8 / 1024.0 AS NVARCHAR(20)) + N' MB'
    END AS growth,
    type_desc
FROM tempdb.sys.database_files;
GO

-- 8 CPU'lu bir sistem için tipik öneri: 8 data file, eşit boyut
-- Örnek (yolları kendi sisteminize göre düzenleyin):
/*
ALTER DATABASE tempdb MODIFY FILE (NAME = tempdev,  SIZE = 1024MB, FILEGROWTH = 256MB);
ALTER DATABASE tempdb ADD FILE     (NAME = tempdev2, FILENAME = N'D:\tempdb\tempdev2.ndf', SIZE = 1024MB, FILEGROWTH = 256MB);
-- ... 8'e kadar
*/

-- Memory-optimized tempdb metadata (2025'te default ON ama doğrula)
SELECT
    name,
    value,
    description
FROM sys.configurations
WHERE name LIKE N'%tempdb%metadata%';
GO

-- ADR in tempdb (2025 yeni)
SELECT
    name AS db_name,
    is_accelerated_database_recovery_on,
    target_recovery_time_in_seconds
FROM sys.databases
WHERE database_id = 2;
GO

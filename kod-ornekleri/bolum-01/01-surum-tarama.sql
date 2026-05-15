-- ============================================================================
-- 01-surum-tarama.sql
-- ----------------------------------------------------------------------------
-- Çalıştığınız SQL Server'ın tam kimliğini ortaya çıkarır.
-- Tarihsel bağlama yerleştirmek için kitap Bölüm 1'in açılışı.
-- ============================================================================

-- Tam sürüm bilgisi
SELECT
    SERVERPROPERTY('ProductVersion')      AS product_version,
    SERVERPROPERTY('ProductLevel')        AS product_level,
    SERVERPROPERTY('ProductUpdateLevel')  AS cu_level,
    SERVERPROPERTY('ProductUpdateReference') AS cu_kb,
    SERVERPROPERTY('Edition')             AS edition,
    SERVERPROPERTY('EngineEdition')       AS engine_edition,
    SERVERPROPERTY('IsAdvancedAnalyticsInstalled') AS has_ml_services,
    @@VERSION                             AS full_banner;

-- Build numarası ile sürüm haritası
-- 17.x = SQL Server 2025
-- 16.x = SQL Server 2022
-- 15.x = SQL Server 2019
-- 14.x = SQL Server 2017
-- 13.x = SQL Server 2016
-- 12.x = SQL Server 2014
-- 11.x = SQL Server 2012
-- 10.x = SQL Server 2008
--  9.x = SQL Server 2005
--  8.x = SQL Server 2000

-- Compatibility level (bu veritabanı için)
SELECT name, compatibility_level
FROM sys.databases
WHERE database_id > 4;

-- Etkin trace flag'ler
DBCC TRACESTATUS(-1) WITH NO_INFOMSGS;

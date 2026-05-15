-- ============================================================================
-- 01-edition-ozellikleri.sql
-- ----------------------------------------------------------------------------
-- Edition kimliği, CPU/RAM limitleri, instance konfigürasyonu.
-- ============================================================================

SELECT
    SERVERPROPERTY('Edition')         AS edition,
    SERVERPROPERTY('EngineEdition')   AS engine_edition,
    SERVERPROPERTY('ProductLevel')    AS product_level,
    SERVERPROPERTY('ProductVersion')  AS version,
    SERVERPROPERTY('LicenseType')     AS license_type,
    SERVERPROPERTY('NumLicenses')     AS num_licenses;
GO

-- CPU / scheduler bilgisi
SELECT
    cpu_count,
    hyperthread_ratio,
    physical_memory_kb / 1024.0 / 1024.0 AS physical_memory_gb,
    committed_target_kb / 1024.0 / 1024.0 AS sql_max_memory_gb,
    sqlserver_start_time
FROM sys.dm_os_sys_info;
GO

-- Memory ve max degree of parallelism
SELECT name, value, value_in_use
FROM sys.configurations
WHERE name IN ('max server memory (MB)', 'min server memory (MB)',
               'max degree of parallelism', 'cost threshold for parallelism');
GO

-- Edition-bazlı limitler için Microsoft Learn:
-- https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2025

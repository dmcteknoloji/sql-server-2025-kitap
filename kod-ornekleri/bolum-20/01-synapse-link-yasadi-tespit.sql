-- ============================================================================
-- 01-synapse-link-yasadi-tespit.sql
-- ----------------------------------------------------------------------------
-- Bu instance'da Synapse Link kullanılıyor mu? Eski SQL Server'lardan
-- 2025'e upgrade öncesi tespit.
-- ============================================================================

-- 2022'de Synapse Link özellikleri (2025'te yok)
SELECT
    DB_NAME(database_id) AS db_name,
    is_link_to_synapse_enabled
FROM sys.databases
WHERE is_link_to_synapse_enabled = 1;
GO

-- Eğer 2022'den 2025'e upgrade yapıyorsanız ve Synapse Link aktifse:
-- 1) Yeni 2025'e taşımadan önce Fabric Mirroring'i kurun
-- 2) Synapse Workspaces'i Fabric'e taşıyın (Microsoft önerisi)
-- 3) Eski Synapse Link'i devre dışı bırakın:
--    ALTER DATABASE [db] DROP LINK CONNECTION TO ... (2022 sözdizimi)

-- Microsoft Learn — "Discontinued Database Engine Functionality in SQL Server 2025":
-- https://learn.microsoft.com/en-us/sql/database-engine/discontinued-database-engine-functionality-in-sql-server

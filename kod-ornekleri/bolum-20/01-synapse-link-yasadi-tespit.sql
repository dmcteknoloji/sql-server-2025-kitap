-- ============================================================================
-- 01-synapse-link-yasadi-tespit.sql
-- ----------------------------------------------------------------------------
-- Bu instance'da Synapse Link kullanılıyor mu? Eski SQL Server'lardan
-- 2025'e upgrade öncesi tespit.
-- ============================================================================

-- 2022'de Synapse Link durumu sys.databases.is_link_to_synapse_enabled ile okunurdu.
-- 2025'te özellik kaldırıldığı için SÜTUN DA YOKTUR; aşağıdaki sorgu
-- SQL Server 2025'te Msg 207 (Invalid column name) verir:
--
--   SELECT DB_NAME(database_id), is_link_to_synapse_enabled
--   FROM sys.databases WHERE is_link_to_synapse_enabled = 1;
--
-- Sürümden bağımsız çalışan tespit yöntemi: sütun var mı diye bak.
IF EXISTS (SELECT 1 FROM sys.all_columns
           WHERE object_id = OBJECT_ID('sys.databases')
             AND name = 'is_link_to_synapse_enabled')
    PRINT 'Synapse Link sütunu mevcut — bu instance 2022 veya öncesi.';
ELSE
    PRINT 'Synapse Link sütunu yok — bu instance 2025+. Göç hedefi: Fabric Mirroring (Bölüm 18).';
GO

-- Eğer 2022'den 2025'e upgrade yapıyorsanız ve Synapse Link aktifse:
-- 1) Yeni 2025'e taşımadan önce Fabric Mirroring'i kurun
-- 2) Synapse Workspaces'i Fabric'e taşıyın (Microsoft önerisi)
-- 3) Eski Synapse Link'i devre dışı bırakın:
--    ALTER DATABASE [db] DROP LINK CONNECTION TO ... (2022 sözdizimi)

-- Microsoft Learn — "Discontinued Database Engine Functionality in SQL Server 2025":
-- https://learn.microsoft.com/en-us/sql/database-engine/discontinued-database-engine-functionality-in-sql-server

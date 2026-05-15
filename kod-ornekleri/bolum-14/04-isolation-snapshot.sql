-- ============================================================================
-- 04-isolation-snapshot.sql
-- ----------------------------------------------------------------------------
-- RCSI ve SNAPSHOT isolation; reader-writer blocking azaltma.
-- ============================================================================

USE demo;
GO

-- Mevcut durumu kontrol et
SELECT
    name,
    is_read_committed_snapshot_on,   -- RCSI
    snapshot_isolation_state_desc    -- SNAPSHOT isolation aktif mi?
FROM sys.databases
WHERE name = N'demo';
GO

-- RCSI aç (demo'da zaten açık; production'da bilinçli ayar)
ALTER DATABASE demo SET ALLOW_SNAPSHOT_ISOLATION ON;
ALTER DATABASE demo SET READ_COMMITTED_SNAPSHOT ON;
GO

-- Pratik fark gösterimi:
-- Oturum A:
BEGIN TRAN;
UPDATE sales.orders SET status = N'updated' WHERE order_id = 1;
-- COMMIT yapmadan bekle

-- Oturum B (ayrı pencerede):
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- RCSI varsa snapshot davranır
-- SELECT order_id, status FROM sales.orders WHERE order_id = 1;
-- Sonuç: önceki committed değer; bloklamadı

-- veya açıkça SNAPSHOT:
-- SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
-- BEGIN TRAN;
-- SELECT order_id, status FROM sales.orders WHERE order_id = 1;
-- COMMIT;

-- A'yı bitir
-- ROLLBACK;
GO

-- Tempdb version store (RCSI/SNAPSHOT'ın bedeli)
-- dm_db_file_space_usage doğru sütunlar: *_page_count (her sayfa 8 KB)
SELECT
    total_page_count * 8 / 1024.0 AS total_mb,
    allocated_extent_page_count * 8 / 1024.0 AS allocated_mb,
    version_store_reserved_page_count * 8 / 1024.0 AS version_store_mb,
    unallocated_extent_page_count * 8 / 1024.0 AS unallocated_mb
FROM tempdb.sys.dm_db_file_space_usage;
GO

SELECT * FROM tempdb.sys.dm_tran_version_store_space_usage;
GO

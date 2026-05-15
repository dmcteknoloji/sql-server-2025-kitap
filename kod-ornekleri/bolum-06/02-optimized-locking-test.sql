-- ============================================================================
-- 02-optimized-locking-test.sql
-- ----------------------------------------------------------------------------
-- 2025'in Optimized Locking özelliği. Önkoşul: ADR + RCSI aktif (demo'da var).
-- İki oturumda paralel olarak çalıştırın; blocking azalmasını gözlemleyin.
-- ============================================================================

USE demo;
GO

-- Optimized Locking durumu kontrolü
SELECT name, is_accelerated_database_recovery_on, is_read_committed_snapshot_on
FROM sys.databases
WHERE name = N'demo';
GO

-- Senaryo: aynı tablonun farklı satırlarına paralel UPDATE
-- Oturum A:
BEGIN TRAN;
UPDATE sales.orders SET status = N'shipped' WHERE order_id = 1;
-- COMMIT etmeden bekle (Oturum B'yi başlat)

-- Oturum B (ayrı pencerede):
-- BEGIN TRAN;
-- UPDATE sales.orders SET status = N'shipped' WHERE order_id = 2;
-- COMMIT;

-- Optimized Locking ile Oturum B engellenmez (TID-based locking + LAQ)
-- Eski klasik locking'de aynı page'deki satır olsaydı engellenirdi

-- A'yı bitir
-- COMMIT;
GO

-- Aktif lock'ları izle
SELECT
    request_session_id,
    resource_type,
    resource_description,
    request_mode,
    request_status,
    -- resource_associated_entity_id BIGINT; OBJECT_NAME INT bekler.
    -- Sadece OBJECT lock'larda anlamlıdır; diğerlerinde NULL.
    CASE WHEN resource_type = 'OBJECT'
         THEN OBJECT_NAME(CAST(resource_associated_entity_id AS INT))
         ELSE NULL END AS object_name
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID()
ORDER BY request_session_id;
GO

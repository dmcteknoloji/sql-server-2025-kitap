-- ============================================================================
-- 03-trace-flags.sql
-- ----------------------------------------------------------------------------
-- 2025'te artık default davranış olan eski trace flag'ler ve hâlâ bilinmesi
-- gerekenler.
-- ============================================================================

-- Aktif trace flag'leri listele
DBCC TRACESTATUS(-1) WITH NO_INFOMSGS;
GO

-- 2025'te default olan ve artık manuel açılmasına gerek olmayan TF'ler:
--   1117 (tüm filegroup dosyaları beraber büyür) — default ON
--   1118 (mixed extents off) — default ON
--   2371 (auto-update stats threshold) — default ON
--   3604 (printable DBCC output) — debug için gerektiğinde
--   8048 (NUMA node partitioning) — büyük NUMA için
--   8079 (auto soft NUMA) — büyük NUMA için
--   1224 (lock hash table partitioning) — yüksek concurrency için

-- Modern yaklaşım: trace flag yerine database scoped configuration tercih edilir
SELECT name, value, value_for_secondary
FROM sys.database_scoped_configurations
ORDER BY name;
GO

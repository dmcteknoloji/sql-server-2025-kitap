-- ============================================================================
-- 04-segment-elimination.sql
-- ----------------------------------------------------------------------------
-- Columnstore segment metadata + elimination doğrulama.
-- ============================================================================

USE demo;
GO

-- Segment'ler ve min/max değerleri
-- sys.column_store_segments DMV'sinde object_id yoktur; partition üzerinden gelir
SELECT
    OBJECT_NAME(p.object_id) AS table_name,
    p.partition_number,
    c.name AS column_name,
    s.segment_id,
    s.min_data_id,
    s.max_data_id,
    s.row_count
FROM sys.column_store_segments s
JOIN sys.partitions p ON p.partition_id = s.partition_id
JOIN sys.columns c ON c.object_id = p.object_id AND c.column_id = s.column_id + 1
WHERE p.object_id IN (
    OBJECT_ID('sales.orders'),  -- NCCI varsa
    OBJECT_ID('sales.order_items')
)
ORDER BY p.partition_number, s.segment_id, s.column_id;
GO

-- Row group quality
SELECT
    OBJECT_NAME(object_id) AS table_name,
    row_group_id,
    state_desc,
    total_rows,
    deleted_rows,
    size_in_bytes / 1024.0 / 1024.0 AS size_mb
FROM sys.dm_db_column_store_row_group_physical_stats
WHERE OBJECT_NAME(object_id) = N'fact_sales'
ORDER BY row_group_id;
GO

-- Segment elimination: tarih aralığı filtrede min/max ile eşleşmeyen segment'ler skip
SELECT COUNT(*)
FROM sales.fact_sales
WHERE sale_date BETWEEN '2025-06-01' AND '2025-06-30';

-- Plan'da "Actual Logical Reads" düşükse segment elimination çalışıyor
-- SET STATISTICS IO ON;

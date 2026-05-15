-- ============================================================================
-- 01-vector-tipi-temel.sql
-- ----------------------------------------------------------------------------
-- VECTOR(N) tipi: insert, parse, görüntüleme.
-- ============================================================================

USE demo;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO

-- 1) Basit deklerasyon
DECLARE @v VECTOR(3) = '[1.0, 2.0, 3.0]';
SELECT @v AS vec;
GO

-- 2) JSON'dan VECTOR'e cast
DECLARE @json NVARCHAR(MAX) = N'[0.123, -0.456, 0.789]';
DECLARE @v VECTOR(3) = CAST(@json AS VECTOR(3));
SELECT @v AS vec_from_json;
GO

-- 3) VECTOR sütun (ai.document_chunks demo'da hazır — 1536 boyut)
INSERT INTO ai.document_chunks (source_doc, chunk_index, content, embedding)
VALUES (
    N'demo.pdf',
    1,
    N'SQL Server 2025 native vector arama desteğiyle gelir.',
    NULL  -- gerçek embedding Bölüm 22'de üretilecek
);
GO

-- 4) Boyut uyuşmazlığı hatası gözlemleme
BEGIN TRY
    DECLARE @w VECTOR(5) = '[1.0, 2.0, 3.0]';  -- 3 değer ama 5 boyut deklare; hata
END TRY
BEGIN CATCH
    PRINT N'Boyut hatası bekleniyordu: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 5) NULL handling
INSERT INTO ai.document_chunks (source_doc, chunk_index, content, embedding)
VALUES (N'doc2', 1, N'Embedding henüz üretilmemiş', NULL);

SELECT chunk_id, content, embedding
FROM ai.document_chunks
ORDER BY chunk_id DESC;
GO

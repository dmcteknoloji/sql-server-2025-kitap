-- ============================================================================
-- 02-chunking-embedding.sql
-- ----------------------------------------------------------------------------
-- Doküman içeriğini chunk'lara ayır + her chunk için embedding üret.
-- AI_GENERATE_CHUNKS + AI_GENERATE_EMBEDDINGS T-SQL'in içinde.
-- ============================================================================

USE demo;
GO

-- AI_GENERATE_CHUNKS: T-SQL içinde text chunking
-- Microsoft Learn: text-chunking-transact-sql

DECLARE @doc_id BIGINT = (SELECT TOP(1) doc_id FROM ai.documents);
DECLARE @content NVARCHAR(MAX) = (SELECT content FROM ai.documents WHERE doc_id = @doc_id);

-- Chunk üret (500 token, 50 overlap; recursive chunker)
INSERT INTO ai.chunks (doc_id, chunk_index, content, token_count)
SELECT @doc_id,
       chunk_order,
       chunk,
       LEN(chunk) / 4  -- yaklaşık token (1 token ~ 4 char İngilizce, ~3 char Türkçe)
FROM AI_GENERATE_CHUNKS(
    SOURCE = @content,
    CHUNK_TYPE = N'FIXED',
    CHUNK_SIZE = 500,
    OVERLAP = 50
);
GO

-- Embedding üret (toplu — her chunk için)
-- Önkoşul: CREATE EXTERNAL MODEL Ada2Embeddings (Bölüm 22)
-- Burada placeholder: model yokken NULL kalır, hata vermez
UPDATE ai.chunks
SET embedding = AI_GENERATE_EMBEDDINGS(content USE MODEL Ada2Embeddings)
WHERE embedding IS NULL
  AND doc_id IN (SELECT doc_id FROM ai.documents);
GO

-- Doğrulama
SELECT
    c.doc_id,
    c.chunk_index,
    LEFT(c.content, 60) AS preview,
    c.token_count,
    CASE WHEN c.embedding IS NULL THEN 'PENDING' ELSE 'EMBEDDED' END AS status
FROM ai.chunks c
ORDER BY c.doc_id, c.chunk_index;
GO

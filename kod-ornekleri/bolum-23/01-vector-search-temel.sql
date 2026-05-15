-- ============================================================================
-- 01-vector-search-temel.sql
-- ----------------------------------------------------------------------------
-- VECTOR_SEARCH — DiskANN graph üzerinden approximate kNN.
-- ============================================================================

USE demo;
GO

-- Önkoşul: ai.document_chunks'ta embedding dolu + vector index var

-- 1) Basit kNN: en yakın 10 chunk
DECLARE @query_emb VECTOR(1536) = AI_GENERATE_EMBEDDINGS(
    N'SQL Server vector arama nasıl çalışır?'
    USE MODEL aoai_embed_small
);

-- Yeni vector index sözdizimi (version 3+): TOP_N parametresi DEPRECATED.
-- Hata Msg 42274: "Vector search with version 3 index does not support
-- explicit TOP_N parameter" — TOP_N yerine SELECT TOP (N) WITH APPROXIMATE.
SELECT TOP (10) WITH APPROXIMATE
    chunk_id,
    content,
    distance
FROM VECTOR_SEARCH(
    TABLE = ai.document_chunks,
    COLUMN = embedding,
    SIMILAR_TO = @query_emb,
    METRIC = 'cosine'
) AS s
ORDER BY distance ASC;
GO

-- 2) JOIN ile orijinal tablo
DECLARE @q VECTOR(1536) = AI_GENERATE_EMBEDDINGS(
    N'optimized locking nedir?' USE MODEL aoai_embed_small
);

SELECT TOP (5) WITH APPROXIMATE
    c.chunk_id,
    c.source_doc,
    LEFT(c.content, 150) AS preview,
    s.distance
FROM VECTOR_SEARCH(
    TABLE = ai.document_chunks,
    COLUMN = embedding,
    SIMILAR_TO = @q,
    METRIC = 'cosine'
) AS s
JOIN ai.document_chunks c ON c.chunk_id = s.chunk_id
ORDER BY s.distance ASC;
GO

-- 3) Filtre + vector search
DECLARE @q2 VECTOR(1536) = AI_GENERATE_EMBEDDINGS(
    N'klavye' USE MODEL aoai_embed_small
);

SELECT TOP (5) WITH APPROXIMATE
    c.chunk_id,
    c.content,
    s.distance
FROM VECTOR_SEARCH(
    TABLE = ai.document_chunks,
    COLUMN = embedding,
    SIMILAR_TO = @q2,
    METRIC = 'cosine'
) AS s
JOIN ai.document_chunks c ON c.chunk_id = s.chunk_id
WHERE c.source_doc = N'product-catalog'   -- post-filter
ORDER BY s.distance;
GO

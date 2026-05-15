-- ============================================================================
-- 03-hybrid-rrf.sql
-- ----------------------------------------------------------------------------
-- Reciprocal Rank Fusion (Cormack 2009): vector + BM25 sıralamasını birleştir.
-- ============================================================================

USE demo;
GO

CREATE OR ALTER PROCEDURE ai.usp_hybrid_search
    @query NVARCHAR(MAX),
    @top_k INT = 10,
    @rrf_k INT = 60       -- standard RRF k (60); 1-100 arası
AS
BEGIN
    SET NOCOUNT ON;

    -- Query embedding'i bir kere üret
    DECLARE @q_emb VECTOR(1536) = AI_GENERATE_EMBEDDINGS(@query USE MODEL aoai_embed_small);

    -- CTE'den önce ; ayırıcı zorunlu (DECLARE veya başka statement sonrası)
    ;WITH vector_results AS (
        SELECT TOP (50) WITH APPROXIMATE
            c.chunk_id,
            ROW_NUMBER() OVER (ORDER BY s.distance ASC) AS rnk
        FROM VECTOR_SEARCH(
            TABLE = ai.document_chunks,
            COLUMN = embedding,
            SIMILAR_TO = @q_emb,
            METRIC = 'cosine'
        ) AS s
        JOIN ai.document_chunks c ON c.chunk_id = s.chunk_id
    ),

    -- 2) BM25 (CONTAINSTABLE)
    bm25_results AS (
        SELECT TOP (50)
            ft.[KEY] AS chunk_id,
            ROW_NUMBER() OVER (ORDER BY ft.RANK DESC) AS rnk
        FROM CONTAINSTABLE(ai.document_chunks, content, @query, 50) AS ft
    ),

    -- 3) RRF birleşim: skor = 1/(k + rank)
    fused AS (
        SELECT chunk_id, 1.0 / (@rrf_k + rnk) AS rrf_score FROM vector_results
        UNION ALL
        SELECT chunk_id, 1.0 / (@rrf_k + rnk) FROM bm25_results
    ),

    ranked AS (
        SELECT
            chunk_id,
            SUM(rrf_score) AS combined_score
        FROM fused
        GROUP BY chunk_id
    )

    SELECT TOP (@top_k)
        c.chunk_id,
        c.source_doc,
        LEFT(c.content, 250) AS preview,
        r.combined_score
    FROM ranked r
    JOIN ai.document_chunks c ON c.chunk_id = r.chunk_id
    ORDER BY r.combined_score DESC;
END;
GO

-- Test
EXEC ai.usp_hybrid_search @query = N'vector index nedir', @top_k = 5;
GO

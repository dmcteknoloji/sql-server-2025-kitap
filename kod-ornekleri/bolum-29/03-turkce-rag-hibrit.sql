-- ============================================================================
-- 03-turkce-rag-hibrit.sql
-- ----------------------------------------------------------------------------
-- Türkçe için hybrid search: BGE-M3 vector + Türkçe Full-Text BM25.
-- Reciprocal Rank Fusion (RRF) ile birleşim.
-- ============================================================================

USE demo;
GO

DECLARE @sorgu NVARCHAR(MAX) = N'kurumsal sözleşme yenileme şartları';
DECLARE @sorgu_vec VECTOR(1024);
DECLARE @top_k INT = 20;

-- 1) Sorguyu embed et (BGE-M3 - 1024 boyut)
SET @sorgu_vec = AI_GENERATE_EMBEDDINGS(@sorgu USE MODEL TurkceEmbeddingsAzureML);

-- 2) Vector search
WITH vec_results AS (
    SELECT TOP(@top_k)
        b.belge_id,
        VECTOR_DISTANCE('cosine', b.embedding, @sorgu_vec) AS distance,
        ROW_NUMBER() OVER (ORDER BY VECTOR_DISTANCE('cosine', b.embedding, @sorgu_vec)) AS vec_rank
    FROM ai.belgeler b
    WHERE b.embedding IS NOT NULL
    ORDER BY distance
),
-- 3) Full-text BM25 search
ft_results AS (
    SELECT TOP(@top_k)
        b.belge_id,
        ft.RANK AS bm25_rank,
        ROW_NUMBER() OVER (ORDER BY ft.RANK DESC) AS ft_rank
    FROM ai.belgeler b
    INNER JOIN CONTAINSTABLE(ai.belgeler, icerik, @sorgu, @top_k) ft
        ON b.belge_id = ft.[KEY]
),
-- 4) Reciprocal Rank Fusion (k=60 standart)
fused AS (
    SELECT
        COALESCE(v.belge_id, f.belge_id) AS belge_id,
        ISNULL(1.0 / (60 + v.vec_rank), 0) + ISNULL(1.0 / (60 + f.ft_rank), 0) AS rrf_score
    FROM vec_results v
    FULL OUTER JOIN ft_results f ON v.belge_id = f.belge_id
)
-- 5) Sıralı sonuç
SELECT TOP(10)
    b.belge_id,
    b.baslik,
    LEFT(b.icerik, 100) AS onizleme,
    fused.rrf_score
FROM fused
INNER JOIN ai.belgeler b ON b.belge_id = fused.belge_id
ORDER BY fused.rrf_score DESC;
GO

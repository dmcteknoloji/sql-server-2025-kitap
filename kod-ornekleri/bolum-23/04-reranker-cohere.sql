-- ============================================================================
-- 04-reranker-cohere.sql
-- ----------------------------------------------------------------------------
-- Hybrid arama sonuçlarını Cohere Rerank API ile yeniden sırala.
-- Cross-encoder yaklaşımı; recall iyi, ama precision'ı artırır.
-- ============================================================================

USE demo;
GO

-- Cohere credential
IF NOT EXISTS (SELECT 1 FROM sys.database_scoped_credentials WHERE name = N'https://api.cohere.ai')
CREATE DATABASE SCOPED CREDENTIAL [https://api.cohere.ai]
    WITH IDENTITY = 'HTTPEndpointHeaders',
         SECRET = '{"Authorization":"Bearer <your-cohere-key>"}';
GO

CREATE OR ALTER PROCEDURE ai.usp_rerank
    @query NVARCHAR(MAX),
    @hybrid_results NVARCHAR(MAX),   -- JSON array of {chunk_id, content}
    @top_k INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    -- Cohere Rerank payload
    DECLARE @payload NVARCHAR(MAX) = JSON_OBJECT(
        'model': 'rerank-multilingual-v3.0',
        'query': @query,
        'documents': @hybrid_results,
        'top_n': @top_k,
        'return_documents': true
    );

    DECLARE @response NVARCHAR(MAX);
    DECLARE @ret INT;

    EXEC @ret = sp_invoke_external_rest_endpoint
        @url = N'https://api.cohere.ai/v1/rerank',
        @method = N'POST',
        @payload = @payload,
        @credential = [https://api.cohere.ai],
        @headers = N'{"Content-Type":"application/json"}',
        @timeout = 30,
        @response = @response OUTPUT;

    -- Sonuç JSON: {"results": [{"index": 3, "relevance_score": 0.95, "document": {...}}]}
    SELECT
        JSON_VALUE(r.value, '$.index') AS original_idx,
        JSON_VALUE(r.value, '$.relevance_score') AS rerank_score,
        JSON_VALUE(r.value, '$.document.text') AS reranked_content
    FROM OPENJSON(@response, '$.result.results') AS r
    ORDER BY CAST(JSON_VALUE(r.value, '$.relevance_score') AS FLOAT) DESC;
END;
GO

-- Bi-encoder (vector + BM25 + RRF) → Cross-encoder (rerank) pipeline
-- Precision@5'i tipik %20-40 artırır

-- ============================================================================
-- 03-retrieval-llm.sql
-- ----------------------------------------------------------------------------
-- Retrieval + LLM çağrısı. Bir kullanıcı sorusu için:
--   1) Soruyu embed et
--   2) En yakın N chunk'ı bul (VECTOR_SEARCH)
--   3) LLM'e gönder (sp_invoke_external_rest_endpoint)
--   4) Yanıtı + audit'i logla
-- ============================================================================

USE demo;
GO

DECLARE @query NVARCHAR(MAX) = N'SQL Server 2025 vector aramayı nasıl yapar?';
DECLARE @query_vec VECTOR(1536);
DECLARE @top_k INT = 5;
DECLARE @context NVARCHAR(MAX) = N'';
DECLARE @start_time DATETIME2 = SYSUTCDATETIME();

-- 1) Sorgu embedding'i
SET @query_vec = AI_GENERATE_EMBEDDINGS(@query USE MODEL Ada2Embeddings);

-- 2) En yakın N chunk (VECTOR_SEARCH — APPROXIMATE DiskANN)
DECLARE @top_chunks TABLE (rn INT, chunk_id INT, content NVARCHAR(MAX), distance FLOAT);

INSERT INTO @top_chunks
SELECT TOP(@top_k)
    ROW_NUMBER() OVER (ORDER BY VECTOR_DISTANCE('cosine', c.embedding, @query_vec)) AS rn,
    c.chunk_id,
    c.content,
    VECTOR_DISTANCE('cosine', c.embedding, @query_vec) AS distance
FROM ai.chunks c
WHERE c.embedding IS NOT NULL
ORDER BY distance;

-- 3) Context'i derle (chunk içeriklerini birleştir)
SELECT @context = @context + N'[chunk ' + CAST(chunk_id AS NVARCHAR(20)) + N']: ' + content + NCHAR(10) + NCHAR(10)
FROM @top_chunks
ORDER BY rn;

-- 4) LLM çağrısı (sp_invoke_external_rest_endpoint)
DECLARE @payload NVARCHAR(MAX) =
    N'{"messages":[' +
    N'{"role":"system","content":"Yalnızca verilen bağlamı kullanarak Türkçe yanıt ver. Bağlamda yoksa \"bilgi yok\" de."},' +
    N'{"role":"user","content":"Bağlam:\n' + STRING_ESCAPE(@context,'json') +
    N'\n\nSoru: ' + STRING_ESCAPE(@query,'json') + N'"}],' +
    N'"max_tokens":500,"temperature":0.2}';

DECLARE @response NVARCHAR(MAX), @ret INT;

-- Production'da: credential ile çağrı
-- EXEC @ret = sp_invoke_external_rest_endpoint
--     @url = N'https://my-azure-openai-endpoint.cognitiveservices.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-02-01',
--     @method = 'POST',
--     @payload = @payload,
--     @credential = [https://my-azure-openai-endpoint.cognitiveservices.azure.com/],
--     @response = @response OUTPUT;

-- Demo modu: placeholder yanıt
SET @response = N'{"choices":[{"message":{"content":"SQL Server 2025 vector aramayı VECTOR_SEARCH fonksiyonu + DiskANN indeksi ile yapar."}}]}';

-- 5) Audit logu
INSERT INTO ai.query_log (query_text, query_embedding, top_k, used_chunks, llm_response, latency_ms)
SELECT @query, @query_vec, @top_k,
       (SELECT chunk_id FROM @top_chunks ORDER BY rn FOR JSON PATH),
       @response,
       DATEDIFF(MILLISECOND, @start_time, SYSUTCDATETIME());

-- Sonuç
SELECT
    JSON_VALUE(@response, '$.choices[0].message.content') AS answer,
    (SELECT chunk_id, distance FROM @top_chunks ORDER BY rn FOR JSON PATH) AS used_chunks;
GO

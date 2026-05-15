-- ============================================================================
-- 04-openai-api-cagri.sql
-- ----------------------------------------------------------------------------
-- Azure OpenAI'a direkt REST çağrısı (T-SQL içinden).
-- Bölüm 22'de AI_GENERATE_EMBEDDINGS ile aynı işi daha kısa yapacağız;
-- burası "altta ne oluyor" bilgisi için.
-- ============================================================================

USE demo;
GO

DECLARE @input NVARCHAR(MAX) = N'SQL Server 2025 vector arama desteği';

DECLARE @payload NVARCHAR(MAX) =
    JSON_OBJECT(
        'input': @input,
        'model': 'text-embedding-3-small'
    );

DECLARE @response NVARCHAR(MAX);

EXEC sp_invoke_external_rest_endpoint
    @url = N'https://your-aoai.openai.azure.com/openai/deployments/text-embedding-3-small/embeddings?api-version=2024-06-01',
    @method = N'POST',
    @credential = [https://your-aoai.openai.azure.com],
    @payload = @payload,
    @headers = N'{"Content-Type":"application/json"}',
    @timeout = 30,
    @response = @response OUTPUT;

-- Response yapısı:
-- { "data": [{"embedding": [0.123, -0.456, ...], "index": 0}], "model": "...", "usage": {...} }

SELECT
    JSON_QUERY(@response, '$.result.data[0].embedding') AS embedding_array,
    JSON_VALUE(@response, '$.result.usage.total_tokens') AS tokens_used;
GO

-- Bu embedding'i VECTOR tipine cast etmek için:
-- DECLARE @v VECTOR(1536) = CAST(JSON_QUERY(@response, '$.result.data[0].embedding') AS VECTOR(1536));
-- (Bölüm 22'de detay)

-- ============================================================================
-- 05-retry-timeout.sql
-- ----------------------------------------------------------------------------
-- sp_invoke_external_rest_endpoint timeout, retry_count, hata yönetimi.
-- ============================================================================

USE demo;
GO

-- @timeout: 1-230 saniye, default 30
-- @retry_count: 0-10, default 0 (5xx ve network hatalarında otomatik retry)

DECLARE @response NVARCHAR(MAX);
DECLARE @ret INT;

BEGIN TRY
    EXEC @ret = sp_invoke_external_rest_endpoint
        @url = N'https://api.example.com/endpoint',
        @method = N'POST',
        @payload = N'{"data":"test"}',
        @timeout = 60,
        @retry_count = 3,
        @retry_intervals = N'[1, 2, 4]',   -- 1s, 2s, 4s exponential backoff
        @response = @response OUTPUT;

    -- @ret:
    --   0   = 2xx (success)
    --   400-499 = client error (retry yok)
    --   500-599 = server error (retry edildi, hâlâ başarısız)
    --   1   = network/timeout

    IF @ret = 0
        PRINT N'Başarılı: ' + LEFT(@response, 200);
    ELSE
        PRINT N'HTTP class: ' + CAST(@ret AS NVARCHAR(10));
END TRY
BEGIN CATCH
    PRINT N'Çağrı hatası: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Best practice: REST çağrılarını transactional context dışında yap
-- Aksi takdirde dış API beklerken DB transaction açık kalır.

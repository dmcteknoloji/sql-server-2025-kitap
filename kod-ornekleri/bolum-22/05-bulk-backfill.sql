-- ============================================================================
-- 05-bulk-backfill.sql
-- ----------------------------------------------------------------------------
-- Mevcut milyonlarca satıra embedding üretimi — batch'li yaklaşım.
-- ============================================================================

USE demo;
GO

-- Naif yöntem: tüm tabloyu tek SELECT/UPDATE
-- Sorun: tek transaction çok uzun; AOAI rate limit; transaction log büyür
-- Çözüm: batch'li

DECLARE @batch_size INT = 200;          -- AOAI rate limit + tx süresi için ayarla
DECLARE @processed INT = 0;
DECLARE @total INT = (SELECT COUNT(*) FROM ai.document_chunks WHERE embedding IS NULL);

WHILE @processed < @total
BEGIN
    BEGIN TRY
        UPDATE TOP (@batch_size) ai.document_chunks
        SET embedding = AI_GENERATE_EMBEDDINGS(content USE MODEL aoai_embed_small)
        WHERE embedding IS NULL;

        SET @processed += @@ROWCOUNT;

        PRINT N'İlerleme: ' + CAST(@processed AS NVARCHAR(20)) + N' / ' + CAST(@total AS NVARCHAR(20));

        -- Rate limiting için ara ver (AOAI 6000 req/min standard tier)
        WAITFOR DELAY '00:00:01';
    END TRY
    BEGIN CATCH
        PRINT N'Batch hatası: ' + ERROR_MESSAGE();
        WAITFOR DELAY '00:00:30';   -- backoff
    END CATCH
END

PRINT N'Backfill tamamlandı: ' + CAST(@processed AS NVARCHAR(20));
GO

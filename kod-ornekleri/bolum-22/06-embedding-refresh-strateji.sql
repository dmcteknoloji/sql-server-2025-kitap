-- ============================================================================
-- 06-embedding-refresh-strateji.sql
-- ----------------------------------------------------------------------------
-- Embedding tazeleme stratejileri: eager (insert/update sırasında) vs
-- lazy (background job ile).
-- ============================================================================

USE demo;
GO

-- ============================================================================
-- 1) Eager: trigger ile insert/update sırasında embed
-- ============================================================================
CREATE OR ALTER TRIGGER ai.tr_chunks_auto_embed
ON ai.document_chunks
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sadece content değiştiğinde re-embed
    IF NOT UPDATE(content) RETURN;

    UPDATE c
    SET embedding = AI_GENERATE_EMBEDDINGS(i.content USE MODEL aoai_embed_small)
    FROM ai.document_chunks c
    INNER JOIN inserted i ON i.chunk_id = c.chunk_id;
END;
GO

-- Avantaj: her zaman güncel
-- Dezavantaj: insert/update latency artar; AOAI çağrısı tx içinde

-- ============================================================================
-- 2) Lazy: queue table + scheduled job
-- ============================================================================
-- SQL Server'da CREATE TABLE IF NOT EXISTS yok; IF OBJECT_ID kontrolü kullan
IF OBJECT_ID('ai.embedding_queue','U') IS NULL
BEGIN
    CREATE TABLE ai.embedding_queue (
        chunk_id BIGINT NOT NULL PRIMARY KEY REFERENCES ai.document_chunks(chunk_id),
        queued_at DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
        last_attempt DATETIME2(0) NULL,
        attempts INT NOT NULL DEFAULT 0,
        error_message NVARCHAR(1000) NULL
    );
END
GO

-- Trigger: content değişince queue'ya at
CREATE OR ALTER TRIGGER ai.tr_chunks_queue_embed
ON ai.document_chunks
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(content) RETURN;

    MERGE ai.embedding_queue AS q
    USING inserted AS i
        ON q.chunk_id = i.chunk_id
    WHEN MATCHED THEN
        UPDATE SET queued_at = SYSUTCDATETIME(), attempts = 0, last_attempt = NULL
    WHEN NOT MATCHED THEN
        INSERT (chunk_id) VALUES (i.chunk_id);
END;
GO

-- Worker SP: SQL Agent job veya cron ile çağrılır
CREATE OR ALTER PROCEDURE ai.usp_process_embedding_queue
    @batch_size INT = 100
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE TOP (@batch_size) c
    SET c.embedding = AI_GENERATE_EMBEDDINGS(c.content USE MODEL aoai_embed_small)
    OUTPUT INSERTED.chunk_id INTO #processed (chunk_id)
    FROM ai.document_chunks c
    INNER JOIN ai.embedding_queue q ON q.chunk_id = c.chunk_id
    WHERE q.attempts < 5;

    DELETE q
    FROM ai.embedding_queue q
    INNER JOIN #processed p ON p.chunk_id = q.chunk_id;
END;
GO

-- Avantaj: insert latency etkilenmez; rate limit kontrol edilebilir
-- Dezavantaj: kısa süreli stale embedding

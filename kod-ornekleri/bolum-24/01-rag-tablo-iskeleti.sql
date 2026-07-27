-- ============================================================================
-- 01-rag-tablo-iskeleti.sql
-- ----------------------------------------------------------------------------
-- RAG (Retrieval-Augmented Generation) hattı için temel tablo iskeleti.
-- Doküman, chunk, embedding, arama ve LLM yanıtı sırasıyla.
-- ============================================================================

USE demo;
GO

-- 1) Doküman kataloğu (üst seviye)
IF OBJECT_ID('ai.documents','U') IS NULL
BEGIN
    CREATE TABLE ai.documents (
        doc_id       BIGINT       NOT NULL IDENTITY PRIMARY KEY,
        title        NVARCHAR(400) NOT NULL,
        source_url   NVARCHAR(800) NULL,
        content      NVARCHAR(MAX) NOT NULL,
        language     CHAR(2)       NOT NULL DEFAULT 'tr',
        ingested_at  DATETIME2(0)  NOT NULL DEFAULT SYSUTCDATETIME(),
        content_hash AS CONVERT(BINARY(32), HASHBYTES('SHA2_256', content)) PERSISTED
    );
END
GO

-- 2) Chunk tablosu (zaten _ortak/00-demo'da ai.document_chunks var; üzerine doğru iskelet)
IF OBJECT_ID('ai.chunks','U') IS NULL
BEGIN
    CREATE TABLE ai.chunks (
        -- Vector index önkoşulu: clustered PK tek bir 4 baytlık INT sütun
        -- olmalı (Msg 42217). BIGINT kullanılırsa CREATE VECTOR INDEX reddedilir.
        chunk_id     INT          NOT NULL IDENTITY PRIMARY KEY,
        doc_id       BIGINT       NOT NULL REFERENCES ai.documents(doc_id),
        chunk_index  INT          NOT NULL,
        content      NVARCHAR(MAX) NOT NULL,
        token_count  INT          NULL,
        embedding    VECTOR(1536) NULL,
        created_at   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_chunks_doc_idx UNIQUE (doc_id, chunk_index)
    );
END
GO

-- 3) Sorgu logu (audit + iyileştirme için)
IF OBJECT_ID('ai.query_log','U') IS NULL
BEGIN
    CREATE TABLE ai.query_log (
        query_id     BIGINT       NOT NULL IDENTITY PRIMARY KEY,
        query_text   NVARCHAR(MAX) NOT NULL,
        query_embedding VECTOR(1536) NULL,
        top_k        INT          NOT NULL DEFAULT 10,
        used_chunks  NVARCHAR(MAX) NULL,  -- JSON array of chunk_id'ler
        llm_response NVARCHAR(MAX) NULL,
        latency_ms   INT          NULL,
        created_at   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

-- Örnek doküman
INSERT INTO ai.documents (title, source_url, content, language) VALUES
(N'SQL Server 2025 Vector Search', N'https://learn.microsoft.com/.../vectors',
 N'SQL Server 2025 native VECTOR tipi sunar. DiskANN ile yaklaşık en yakın komşu indeksi. AI_GENERATE_EMBEDDINGS ile T-SQL içinden embedding üretimi.',
 'tr');
GO

PRINT N'RAG tablo iskeleti hazır: ai.documents, ai.chunks, ai.query_log';
GO

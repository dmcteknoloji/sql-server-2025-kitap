-- ============================================================================
-- 02-full-text-bm25.sql
-- ----------------------------------------------------------------------------
-- Fulltext search (BM25 backed) — Türkçe LCID 1055.
-- ============================================================================

USE demo;
GO

-- Türkçe fulltext catalog
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE name = N'ft_demo')
    CREATE FULLTEXT CATALOG ft_demo AS DEFAULT;
GO

-- Full-text index için tek sütunlu, unique, non-null, non-clustered indeks gerek.
-- PRIMARY KEY adı otomatik üretilir (örnek: PK__document_chunks__<hash>),
-- bu yüzden adlandırılmış bir unique index oluşturup onu KEY INDEX olarak kullanıyoruz.
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID('ai.document_chunks')
                 AND name = N'ux_chunks_chunk_id')
    CREATE UNIQUE NONCLUSTERED INDEX ux_chunks_chunk_id
        ON ai.document_chunks (chunk_id);
GO

-- Fulltext index — content kolonu
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes
               WHERE object_id = OBJECT_ID('ai.document_chunks'))
    CREATE FULLTEXT INDEX ON ai.document_chunks (content LANGUAGE 1055)
        KEY INDEX ux_chunks_chunk_id
        ON ft_demo;
GO

-- CONTAINS: anahtar kelime arama
SELECT TOP 10
    chunk_id,
    content,
    RANK() OVER (ORDER BY KEY_VALUE DESC) AS bm25_rank
FROM ai.document_chunks
WHERE CONTAINS(content, N'"vector index" OR "diskann"');
GO

-- FREETEXT: doğal dil arama
SELECT TOP 10
    chunk_id,
    LEFT(content, 200) AS preview
FROM ai.document_chunks
WHERE FREETEXT(content, N'optimized locking nasıl çalışır');
GO

-- CONTAINSTABLE — rank skoruyla
SELECT
    c.chunk_id,
    c.content,
    ft.RANK AS bm25_rank
FROM CONTAINSTABLE(ai.document_chunks, content, N'FORMSOF(THESAURUS, vector)') AS ft
JOIN ai.document_chunks c ON c.chunk_id = ft.[KEY]
ORDER BY ft.RANK DESC;
GO

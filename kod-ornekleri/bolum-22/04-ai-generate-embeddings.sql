-- ============================================================================
-- 04-ai-generate-embeddings.sql
-- ----------------------------------------------------------------------------
-- AI_GENERATE_EMBEDDINGS kullanım örnekleri.
-- ============================================================================

USE demo;
GO

-- 1) Tek satır embedding
-- Türkçe metinde "T-SQL'in" derken tek tırnağı escape etmek gerek: ''
DECLARE @text NVARCHAR(MAX) = N'SQL Server 2025 ile native vector arama T-SQL''in parçası.';
DECLARE @v VECTOR(1536) = AI_GENERATE_EMBEDDINGS(@text USE MODEL aoai_embed_small);

INSERT INTO ai.document_chunks (source_doc, chunk_index, content, embedding)
VALUES (N'manual-test', 1, @text, @v);
GO

-- 2) Sorgu sonucu üstüne uygulayarak doğrudan insert
INSERT INTO ai.document_chunks (source_doc, chunk_index, content, embedding)
SELECT
    N'product-catalog',
    p.product_id,
    p.name + N' — ' + p.description,
    AI_GENERATE_EMBEDDINGS(p.name + N' ' + ISNULL(p.description, N'') USE MODEL aoai_embed_small)
FROM sales.products p
WHERE p.description IS NOT NULL;
GO

-- 3) Inline expression olarak — sıralama / filtreleme'de
SELECT TOP 5
    p.name,
    VECTOR_DISTANCE(
        'cosine',
        AI_GENERATE_EMBEDDINGS(p.name USE MODEL aoai_embed_small),
        AI_GENERATE_EMBEDDINGS(N'mekanik klavye' USE MODEL aoai_embed_small)
    ) AS similarity
FROM sales.products p
WHERE p.category = N'Elektronik'
ORDER BY similarity ASC;
GO

-- 4) Update — eski embedding'leri yeni modelle yenile
UPDATE ai.document_chunks
SET embedding = AI_GENERATE_EMBEDDINGS(content USE MODEL aoai_embed_small)
WHERE embedding IS NULL;
GO

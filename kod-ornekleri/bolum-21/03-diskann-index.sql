-- ============================================================================
-- 03-diskann-index.sql
-- ----------------------------------------------------------------------------
-- CREATE VECTOR INDEX — DiskANN tipi (Vamana graph).
-- Microsoft Learn'e göre 2025 RTM'de public sözdizimi şu üç seçeneği destekler:
--   METRIC = 'cosine' | 'dot' | 'euclidean'
--   TYPE   = 'DiskANN'  (tek desteklenen, default)
--   MAXDOP = N          (paralel index build sınırı)
-- Bazı erken DiskANN literatüründe geçen MAX_NEIGHBORS_PER_VERTEX, ALPHA
-- gibi parametreler 2025 public sözdiziminin parçası değil; bunlar motor
-- tarafından otomatik ayarlanır.
-- Kaynak: learn.microsoft.com/en-us/sql/t-sql/statements/create-vector-index-transact-sql
-- ============================================================================

USE demo;
GO

-- Önkoşul 1: PREVIEW_FEATURES açık
ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO

-- Önkoşul 2: Tablo en az 100 satır non-NULL vector içermeli (Msg 42266)
-- Önkoşul 3: Tablo clustered primary key indeksli olmalı

-- DiskANN vector index (cosine — embedding benzerliği için en yaygın)
CREATE VECTOR INDEX vi_chunks_embedding
ON ai.document_chunks (embedding)
WITH (METRIC = 'cosine', TYPE = 'DiskANN');
GO

-- Vector index metadata (sys.indexes + sys.vector_indexes)
SELECT
    OBJECT_NAME(i.object_id) AS table_name,
    i.name AS index_name,
    i.type_desc,
    JSON_VALUE(v.build_parameters, '$.Version') AS index_version,
    JSON_VALUE(v.build_parameters, '$.Metric') AS metric
FROM sys.indexes i
LEFT JOIN sys.vector_indexes v
    ON v.object_id = i.object_id AND v.index_id = i.index_id
WHERE i.type_desc LIKE N'%VECTOR%';
GO

-- Paralel build sınırı ile (büyük tablolarda kontrollü resource tüketimi)
DROP INDEX vi_chunks_embedding ON ai.document_chunks;
GO

CREATE VECTOR INDEX vi_chunks_embedding
ON ai.document_chunks (embedding)
WITH (METRIC = 'cosine', TYPE = 'DiskANN', MAXDOP = 4);
GO

-- VECTOR_SEARCH yeni sözdizimi (TOP_N parametresi DEPRECATED; index version 3+):
--   SELECT TOP (10) WITH APPROXIMATE
--   FROM VECTOR_SEARCH(TABLE = ..., COLUMN = embedding,
--                      SIMILAR_TO = @q, METRIC = 'cosine')
-- Bkz: Bölüm 23 / 01-vector-search-temel.sql

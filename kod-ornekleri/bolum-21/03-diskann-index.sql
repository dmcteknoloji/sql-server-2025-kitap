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

-- Önkoşul 2: Tablo salt-okunur hale gelir. Vector index kurulduktan sonra
--            INSERT/UPDATE/DELETE/MERGE reddedilir (Msg 42231). Veri yüklemek
--            için index'i düşür, yükle, yeniden kur.
--            Not: Learn'de geçen ALLOW_STALE_VECTOR_INDEX ve 100 satır şartı
--            Azure SQL / Fabric'teki yeni index sürümü içindir; SQL Server 2025
--            CU7'de ALLOW_STALE_VECTOR_INDEX yoktur ve index tek satırla da kurulur.
-- Önkoşul 3: Tablo clustered primary key'e sahip olmalı ve bu key TEK bir
--            4 baytlık INT sütun olmalı. BIGINT veya bileşik key reddedilir:
--            Msg 42217 "must have a clustered primary key on a single 4 byte INT column"

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

-- ============================================================================
-- Temizlik — ve aynı zamanda bölümün en önemli dersi
-- ----------------------------------------------------------------------------
-- Vector index kurulu bir tablo salt-okunur olur (Msg 42231): INSERT/UPDATE/
-- DELETE/MERGE reddedilir. Bu script'ten sonra chunk tablosuna yazan başka bir
-- örnek çalıştıracaksanız (Bölüm 22, 24) index'i düşürmeniz gerekir.
-- Üretimdeki karşılığı "düşür - yükle - yeniden kur" döngüsüdür; Bölüm 24'teki
-- RAG hattı bu ritimle kurgulanmıştır.
-- ============================================================================
DROP INDEX IF EXISTS vi_chunks_embedding ON ai.document_chunks;
GO

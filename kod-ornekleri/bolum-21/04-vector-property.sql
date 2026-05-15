-- ============================================================================
-- 04-vector-property.sql
-- ----------------------------------------------------------------------------
-- VECTORPROPERTY: bir VECTOR değerinin Dimensions / BaseType metadata'sını
-- sorgulamak. İmza: VECTORPROPERTY(vector, property) — iki argüman.
-- Kaynak: learn.microsoft.com/en-us/sql/t-sql/functions/vectorproperty-transact-sql
-- ============================================================================

USE demo;
GO

-- Örnek 1: Skaler vector değişkeni
DECLARE @v VECTOR(3) = '[1, 2, 3]';
SELECT
    VECTORPROPERTY(@v, 'Dimensions') AS dim_count,
    VECTORPROPERTY(@v, 'BaseType')   AS base_type;
GO

-- Örnek 2: Tablodaki vector sütununun her satırı için boyut sorgusu
SELECT TOP(5)
    chunk_id,
    VECTORPROPERTY(embedding, 'Dimensions') AS dim,
    VECTORPROPERTY(embedding, 'BaseType')   AS base_type
FROM ai.document_chunks
WHERE embedding IS NOT NULL;
GO

-- Örnek 3: Veritabanındaki tüm vector sütunlarını listele
-- (sys.columns + sys.types ile; boyut için örnek bir satırdan VECTORPROPERTY)
SELECT
    OBJECT_SCHEMA_NAME(c.object_id) + N'.' + OBJECT_NAME(c.object_id) AS table_name,
    c.name AS column_name,
    ty.name AS type_name
FROM sys.columns c
JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE ty.name = N'vector'
  AND OBJECT_SCHEMA_NAME(c.object_id) NOT IN (N'sys', N'INFORMATION_SCHEMA');
GO

-- Örnek 4: Vector index metadata (sys.vector_indexes ile)
-- 2025'te DiskANN parametreleri public metadata olarak motor tarafında.
-- INDEXPROPERTY üzerindeki Vector* özellikleri public sözdiziminin parçası değil.
SELECT
    OBJECT_NAME(i.object_id) AS table_name,
    i.name AS index_name,
    i.type_desc,
    JSON_VALUE(v.build_parameters, '$.Version') AS index_version,
    JSON_VALUE(v.build_parameters, '$.Metric')  AS metric,
    JSON_VALUE(v.build_parameters, '$.Type')    AS algorithm
FROM sys.indexes i
LEFT JOIN sys.vector_indexes v
    ON v.object_id = i.object_id AND v.index_id = i.index_id
WHERE i.type_desc LIKE N'%VECTOR%';
GO

-- Örnek 5: Vector index sağlık DMV
SELECT *
FROM sys.dm_db_vector_indexes
WHERE database_id = DB_ID();
GO

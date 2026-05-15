-- ============================================================================
-- 03-yillara-gore-eklenmis-ozellikler.sql
-- ----------------------------------------------------------------------------
-- Hangi özellik hangi sürümde geldi? Sistem view'lardan tarihsel iz.
-- ============================================================================

-- Bu sürümde mevcut tüm DMV'ler (yeni 2025 DMV'leri burada görünür)
SELECT name, type_desc
FROM sys.system_objects
WHERE type IN ('V','IF','TF','FN','P')
  AND name LIKE 'dm_%'
ORDER BY name;
GO

-- 2025'e özgü yeni objeler (örnekler)
-- Vector
SELECT 'vector functions' AS category, name
FROM sys.system_objects
WHERE name LIKE 'vector_%' OR name LIKE 'vectorproperty%';

-- AI generate
SELECT 'ai generate' AS category, name
FROM sys.system_objects
WHERE name LIKE 'ai_generate_%';

-- Regex
SELECT 'regex' AS category, name
FROM sys.system_objects
WHERE name LIKE 'regexp_%';

-- Fuzzy
SELECT 'fuzzy' AS category, name
FROM sys.system_objects
WHERE name IN ('edit_distance','edit_distance_similarity','jaro_winkler_distance','jaro_winkler_similarity');

-- Change Event Streaming
SELECT 'CES procs' AS category, name
FROM sys.system_objects
WHERE name LIKE 'sp_%event_stream%' OR name LIKE 'sp_%event_stream_group%';
GO

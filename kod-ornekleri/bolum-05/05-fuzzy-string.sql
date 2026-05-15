-- ============================================================================
-- 05-fuzzy-string.sql
-- ----------------------------------------------------------------------------
-- Yazım hatası toleranslı arama. PREVIEW_FEATURES = ON gerekir.
-- ============================================================================

USE demo;
GO

-- EDIT_DISTANCE (Levenshtein)
SELECT
    N'kitap' AS source,
    N'kitab' AS target,
    EDIT_DISTANCE(N'kitap', N'kitab') AS dist;        -- 1
GO

-- EDIT_DISTANCE_SIMILARITY (0-100 normalize)
SELECT
    EDIT_DISTANCE_SIMILARITY(N'Çağlar', N'Caglar') AS similarity_pct;
GO

-- JARO_WINKLER_SIMILARITY (0-1; baş harfler önemliyse bu daha iyi)
SELECT
    JARO_WINKLER_SIMILARITY(N'Çağlar', N'Caglar')  AS yakin,
    JARO_WINKLER_SIMILARITY(N'Mehmet', N'Mehmete') AS cok_yakin,
    JARO_WINKLER_SIMILARITY(N'Mehmet', N'Tahir')   AS uzak;
GO

-- Pratik: ürün adında yazım hatası toleranslı arama
DECLARE @search NVARCHAR(200) = N'mekanik klavyo';  -- typo: 'klavyo' (klavye yerine)

SELECT TOP 3
    p.name,
    p.category,
    JARO_WINKLER_SIMILARITY(LOWER(p.name), LOWER(@search)) AS similarity
FROM sales.products p
WHERE JARO_WINKLER_SIMILARITY(LOWER(p.name), LOWER(@search)) > 0.6
ORDER BY similarity DESC;
GO

-- Müşteri ismi fuzzy match (CRM duplicate detection)
DECLARE @typo NVARCHAR(200) = N'Mehmet Yilmaz';  -- noktalı i farkı

SELECT TOP 3
    c.customer_id,
    c.full_name,
    c.email,
    JARO_WINKLER_SIMILARITY(LOWER(c.full_name), LOWER(@typo)) AS sim
FROM sales.customers c
ORDER BY sim DESC;
GO

-- ============================================================================
-- 02-turkce-full-text-stoplist.sql
-- ----------------------------------------------------------------------------
-- Türkçe Full-Text Search + custom stoplist (kurum jargonu için).
-- Hukuk / tıp / bankacılık domain-spesifik stop word'leri.
-- ============================================================================

USE demo;
GO

-- Full-text catalog
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE name = N'TurkceFTCatalog')
    CREATE FULLTEXT CATALOG TurkceFTCatalog AS DEFAULT;
GO

-- Türkçe stoplist'i sistemden kopyala + genişlet
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_stoplists WHERE name = N'TurkceHukukStoplist')
    CREATE FULLTEXT STOPLIST TurkceHukukStoplist FROM SYSTEM STOPLIST;
GO

-- Hukuk jargonu eklemeleri (Türkçe LCID = 1055)
ALTER FULLTEXT STOPLIST TurkceHukukStoplist ADD N'sayın'    LANGUAGE 1055;
ALTER FULLTEXT STOPLIST TurkceHukukStoplist ADD N'mer''i'   LANGUAGE 1055;
ALTER FULLTEXT STOPLIST TurkceHukukStoplist ADD N'mezkûr'   LANGUAGE 1055;
ALTER FULLTEXT STOPLIST TurkceHukukStoplist ADD N'işbu'     LANGUAGE 1055;
ALTER FULLTEXT STOPLIST TurkceHukukStoplist ADD N'müteakip' LANGUAGE 1055;
ALTER FULLTEXT STOPLIST TurkceHukukStoplist ADD N'mahalli'  LANGUAGE 1055;
GO

-- Demo: belgeler tablosu üzerinde full-text index
IF OBJECT_ID('ai.belgeler','U') IS NULL
BEGIN
    CREATE TABLE ai.belgeler (
        belge_id INT IDENTITY PRIMARY KEY,
        baslik   NVARCHAR(400) NOT NULL,
        icerik   NVARCHAR(MAX) NOT NULL,
        dil      CHAR(2) NOT NULL DEFAULT 'tr'
    );
END
GO

-- Full-text index (Türkçe LCID + custom stoplist)
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('ai.belgeler'))
    CREATE FULLTEXT INDEX ON ai.belgeler (icerik LANGUAGE 1055)
    KEY INDEX PK__belgeler  -- gerçek PK adıyla değiştir
    ON TurkceFTCatalog
    WITH STOPLIST = TurkceHukukStoplist;
GO

-- Örnek arama
INSERT INTO ai.belgeler (baslik, icerik) VALUES
(N'Sözleşme Madde 1', N'İşbu sözleşme tarafların mutabakatıyla imzalanmıştır.'),
(N'Karar 2026/45', N'Sayın mahkeme mer''i mevzuat çerçevesinde değerlendirme yapmıştır.');
GO

-- CONTAINS + Türkçe sözcükler
SELECT belge_id, baslik
FROM ai.belgeler
WHERE CONTAINS(icerik, N'"sözleşme" OR "mahkeme"');
GO

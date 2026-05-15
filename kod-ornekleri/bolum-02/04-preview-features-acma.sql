-- ============================================================================
-- 04-preview-features-acma.sql
-- ----------------------------------------------------------------------------
-- PREVIEW_FEATURES ayarı: vector index build, fuzzy matching, bigint DATEADD
-- gibi özellikler için açık olmalı.
-- ============================================================================

USE demo;
GO

-- Mevcut ayarı görüntüle
SELECT
    name,
    value,
    value_for_secondary
FROM sys.database_scoped_configurations
WHERE name = N'PREVIEW_FEATURES';
GO

-- Aç
ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO

-- Test: Jaro-Winkler benzerliği (PREVIEW)
SELECT
    JARO_WINKLER_SIMILARITY(N'Çağlar', N'Caglar')  AS yakin,
    JARO_WINKLER_SIMILARITY(N'Çağlar', N'Mehmet')  AS uzak;
GO

-- Kapat (örnek; production'da açık bırakılır)
-- ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = OFF;
-- GO

-- ============================================================================
-- 06-entra-id-login.sql
-- ----------------------------------------------------------------------------
-- Microsoft Entra ID (eski Azure AD) login + WITH OBJECT_ID (2025 yenisi).
-- Önkoşul: SQL Server Arc-enabled veya Azure SQL.
-- ============================================================================

USE master;
GO

-- Entra ID user login (Arc instance'da)
CREATE LOGIN [caglar@dmcteknoloji.com]
FROM EXTERNAL PROVIDER
WITH OBJECT_ID = N'00000000-0000-0000-0000-000000000000';   -- Entra object ID
GO

-- Application (service principal) login
CREATE LOGIN [DMC-App]
FROM EXTERNAL PROVIDER
WITH OBJECT_ID = N'11111111-1111-1111-1111-111111111111';
GO

-- Group login (tüm DMC çalışanları)
CREATE LOGIN [DMC-Engineering]
FROM EXTERNAL PROVIDER
WITH OBJECT_ID = N'22222222-2222-2222-2222-222222222222';
GO

-- Veritabanı user'ı
USE demo;
GO

CREATE USER [caglar@dmcteknoloji.com] FROM LOGIN [caglar@dmcteknoloji.com];
CREATE USER [DMC-Engineering] FROM LOGIN [DMC-Engineering];
GO

ALTER ROLE db_datareader ADD MEMBER [DMC-Engineering];
ALTER ROLE db_owner       ADD MEMBER [caglar@dmcteknoloji.com];
GO

-- Mevcut Entra ID kimlikleri
SELECT
    name,
    type_desc,
    sid,
    create_date
FROM sys.server_principals
WHERE type IN ('E', 'X');   -- E: Entra user, X: Entra group
GO

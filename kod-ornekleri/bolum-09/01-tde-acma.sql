-- ============================================================================
-- 01-tde-acma.sql
-- ----------------------------------------------------------------------------
-- Transparent Data Encryption: veri dosyalarını disk seviyesinde şifreler.
-- ============================================================================

USE master;
GO

-- 1) Master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'<karmasik-master-parola>';
GO

-- 2) TDE sertifikası
CREATE CERTIFICATE tde_cert
WITH SUBJECT = N'TDE Certificate for demo database',
     EXPIRY_DATE = '2030-12-31';
GO

-- 3) Sertifikayı dışa aktar (kayıp halinde restore için kritik!)
BACKUP CERTIFICATE tde_cert
TO FILE = N'C:\Backup\tde_cert.cer'
WITH PRIVATE KEY (
    FILE = N'C:\Backup\tde_cert.pvk',
    ENCRYPTION BY PASSWORD = N'<karmasik-cert-parola>'
);
GO

-- 4) DB encryption key oluştur
USE demo;
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE tde_cert;
GO

-- 5) TDE'yi aç
ALTER DATABASE demo SET ENCRYPTION ON;
GO

-- 6) Şifreleme durumu
SELECT
    DB_NAME(database_id) AS db_name,
    encryption_state,
    encryption_state_desc =
        CASE encryption_state
            WHEN 0 THEN N'No DEK'
            WHEN 1 THEN N'Unencrypted'
            WHEN 2 THEN N'Encryption in progress'
            WHEN 3 THEN N'Encrypted'
            WHEN 4 THEN N'Key change in progress'
            WHEN 5 THEN N'Decryption in progress'
        END,
    percent_complete
FROM sys.dm_database_encryption_keys;
GO

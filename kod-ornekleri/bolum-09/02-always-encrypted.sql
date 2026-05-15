-- ============================================================================
-- 02-always-encrypted.sql
-- ----------------------------------------------------------------------------
-- Always Encrypted with secure enclaves — DBA bile veriyi göremesin.
-- Enclave attestation gerektirir (HGS veya Azure attestation).
-- ============================================================================

USE demo;
GO

-- 1) CMK (Column Master Key) — client'ta tutulur, AKV veya Windows store
-- NOT: SIGNATURE ve ENCRYPTED_VALUE değerleri client tool (SSMS Always Encrypted
-- wizard veya PowerShell SqlServer modülü) tarafından üretilir; aşağıdaki hex
-- placeholder'lar gerçek üretimde tam binary değerle değiştirilmelidir.
-- '0x...' geçerli T-SQL değil; somut çalıştırma için wizard çıktısını kullanın.

/*
CREATE COLUMN MASTER KEY my_cmk
WITH (
    KEY_STORE_PROVIDER_NAME = N'AZURE_KEY_VAULT',
    KEY_PATH = N'https://yourkv.vault.azure.net/keys/cmk1/abc123',
    ENCLAVE_COMPUTATIONS (SIGNATURE = 0x0123ABCD...)   -- attestation imzası
);
GO

-- 2) CEK (Column Encryption Key) — CMK ile şifrelenir, DB'de tutulur
CREATE COLUMN ENCRYPTION KEY my_cek
WITH VALUES (
    COLUMN_MASTER_KEY = my_cmk,
    ALGORITHM = N'RSA_OAEP',
    ENCRYPTED_VALUE = 0x01680DEADBEEF...  -- wizard tarafından üretilen blob
);
GO
*/

-- DOĞRU YÖNTEM: SSMS → Tasks → Encrypt Columns → wizard
-- ya da PowerShell: Set-SqlColumnEncryption (SqlServer modülü).
-- Bu script tanıtıcı amaçlı; üretim akışı tool-driven.
PRINT N'Always Encrypted: CMK/CEK üretimi için SSMS wizard veya SqlServer PowerShell modülü kullanın.';
GO

-- 3) Şifreli sütunlu tablo
CREATE TABLE sales.payments (
    payment_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    card_number NVARCHAR(20)
        COLLATE Latin1_General_BIN2
        ENCRYPTED WITH (
            COLUMN_ENCRYPTION_KEY = my_cek,
            ENCRYPTION_TYPE = RANDOMIZED,
            ALGORITHM = N'AEAD_AES_256_CBC_HMAC_SHA_256'
        ) NOT NULL,
    expiry_date NVARCHAR(7)
        COLLATE Latin1_General_BIN2
        ENCRYPTED WITH (
            COLUMN_ENCRYPTION_KEY = my_cek,
            ENCRYPTION_TYPE = DETERMINISTIC,
            ALGORITHM = N'AEAD_AES_256_CBC_HMAC_SHA_256'
        ) NOT NULL
);
GO

-- Client'tan bağlanırken Column Encryption Setting=Enabled olmalı
-- ADO.NET, JDBC, ODBC, Python mssql-python hepsi destekler

-- Server enclave durumu
SELECT * FROM sys.dm_db_attestation_compute_capability;
GO

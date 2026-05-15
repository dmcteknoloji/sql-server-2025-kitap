-- ============================================================================
-- 01-credential-olustur.sql
-- ----------------------------------------------------------------------------
-- External REST endpoint için credential.
-- sp_invoke_external_rest_endpoint @credential parametresi bu credential'ı bekler.
-- ============================================================================

USE master;
GO

-- 1) Managed Identity (Arc-enabled SQL Server üstünde)
IF NOT EXISTS (SELECT 1 FROM sys.credentials WHERE name = N'https://api.example.com')
CREATE DATABASE SCOPED CREDENTIAL [https://api.example.com]
    WITH IDENTITY = 'Managed Identity';
GO

-- 2) Bearer token credential (Azure OpenAI, Slack vb.)
USE demo;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_scoped_credentials WHERE name = N'https://your-aoai.openai.azure.com')
CREATE DATABASE SCOPED CREDENTIAL [https://your-aoai.openai.azure.com]
    WITH IDENTITY = 'HTTPEndpointHeaders',
         SECRET = '{"api-key":"<your-aoai-key>"}';
GO

-- 3) Slack webhook (URL bazlı; secret URL'in kendisi)
IF NOT EXISTS (SELECT 1 FROM sys.database_scoped_credentials WHERE name = N'https://hooks.slack.com/services/T0/B0/X')
CREATE DATABASE SCOPED CREDENTIAL [https://hooks.slack.com/services/T0/B0/X]
    WITH IDENTITY = 'HTTPEndpointHeaders',
         SECRET = '{"Content-Type":"application/json"}';
GO

-- Mevcut credential'ları görüntüle
SELECT name, credential_identity, create_date FROM sys.database_scoped_credentials;
GO

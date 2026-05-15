-- ============================================================================
-- 01-external-model-azure-openai.sql
-- ----------------------------------------------------------------------------
-- Azure OpenAI'a managed identity ile bağlanan external model.
-- Önkoşul: SQL Server Arc-enabled; managed identity'e Cognitive Services
-- OpenAI Contributor rolü verilmiş olmalı.
-- ============================================================================

USE demo;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO

-- 1) Credential (managed identity için boş identity)
IF NOT EXISTS (SELECT 1 FROM sys.database_scoped_credentials
               WHERE name = N'https://your-aoai.openai.azure.com')
CREATE DATABASE SCOPED CREDENTIAL [https://your-aoai.openai.azure.com]
    WITH IDENTITY = 'Managed Identity';
GO

-- 2) External model
CREATE EXTERNAL MODEL aoai_embed_small
WITH (
    LOCATION = 'https://your-aoai.openai.azure.com/openai/deployments/text-embedding-3-small/embeddings?api-version=2024-06-01',
    API_FORMAT = 'Azure OpenAI',
    MODEL_TYPE = EMBEDDINGS,
    MODEL = 'text-embedding-3-small',
    CREDENTIAL = [https://your-aoai.openai.azure.com],
    PARAMETERS = '{"dimensions": 1536}'
);
GO

-- 3) Modeli listele
-- sys.external_models gerçek sütunları: name, model_type_desc, model, location, api_format
-- (model_name veya model_type sütunları YOKTUR)
-- Kaynak: learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-external-models-transact-sql
SELECT name, model_type_desc, model, location, api_format
FROM sys.external_models;
GO

-- 4) Test çağrısı
DECLARE @v VECTOR(1536) = AI_GENERATE_EMBEDDINGS(
    N'SQL Server 2025 vector destekli AI veritabanıdır.' USE MODEL aoai_embed_small
);
SELECT @v AS embedding;
GO

-- Drop için:
-- DROP EXTERNAL MODEL aoai_embed_small;

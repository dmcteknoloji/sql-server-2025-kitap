-- ============================================================================
-- 01-turkce-external-model.sql
-- ----------------------------------------------------------------------------
-- Türkçe embedding modellerinin SQL Server'a CREATE EXTERNAL MODEL ile
-- tanıtılması. Üç senaryo: Azure ML hosted BGE-M3, self-hosted Ollama,
-- Azure OpenAI (Türkiye/AB bölgesi).
-- ============================================================================

USE demo;
GO

-- Senaryo 1: Azure ML üzerinde host edilmiş BGE-M3 (BAAI multilingual, 1024 boyut)
-- Önkoşul: BAAI/bge-m3 modeli Azure ML real-time endpoint olarak deploy edilmiş

-- Credential
CREATE DATABASE SCOPED CREDENTIAL [https://bge-m3-tr.eastus.inference.ml.azure.com/]
WITH IDENTITY = 'HTTPEndpointHeaders',
     SECRET = '{"Authorization":"Bearer <endpoint-key>"}';
GO

CREATE EXTERNAL MODEL TurkceEmbeddingsAzureML
WITH (
    LOCATION = 'https://bge-m3-tr.eastus.inference.ml.azure.com/score',
    API_FORMAT = 'Azure ML',
    MODEL_TYPE = EMBEDDINGS,
    MODEL = 'bge-m3',
    CREDENTIAL = [https://bge-m3-tr.eastus.inference.ml.azure.com/]
);
GO

-- Senaryo 2: Self-hosted Ollama (KVKK için — veri yurt içinde kalır)
CREATE EXTERNAL MODEL LocalOllamaBge
WITH (
    LOCATION = 'http://ollama-server.local:11434/api/embeddings',
    API_FORMAT = 'Ollama',
    MODEL_TYPE = EMBEDDINGS,
    MODEL = 'bge-m3'
);
GO

-- Senaryo 3: Azure OpenAI Avrupa (text-embedding-3-small — Türkçe destekler)
CREATE DATABASE SCOPED CREDENTIAL
  [https://azopenai-westeurope.cognitiveservices.azure.com/]
WITH IDENTITY = 'Managed Identity',
     SECRET = '{"resourceid":"https://cognitiveservices.azure.com"}';
GO

CREATE EXTERNAL MODEL AzOpenAITurkce
WITH (
    LOCATION = 'https://azopenai-westeurope.cognitiveservices.azure.com/openai/deployments/text-embedding-3-small/embeddings?api-version=2024-02-01',
    API_FORMAT = 'Azure OpenAI',
    MODEL_TYPE = EMBEDDINGS,
    MODEL = 'text-embedding-3-small',
    CREDENTIAL = [https://azopenai-westeurope.cognitiveservices.azure.com/]
);
GO

-- Doğrulama: tanımlı modeller
SELECT name, model_type, location, api_format FROM sys.external_models;
GO

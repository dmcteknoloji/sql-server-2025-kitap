-- ============================================================================
-- 02-external-model-ollama.sql
-- ----------------------------------------------------------------------------
-- Local Ollama (örnek: BGE-M3 modeli) ile embedding.
-- Önkoşul: Ollama yerel makine veya yakın network'te koşuyor olmalı.
--   ollama pull bge-m3
--   ollama serve  (default: 11434)
-- ============================================================================

USE demo;
GO

CREATE EXTERNAL MODEL ollama_bge_m3
WITH (
    LOCATION = 'http://localhost:11434/api/embeddings',
    API_FORMAT = 'Ollama',
    MODEL_TYPE = EMBEDDINGS,
    MODEL = 'bge-m3',
    PARAMETERS = '{}'
);
GO

-- BGE-M3 1024 boyutlu embedding üretir
DECLARE @v VECTOR(1024) = AI_GENERATE_EMBEDDINGS(
    N'Türkçe metinler için BGE-M3 güçlü bir embedding modelidir.'
    USE MODEL ollama_bge_m3
);
SELECT @v AS bge_m3_emb;
GO

-- Türkçe için diğer model alternatifleri:
-- ollama pull jinaai/jina-embeddings-v3   (Türkçe destekli)
-- ollama pull selimc/kumru-2b              (Türkçe yerel model)

-- Avantaj: data residency (veri SQL Server'dan dışarı çıkmıyor)
-- Maliyet: GPU/CPU yereldeki donanım

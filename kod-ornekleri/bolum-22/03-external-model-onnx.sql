-- ============================================================================
-- 03-external-model-onnx.sql
-- ----------------------------------------------------------------------------
-- ONNX yerel runtime: SQL Server süreci içinde model çalıştırma (Windows).
-- Önkoşul: SQL Server 2025 Windows + ONNX Runtime'ın yerelde kurulu olması.
-- ----------------------------------------------------------------------------
-- ÖNEMLİ NOT: Microsoft Learn'in CREATE EXTERNAL MODEL sözdiziminde resmi
-- olarak desteklenen API_FORMAT değerleri: 'Azure OpenAI', 'OpenAI', 'Ollama'.
-- ONNX yerel runtime için tipik yaklaşım: API_FORMAT belirtilmez,
-- LOCAL_RUNTIME_PATH ile ONNX runtime dizini gösterilir.
-- Mayıs 2026 itibariyle bu yol Windows üzerinde önerilir; Linux desteği için
-- son CU notlarını teyit edin.
-- Kaynak: devblogs.microsoft.com/azure-sql/create-embeddings-in-sql-server-2025-rc0-with-a-local-onnx-model-on-windows
-- ============================================================================

USE demo;
GO

-- ONNX yerel runtime (Windows üzerinde önerilir).
-- LOCATION yerel dosya yolu olarak ONNX modeli işaret eder.
-- LOCAL_RUNTIME_PATH ONNX Runtime binary dizinini gösterir.
-- API_FORMAT bu senaryoda kullanılmaz.

CREATE EXTERNAL MODEL onnx_minilm
WITH (
    LOCATION = N'C:\sqlserver\models\all-MiniLM-L6-v2.onnx',
    MODEL_TYPE = EMBEDDINGS,
    LOCAL_RUNTIME_PATH = N'C:\sqlserver\onnxruntime\'
);
GO

-- all-MiniLM-L6-v2: 384 boyutlu embedding (hızlı, küçük model)
DECLARE @v VECTOR(384) = AI_GENERATE_EMBEDDINGS(
    N'Hızlı ve hafif embedding modeli'
    USE MODEL onnx_minilm
);
SELECT @v AS minilm_emb;
GO

-- Avantaj: ağ gecikmesi yok; tam offline çalışır; KVKK için ideal.
-- Dezavantaj: model bakımı manuel; SQL Server süreci CPU/memory kullanır;
--            Linux desteği sürüm bazında değişir, son CU release notes'a bakın.

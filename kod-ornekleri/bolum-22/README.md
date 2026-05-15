# Bölüm 22 — AI_GENERATE_EMBEDDINGS

T-SQL içinden embedding üretimi. CREATE EXTERNAL MODEL + AI_GENERATE_EMBEDDINGS.

| Dosya | Amaç |
|---|---|
| `01-external-model-azure-openai.sql` | Azure OpenAI bağlantısı — managed identity ile |
| `02-external-model-ollama.sql` | Local Ollama (BGE-M3) bağlantısı |
| `03-external-model-onnx.sql` | ONNX yerel runtime (LOCAL_RUNTIME_PATH) |
| `04-ai-generate-embeddings.sql` | Tek satır, batch, query expression örnekleri |
| `05-bulk-backfill.sql` | Mevcut tabloya toplu embedding üretimi (batching) |
| `06-embedding-refresh-strateji.sql` | Eager vs lazy refresh stratejileri |

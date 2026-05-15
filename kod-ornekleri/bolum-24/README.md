# Bölüm 24 — RAG Hattı T-SQL ile Uçtan Uca

Retrieval-Augmented Generation pipeline'ı SQL Server 2025 içinde.

| Dosya | Amaç |
|---|---|
| `01-rag-tablo-iskeleti.sql` | ai.documents, ai.chunks, ai.query_log tablo iskeleti |
| `02-chunking-embedding.sql` | AI_GENERATE_CHUNKS + AI_GENERATE_EMBEDDINGS ile chunk + embed |
| `03-retrieval-llm.sql` | Vector search → LLM çağrısı → audit log uçtan uca |

**Önkoşul:** Bölüm 22'deki `CREATE EXTERNAL MODEL Ada2Embeddings` kurulu olmalı.

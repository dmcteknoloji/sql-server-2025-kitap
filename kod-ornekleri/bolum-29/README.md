# Bölüm 29 — Türkçe AI Ekosistemi ve SQL Server

Türkçe modeller (Kumru, Trendyol-LLM, BGE-M3, TURNA) ve SQL Server 2025 entegrasyonu.

| Dosya | Amaç |
|---|---|
| `01-turkce-external-model.sql` | BGE-M3 (Azure ML / Ollama) + Azure OpenAI AB bölgesi CREATE EXTERNAL MODEL |
| `02-turkce-full-text-stoplist.sql` | Türkçe Full-Text + custom stoplist (hukuk jargonu) |
| `03-turkce-rag-hibrit.sql` | Vector + BM25 hybrid search (RRF) Türkçe için |

**Önkoşul:** İlgili external model deploy edilmiş (Azure ML endpoint, Ollama server veya Azure OpenAI EU). KVKK gereği veri yurt dışı çıkmasın isteniyorsa Ollama self-hosted seçilmeli.

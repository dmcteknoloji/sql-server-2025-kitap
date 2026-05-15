# Bölüm 23 — VECTOR_SEARCH ve Hybrid Arama

VECTOR_SEARCH operatörü, BM25 fulltext, Reciprocal Rank Fusion, reranker.

| Dosya | Amaç |
|---|---|
| `01-vector-search-temel.sql` | TOP N WITH APPROXIMATE FROM VECTOR_SEARCH(...) |
| `02-full-text-bm25.sql` | Fulltext catalog + index; CONTAINS / FREETEXT |
| `03-hybrid-rrf.sql` | Vector + BM25 = RRF skoru ile hibrit arama |
| `04-reranker-cohere.sql` | Cohere Rerank REST çağrısı; pipeline son aşaması |
| `05-search-quality-metrics.sql` | recall@10, MRR, NDCG ölçümü |

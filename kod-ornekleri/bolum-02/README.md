# Bölüm 2 — 2025'te SQL Server: Tam Resim

Bu bölüm 2025'in tüm yenilik kümelerini tek bakışta gösterir; kod örnekleri "hangi özellik gerçekten kullanılabiliyor mu?" feature-detection script'leridir. Graph DB, Ledger, Temporal gibi süregelen özelliklerin "hâlâ var" doğrulamaları da burada.

| Dosya | Amaç |
|---|---|
| `01-feature-detection.sql` | Vector, regex, AI generate, JSON tipi, CES gibi yeniliklerin instance'da aktif olup olmadığını test eder |
| `02-graph-mini-ornek.sql` | Graph node/edge, MATCH ve SHORTEST_PATH; arkadaşlık ağında en kısa yol |
| `03-ledger-temporal-filestream.sql` | Süregelen özelliklerin (ledger, temporal, filestream) hangi DB'lerde aktif olduğunu listeler |
| `04-preview-features-acma.sql` | PREVIEW_FEATURES ayarını açıp kapama; vector index, fuzzy gibi özelliklere etkisi |

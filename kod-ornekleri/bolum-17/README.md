# Bölüm 17 — OLAP ve Columnstore

Columnstore indexes (clustered ve nonclustered), batch mode, segment elimination.

| Dosya | Amaç |
|---|---|
| `01-clustered-columnstore.sql` | Büyük fact table'ta CCI |
| `02-nonclustered-columnstore.sql` | OLTP üstüne analitik için NCCI |
| `03-batch-mode-rowstore.sql` | Batch mode on rowstore (2019+, default 2022+) |
| `04-segment-elimination.sql` | Columnstore segment metadata + elimination doğrulama |

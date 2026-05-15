# Bölüm 25 — HTAP Mimari: OLTP, OLAP, AI Yan Yana

Hybrid Transactional/Analytical Processing — tek motorda üç-yönlü iş yükü.

| Dosya | Amaç |
|---|---|
| `01-resource-governor-htap.sql` | OLTP/OLAP/AI pool'ları + classifier function |
| `02-optimized-locking-tempdb.sql` | Optimized Locking + tempdb governance + ADR |
| `03-htap-izleme.sql` | Pool kullanımı + wait stats + NCCI rowgroup sağlığı |

**Önkoşul:** SQL Server 2025 CU2+ (Optimized Locking GA), demo DB ile RCSI açık.

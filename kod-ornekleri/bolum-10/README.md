# Bölüm 10 — Performans Tuning ve IQP

Query Store, IQP hints, wait stats, plan analizi.

| Dosya | Amaç |
|---|---|
| `01-query-store-acma.sql` | QS aktivasyon + retention + capture mode |
| `02-wait-stats.sql` | sys.dm_os_wait_stats; baseline + delta |
| `03-iqp-hints.sql` | OPTION (USE HINT(...)): OPPO, ABORT_QUERY_EXECUTION |
| `04-plan-forcing.sql` | Query Store ile plan zorlama |
| `05-resource-governor.sql` | Resource pool, workload group, classifier function |

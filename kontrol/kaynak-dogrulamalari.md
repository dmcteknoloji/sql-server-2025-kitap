# Kaynak Doğrulamaları — SQL Server 2025 Kitabı

Her teknik iddia bu tabloya bir satır olarak girer. Bölüm bazında yazılır; URL'i olmayan iddia kitaba girmez.

| Tarih | Bölüm | İddia / Konu | Birincil Kaynak (URL) | Kontrol durumu |
|---|---|---|---|---|

## Faz 0 — Plan kaynak havuzu (2026-05-15)

Plan aşamasında doğrulanmış birincil kaynaklar. Her bölüm yazımında ilgili olanlar tekrar açılır, son CU bilgisi kontrol edilir, satır tabloya işlenir.

### Resmî dokümantasyon (Microsoft Learn)

| Konu | URL | Kontrol tarihi |
|---|---|---|
| What's New in SQL Server 2025 | https://learn.microsoft.com/en-us/sql/sql-server/what-s-new-in-sql-server-2025?view=sql-server-ver17 | 2026-05-15 |
| Editions and Supported Features | https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2025?view=sql-server-ver17 | 2026-05-15 |
| Breaking Changes | https://learn.microsoft.com/en-us/sql/database-engine/breaking-changes-to-database-engine-features-in-sql-server-2025?view=sql-server-ver17 | 2026-05-15 |
| Deprecated Features | https://learn.microsoft.com/en-us/sql/database-engine/deprecated-database-engine-features-in-sql-server-2025?view=sql-server-ver17 | 2026-05-15 |
| Discontinued Functionality | https://learn.microsoft.com/en-us/sql/database-engine/discontinued-database-engine-functionality-in-sql-server?view=sql-server-ver17 | 2026-05-15 |
| Vector Search and Vector Index | https://learn.microsoft.com/en-us/sql/sql-server/ai/vectors?view=sql-server-ver17 | 2026-05-15 |
| CREATE VECTOR INDEX (T-SQL) | https://learn.microsoft.com/en-us/sql/t-sql/statements/create-vector-index-transact-sql?view=sql-server-ver17 | 2026-05-15 |
| VECTOR_SEARCH (T-SQL) | https://learn.microsoft.com/en-us/sql/t-sql/functions/vector-search-transact-sql?view=sql-server-ver17 | 2026-05-15 |
| Release Notes | https://learn.microsoft.com/en-us/sql/sql-server/sql-server-2025-release-notes?view=sql-server-ver17 | 2026-05-15 |
| Known Issues | https://learn.microsoft.com/en-us/sql/sql-server/sql-server-2025-known-issues?view=sql-server-ver17 | 2026-05-15 |
| Lifecycle | https://learn.microsoft.com/en-us/lifecycle/products/sql-server-2025 | 2026-05-15 |
| Hardware/Software Requirements | https://learn.microsoft.com/en-us/sql/sql-server/install/hardware-and-software-requirements-for-installing-sql-server-2025 | 2026-05-15 |
| REGEXP_LIKE | https://learn.microsoft.com/en-us/sql/t-sql/functions/regexp-like-transact-sql?view=sql-server-ver17 | 2026-05-15 |
| REGEXP_REPLACE | https://learn.microsoft.com/en-us/sql/t-sql/functions/regexp-replace-transact-sql?view=sql-server-ver17 | 2026-05-15 |
| Regex Overview | https://learn.microsoft.com/en-us/sql/relational-databases/regular-expressions/overview?view=sql-server-ver17 | 2026-05-15 |
| JSON Data Type | https://learn.microsoft.com/en-us/sql/t-sql/data-types/json-data-type?view=sql-server-ver17 | 2026-05-15 |
| Change Event Streaming Overview | https://learn.microsoft.com/en-us/sql/relational-databases/track-changes/change-event-streaming/overview?view=sql-server-ver17 | 2026-05-15 |
| CES Configure | https://learn.microsoft.com/en-us/sql/relational-databases/track-changes/change-event-streaming/configure?view=sql-server-ver17 | 2026-05-15 |
| CES FAQ | https://learn.microsoft.com/en-us/sql/relational-databases/track-changes/change-event-streaming/frequently-asked-questions-faq?view=sql-server-ver17 | 2026-05-15 |
| sys.sp_create_event_stream_group | https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sys-sp-create-event-stream-group-transact-sql?view=sql-server-ver17 | 2026-05-15 |
| Fabric Mirroring from SQL Server | https://learn.microsoft.com/en-us/fabric/mirroring/sql-server | 2026-05-15 |
| Mirroring tutorial | https://learn.microsoft.com/en-us/fabric/mirroring/sql-server-tutorial | 2026-05-15 |
| Mirroring limitations | https://learn.microsoft.com/en-us/fabric/mirroring/sql-server-limitations | 2026-05-15 |
| sp_invoke_external_rest_endpoint | https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql?view=sql-server-ver17 | 2026-05-15 |
| EF Core SQL Server Vector Search | https://learn.microsoft.com/en-us/ef/core/providers/sql-server/vector-search | 2026-05-15 |

### Duyurular ve teknik blog

| Konu | URL | Kontrol tarihi |
|---|---|---|
| SQL Server 2025 GA Duyurusu (Ignite 2025) | https://techcommunity.microsoft.com/blog/sqlserver/sql-server-2025-is-now-generally-available/4470570 | 2026-05-15 |
| SQL Server 2025 embraces vectors | https://devblogs.microsoft.com/azure-sql/sql-server-2025-embraces-vectors-setting-the-foundation-for-empowering-your-data-with-ai/ | 2026-05-15 |
| RC1: faster DiskANN and FP16 | https://devblogs.microsoft.com/azure-sql/sql-server-2025-rc1-faster-diskann-and-fp16-support/ | 2026-05-15 |
| Getting started with AI in SQL Server 2025 | https://devblogs.microsoft.com/azure-sql/getting-started-with-ai-in-sql-server-2025-on-windows/ | 2026-05-15 |
| The year ahead for SQL Server | https://www.microsoft.com/en-us/sql-server/blog/2025/01/15/the-year-ahead-for-sql-server-ground-to-cloud-to-fabric/ | 2026-05-15 |
| Regex GA in SQL Server 2025 | https://devblogs.microsoft.com/azure-sql/general-availability-announcement-regex-support-in-sql-server-2025-azure-sql/ | 2026-05-15 |
| SQL Server 2025 — AI-ready (Ignite blog) | https://techcommunity.microsoft.com/blog/sqlserver/sql-server-2025---ai-ready-enterprise-database-from-ground-to-cloud/4413529 | 2026-05-15 |

### Cumulative update

| Konu | URL | Kontrol tarihi |
|---|---|---|
| CU4 KB5081495 | https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/cumulativeupdate4 | 2026-05-15 |
| Release history (Linux) | https://learn.microsoft.com/en-us/troubleshoot/sql/releases/linux/release-history-2025 | 2026-05-15 |

### Lisans / dağıtım

| Konu | URL | Kontrol tarihi |
|---|---|---|
| SQL Server 2025 Pricing PDF | https://cdn-dynmedia-1.microsoft.com/is/content/microsoftcorp/microsoft/bade/documents/products-and-services/en-us/cloud/SQL-Server-2025-Pricing.pdf | 2026-05-15 |
| Editions Datasheet PDF | https://cdn-dynmedia-1.microsoft.com/is/content/microsoftcorp//microsoft/bade/documents/products-and-services/en-us/owned-and-operated/SQL-Server-2025-Editions.pdf | 2026-05-15 |
| Standard/Enterprise License Terms | https://www.microsoft.com/content/dam/microsoft/usetm/documents/sql-server/sql-server-2025-enterprise,-standard/retail/SQL_Server_2025_Standard_Enterprise_English.pdf | 2026-05-15 |
| Evaluation Center | https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2025 | 2026-05-15 |
| Ana sayfa (Get SQL Server 2025) | https://info.microsoft.com/ww-landing-sql-server-2025.html | 2026-05-15 |

### Ignite oturumu

| Konu | URL | Kontrol tarihi |
|---|---|---|
| BRK124 — SQL Server 2025: AI-ready enterprise database | https://ignite.microsoft.com/en-US/sessions/brk124 | 2026-05-15 |

### Topluluk ve süreli yayın

| Konu | URL | Kontrol tarihi |
|---|---|---|
| SQLServerCentral | https://www.sqlservercentral.com/articles/sql-server-2025-has-arrived | 2026-05-15 |
| MSSQLTips New Features | https://www.mssqltips.com/sqlservertip/8290/sql-server-2025-new-features/ | 2026-05-15 |
| Brent Ozar | https://www.brentozar.com/archive/2024/11/whats-new-in-sql-server-2025/ | 2026-05-15 |
| SQL Spotlight: Ignite 2025 | https://techcommunity.microsoft.com/blog/sqlserver/sql-spotlight-ignite-2025/4467082 | 2026-05-15 |
| Database Innovations Ignite 2025 | https://techcommunity.microsoft.com/blog/sqlserver/database-innovations-your-guide-to-microsoft-ignite-2025/4467810 | 2026-05-15 |

### Referans / rakip kitap

| Konu | URL | Kontrol tarihi |
|---|---|---|
| Bob Ward — SQL Server 2025 Unveiled (Apress) | https://www.amazon.com/SQL-Server-2025-Unveiled-Integration/dp/B0FH1P9B2Y | 2026-05-15 |
| SQL Server 2025 Query Performance Tuning | https://www.oreilly.com/library/view/sql-server-2025/9798868818653/ | 2026-05-15 |

### Akademik

| Konu | URL | Kontrol tarihi |
|---|---|---|
| IJSAT — Key Features and Innovations in SQL Server 2025 | https://www.ijsat.org/papers/2025/1/2493.pdf | 2026-05-15 |

### GitHub sample repolar

| Konu | URL | Kontrol tarihi |
|---|---|---|
| microsoft/sql-server-samples | https://github.com/microsoft/sql-server-samples | 2026-05-15 |
| microsoft/bobsql/demos/sqlserver2025 | https://github.com/microsoft/bobsql/tree/master/demos/sqlserver2025 | 2026-05-15 |
| microsoft/mssql-python | https://github.com/microsoft/mssql-python | 2026-05-15 |
| MicrosoftDocs/sql-docs | https://github.com/MicrosoftDocs/sql-docs | 2026-05-15 |
| Azure-Samples/azure-sql-db-vector-search | https://github.com/Azure-Samples/azure-sql-db-vector-search | 2026-05-15 |
| Azure-Samples/azure-sql-diskann | https://github.com/Azure-Samples/azure-sql-diskann | 2026-05-15 |
| Azure-Samples/azure-sql-db-openai | https://github.com/Azure-Samples/azure-sql-db-openai | 2026-05-15 |
| Azure-Samples/azure-sql-db-chatbot | https://github.com/Azure-Samples/azure-sql-db-chatbot | 2026-05-15 |
| Azure-Samples/azure-sql-langchain | https://github.com/Azure-Samples/azure-sql-langchain | 2026-05-15 |
| Azure-Samples/azure-sql-db-vectorizer | https://github.com/Azure-Samples/azure-sql-db-vectorizer | 2026-05-15 |
| Azure-Samples/azure-sql-modernize-app-with-ai | https://github.com/Azure-Samples/azure-sql-modernize-app-with-ai | 2026-05-15 |
| Azure-Samples/azure-vector-database-samples | https://github.com/Azure-Samples/azure-vector-database-samples | 2026-05-15 |
| efcore/EFCore.SqlServer.VectorSearch | https://github.com/efcore/EFCore.SqlServer.VectorSearch | 2026-05-15 |

### Video / podcast

| Konu | URL | Kontrol tarihi |
|---|---|---|
| SQL Server 2025 Explained (YouTube) | https://www.youtube.com/watch?v=lfyoaJPCxug | 2026-05-15 |
| 2025 Ignite Recap Webinar | https://www.youtube.com/watch?v=nMOeXeaZ-KM | 2026-05-15 |
| Updates from Ignite Data Platform | https://www.youtube.com/watch?v=1gOOel4dd4o | 2026-05-15 |
| RunAsRadio 989 (Bob Ward) | https://runasradio.com/Shows/Show/989 | 2026-05-15 |
| RunAsRadio 1027 (SQL Server in 2026) | https://runasradio.com/Shows/Show/1027 | 2026-05-15 |
| Azure DevOps Podcast 354 | https://azuredevopspodcast.clear-measure.com/bob-ward-sql-server-2025-episode-354 | 2026-05-15 |

### Türkçe topluluk

| Konu | URL | Kontrol tarihi |
|---|---|---|
| Çağlar Özenç — Microsoft SQL Server Tarihi ve Gelişimi | https://caglarozenc.com/ms-sql-server/microsoft-sql-server-tarihi-ve-gelisimi-baslangictan-2025e.html | 2026-05-15 |
| Azure Data Topluluğu (Microsoft TR) | https://www.microsoft.com/tr-tr/sql-server/community | 2026-05-15 |
| Microsoft Learn TR-TR | https://learn.microsoft.com/tr-tr/training/ | 2026-05-15 |
| Turkcell Geleceği Yazanlar SQL Server | https://gelecegiyazanlar.turkcell.com.tr/konu/microsoft-sql-server | 2026-05-15 |

## Faz 1 ve sonrası

Her bölüm yazımında bu havuzdan ilgili kaynaklar açılır, ek kaynak gerekiyorsa eklenir, kontrol tarihi güncellenir. Her cümlenin kaynak bağlantısı yukarıdaki başlık altında belirir.

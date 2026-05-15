# Driver Karşılaştırma Matrisi (Mayıs 2026)

| Driver | Dil | Status (2026-05) | Vector | Entra ID | Async | Notlar |
|---|---|---|---|---|---|---|
| Microsoft.Data.SqlClient | .NET | GA (5.x) | Evet (EF plugin) | Native | Evet | Resmi, en güncel; Always Encrypted enclave destekli |
| mssql-python | Python | GA (Kasım 2025) | Evet | Native | Native asyncio | pyodbc halefi; Microsoft resmi |
| pyodbc | Python | Mature | Limited | Driver üstünden | Yok | Eski standart; mssql-python'a göç ediliyor |
| JDBC | Java | GA (12.x) | Limited | Native | Reactive (R2DBC) | Stable, enterprise standard |
| tedious + mssql | Node.js | GA | Manuel SQL | MSI | Native | TypeScript desteği güçlü |
| go-mssqldb | Go | Stable | Manuel | Limited | Native | Community-driven |
| sqlx + tiberius | Rust | Beta | Manuel | Limited | Native | Performans odaklı |

## Seçim kriterleri

| Senaryo | Önerilen |
|---|---|
| .NET monolith / mikroservis | Microsoft.Data.SqlClient + EF Core 9 veya Dapper |
| Python ML / data pipeline | mssql-python (2025 GA) |
| Java enterprise app | Microsoft JDBC |
| Node.js API | tedious + mssql package |
| Performans-kritik Go servisi | go-mssqldb |
| Vector search hot path | .NET (EF VectorSearch plugin) veya Python (mssql-python + numpy) |

## Connection pool boyutlandırma

| App tipi | Max Pool Size |
|---|---|
| Düşük trafikli web | 20-50 |
| Orta trafikli web | 50-200 |
| Yüksek trafikli mikroservis | 100-500 (her instance için) |
| Batch / ETL | 10-30 |

Pool size'ı sunucudaki `max worker threads` ile çarpı app instance sayısı dikkate alarak ayarla. SQL Server thread pool'u tükenirse THREADPOOL wait'leri başlar.

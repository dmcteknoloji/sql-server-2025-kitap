# Test Koşumu — Bilinen Sorunlar Kataloğu

**Tarih:** 2026-05-15
**Sürüm:** SQL Server 2025 RTM-CU4-GDR (KB5089899), build 17.0.4040.1, Standard Edition
**Kapsam:** 32 bölümün kod-ornekleri/ altındaki tüm .sql dosyaları
**Sonuç:** 81 script çalıştı / 29 OK / 52 FAIL / 10 boş bölüm (24-32 arası)

Bu liste yayın öncesi (Faz 7 beta okur turu + Faz 8 son kontrol) sıfırlanmak üzere açık tutulur.

---

## Kategori A — Çevresel kısıtlar (test ortamında düzeltilemez, kitapta "bu özellik şu önkoşulu gerektirir" notu yeterli)

### A1. Enterprise Edition gerek
- `ch06-04` (online index Enterprise edition gerek — Msg 1712)
  - **Durum:** Bölüm 6'da zaten "2025 ile Standard'a açıldı" notu mevcut. Test instance'ımız Standard, online build çalışıyor. Bu özel script muhtemelen partition switch + online operation kombinasyonu kullanıyor; o kombinasyon hâlâ Enterprise. Kitap metni doğru, sadece script özel notla işaretlenmeli.

### A2. Always On AG / mirroring kurulu değil
- `ch08-01`, `ch08-02`, `ch08-04` (Msg 35208, 35221)
  - **Durum:** Always On AG kurulum yapılmadan DDL çalıştırılamaz. Bu testler AG mevcut bir cluster gerektirir. Beta okur turunda AG-kurulu sandbox üzerinde teyit edilmeli.
- `ch18-01`, `ch18-03` (Msg 207 invalid column, Msg 208 invalid object)
  - **Durum:** Mirroring DMV'leri (`sys.dm_change_feeds_log_scan_sessions`, `is_change_tracking_on`) Fabric Mirroring etkin olmadığında bazı sütunlar oluşturulmuyor olabilir. Fabric workspace'le bağlı bir DB'de yeniden test gerek.

### A3. Backup/restore credential gerek
- `ch07-01`, `ch07-02`, `ch07-03`, `ch07-04` (Msg 3201, 3013, 37563)
  - **Durum:** `BACKUP TO URL` Azure Blob Storage credential (Database Scoped Credential + Managed Identity) gerektirir. Test ortamımızda mevcut değil. Beta sandbox'ında Arc managed identity ile çalıştırılmalı.

### A4. External REST / AI features sp_configure ile kapalı
- `ch13-01`, `ch13-02`, `ch13-04` (Msg 33158, 31643 — `sp_invoke_external_rest_endpoint` disabled)
- `ch22-02` (Msg 31643 — `ai_generate_embeddings` disabled)
  - **Durum:** İnstance düzeyinde açılması gerek:
    ```sql
    EXEC sp_configure 'external rest endpoint enabled', 1; RECONFIGURE;
    EXEC sp_configure 'allow polybase export', 1; RECONFIGURE;  -- gerekirse
    ```
  - Kitap bölüm 13 ve 22 yazılırken bu önkoşul belirtilmeli (zaten bahsediliyor ama "açık olmazsa Msg 31643" notu eklenebilir).

### A5. Audit / encryption / Entra dış altyapı
- `ch09-01` (Msg 15118 — Windows parola politikası test login için yetersiz)
- `ch09-05` (Msg 33072 — audit log file path geçersiz; OS-level path gerek)
- `ch09-06` (Msg 37525 — `CREATE LOGIN FROM EXTERNAL PROVIDER` Entra ID'yle Azure SQL/Arc'a bağlı instance gerek)
- `ch23-04` (Msg 15581 — master key yaratılmamış; ilk başta `CREATE MASTER KEY ENCRYPTION BY PASSWORD = ...` gerek)
  - **Durum:** Hepsi tek seferlik instance/DB hazırlığı. Test sandbox'ında kurulum runbook'una eklenmeli.

### A6. Synapse Link kaldırıldı (2025 kasıtlı davranış)
- `ch20-01` (Msg 207 — `is_link_to_synapse_enabled` invalid column)
  - **Durum:** Bölüm 20 zaten "Synapse Link kaldırıldı" diyor. Bu script "Synapse Link kullanan DB var mı?" tespitiydi; sütunun olmaması beklenen davranış. Script `IF COL_LENGTH('sys.databases','is_link_to_synapse_enabled') IS NULL PRINT 'Synapse Link bu sürümde yok (kaldırıldı)' ELSE ...` ile güncellenebilir.

### A7. Test çerçeveleri yüklenmemiş
- `ch14-03` (Msg 25602 — extended event file target setup)
- `ch16-04` (Msg 2812 — `tSQLt.NewTestClass` bulunamadı; tSQLt framework kurulmamış)
  - **Durum:** tSQLt opsiyonel; CI/CD bölümünde "kurulum: github.com/tSQLt-org/tSQLt" yönlendirmesi mevcut.

---

## Kategori B — Düzeltilebilir kitap kodu bug'ları (lansman öncesi düzeltilecek)

### B1. T-SQL sözdizim hataları

| ID | Dosya | Hata | Düzeltme |
|----|-------|------|----------|
| ch02-01 | bolum-02/01-feature-detection.sql | REGEXP_LIKE SELECT'te | ✅ Düzeltildi: CASE içine alındı |
| ch12-01 | bolum-12/01-regex-tam-rehber.sql | REGEXP_LIKE SELECT'te | ✅ Düzeltildi: CASE içine alındı + WHERE clause örneği eklendi |
| ch05-04 | bolum-05/04-json-tipi.sql | `CREATE TABLE IF NOT EXISTS` Postgres sözdizimi | ✅ Düzeltildi: `IF OBJECT_ID() IS NULL` |
| ch12-04 | bolum-12/04-tvf-cte-recursive.sql | Aynı IF NOT EXISTS sorunu | ✅ Düzeltildi: `IF OBJECT_ID() IS NULL` |
| ch11-01 | bolum-11/01-extended-events-sablon.sql | XEvent WHERE clause duration unbracketed | ✅ Düzeltildi: `WHERE ([duration] > (5000000))` bracket'lı + 2025 time-bound DURATION yorumlandı |
| ch21-02 | bolum-21/02-vector-distance-fonksiyonlari.sql | `::` operatörü — SQL Server'da yok | ✅ Düzeltildi: `CAST(... AS VECTOR(N))` + VECTOR_NORM 2-arg imzası |
| ch21-04 | bolum-21/04-vector-property.sql | VECTORPROPERTY 3 argümanla çağrılmış | ✅ Düzeltildi: 2-arg imza `VECTORPROPERTY(@v, 'Dimensions')` |
| ch22-04 | bolum-22/04-ai-generate-embeddings.sql | Türkçe `T-SQL'in` string tek tırnak escape eksik | ✅ Düzeltildi: `T-SQL''in` çift tek-tırnak |
| ch22-06 | bolum-22/06-embedding-refresh-strateji.sql | `CREATE TABLE IF NOT EXISTS ai.embedding_queue` Postgres syntax | ✅ Düzeltildi: `IF OBJECT_ID() IS NULL` |
| ch23-01 | bolum-23/01-vector-search-temel.sql | TOP_N parametresi + WITH APPROXIMATE çakışması (Msg 42274) | ✅ Düzeltildi: TOP_N kaldırıldı, yeni v3 syntax |
| ch23-03 | bolum-23/03-hybrid-rrf.sql | DECLARE sonrası CTE WITH için `;` ayırıcı eksik | ✅ Düzeltildi: `;WITH vector_results AS (...)` |

### B2. Şema/sütun adı yanlış

| ID | Dosya | Hata | Düzeltme |
|----|-------|------|----------|
| ch02-03 | bolum-02/03-ledger-temporal-filestream.sql | `is_dropped_ledger` sütunu yok | ✅ Düzeltildi: `is_dropped_ledger_table` (sys.tables gerçek adı) |
| ch09-02 | bolum-09/02-always-encrypted.sql | `0x...` placeholder hex literal değil | ✅ Düzeltildi: CMK/CEK üretimi yorum bloğunda; SSMS wizard yönlendirmesi PRINT |
| ch09-03 | bolum-09/03-rls-dinamik-filtre.sql | `security` schema yok | ✅ Düzeltildi: `IF SCHEMA_ID('security') IS NULL EXEC('CREATE SCHEMA security')` + `IF COL_LENGTH IS NULL ALTER TABLE` re-runnable |
| ch10-01 | bolum-10/01-query-store.sql | `QUERY_STORE_FOR_SECONDARY` ayrı SET deyimi yanlış | ✅ Düzeltildi: `SET QUERY_STORE (CAPTURE_MODE_FOR_SECONDARY = AUTO)` doğru sözdizimi |
| ch10-03 | bolum-10/03-iqp-hints.sql | `@cust` declare edilmemiş | ✅ Düzeltildi: script başına `DECLARE @cust INT = 1;` |
| ch11-04 | bolum-11/04-statistics.sql | `PK__orders__order_id` hash'li PK adı tutarsız | ✅ Düzeltildi: dinamik `sys.stats` sorgusu + `sp_executesql` |
| ch14-04 | bolum-14/04-isolation-snapshot.sql | `used_space_kb` invalid column | ✅ Düzeltildi: `*_page_count * 8 / 1024.0` (8 KB sayfa) |
| ch17-02 | bolum-17/02-nonclustered-columnstore.sql | Index zaten var | ✅ Düzeltildi: `IF EXISTS DROP INDEX` ön kontrolü |
| ch17-04 | bolum-17/04-segment-elimination.sql | `s.object_id` invalid (column_store_segments'te yok) | ✅ Düzeltildi: `p.object_id` üzerinden partition join |
| ch22-01 | bolum-22/01-external-model-azure-openai.sql | `model_name`, `model_type` invalid sütunlar | ✅ Düzeltildi: `name, model_type_desc, model, location, api_format` (gerçek sys.external_models sütunları) |
| ch22-03 | bolum-22/03-external-model-onnx.sql | API_FORMAT = 'ONNX' geçersiz | ✅ Düzeltildi: ONNX için LOCAL_RUNTIME_PATH ile API_FORMAT atlanır |

### B3. Veri/değer hataları

| ID | Dosya | Hata | Düzeltme |
|----|-------|------|----------|
| ch05-03 | bolum-05/03-yeni-2025-dil-fonksiyonlari.sql | `BASE64_ENCODE(nvarchar)` argüman tipi (Msg 8116) | ✅ Düzeltildi: `CAST(N'...' AS VARBINARY(MAX))` |
| ch06-02 | bolum-06/02-optimized-locking-test.sql | `OBJECT_NAME(BIGINT)` overflow (Msg 8115) | ✅ Düzeltildi: `CASE WHEN resource_type='OBJECT' THEN OBJECT_NAME(CAST(... AS INT)) ELSE NULL END` |
| ch12-02 | bolum-12/02-json-uzanan-fonksiyonlar.sql | `CAST('true' AS JSON)` boolean parse | ✅ Düzeltildi: `CAST(1 AS BIT)` (JSON_MODIFY boolean ataması) |

### B4. Karmaşık (Microsoft Learn ile çapraz kontrol sonrası ✅)

- `ch02-02` ✅ Düzeltildi: SHORTEST_PATH agg fonksiyonları (LAST_VALUE WITHIN GROUP) WHERE'de filtre olarak kullanılamaz — outer subquery ile sarıldı
- `ch21-03` ✅ Düzeltildi: MAX_NEIGHBORS_PER_VERTEX, ALPHA Microsoft Learn'in public sözdiziminde yok. Sadece METRIC, TYPE, MAXDOP geçerli (kaynak: learn.microsoft.com/.../create-vector-index-transact-sql)
- `ch22-03` ✅ Düzeltildi: API_FORMAT resmi değerleri 'Azure OpenAI'|'OpenAI'|'Ollama'. ONNX yerel runtime için LOCAL_RUNTIME_PATH + API_FORMAT atlanır
- `ch23-02` ✅ Düzeltildi: hash'li PK adı yerine adlandırılmış `ux_chunks_chunk_id` UNIQUE NONCLUSTERED indeks KEY INDEX olarak

**Bu seansta kapatıldı:** Microsoft Learn (learn.microsoft.com/en-us/sql/.../?view=sql-server-ver17) ile çapraz kontrol sonucu sözdizimleri kanonik hâle çekildi.

---

## Kategori C — Bölüm 24-32 kod örnekleri yazılmamış

- `bolum-24` (RAG) — boş
- `bolum-25` (HTAP) — boş
- `bolum-26` (SQL MCP Server) — boş
- `bolum-27` (Türkiye yol haritası) — vizyonel, kod yok
- `bolum-28` (KVKK/EU AI Act) — vizyonel, kod yok
- `bolum-29` (Türkçe AI) — boş; bölüm metninde T-SQL var ama .sql dosyaları yok
- `bolum-30` (Sürüm karşılaştırma) — vizyonel
- `bolum-31` (2027+) — vizyonel
- `bolum-32` (Kapanış) — vizyonel

**Yapılacak:** Plan Faz 4'ün ikinci yarısı. Bolum 24, 25, 26, 29 için kod örnekleri yazılmalı; 27/28/30/31/32 zaten kasten kodsuz (vizyonel/sentez bölümler).

---

## Sonuç

- **29 OK çıktısı** kitap bölümlerine "Çalıştırma çıktısı" kutusu olarak gömülebilir (Plan B Faz 4 ikinci yarı).
- **B1+B2+B3 = ~24 bug** bir gün içinde tek tek düzeltilebilir.
- **B4 = 4 karmaşık** Microsoft Learn'in son güncellemeleriyle çapraz kontrol gerek.
- **Kategori A**'nın tümü Faz 7 beta okur sandbox'ında yapılandırılmış instance üzerinde yeniden koşacak.
- **Kategori C** bölüm 24-29 için kod örneği yazma işidir.

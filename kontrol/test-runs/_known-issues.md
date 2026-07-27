# Test Koşumu — Bilinen Sorunlar Kataloğu

**Son koşum:** 2026-07-27
**Sürüm:** SQL Server 2025 RTM-CU7 (KB5096981), build 17.0.4065.4, Enterprise Developer Edition, Linux (Docker)
**Kapsam:** 32 bölümün `kod-ornekleri/` altındaki tüm .sql dosyaları
**Sonuç:** 92 script koşuldu — **61 OK / 31 FAIL**

Önceki koşum (2026-05-15, CU4-GDR, Standard Edition, Windows): 81 script / 29 OK / 52 FAIL. O koşumun kaydı bu dosyanın sonunda tarihçe olarak duruyor.

---

## v1.0.3 koşumunda bulunup düzeltilen kitap hataları

Aşağıdakiler çevresel kısıt değil, **gerçek hataydı**; hepsi motor tarafından doğrulanıp düzeltildi.

### Vector index (Bölüm 21, 24)

| Bulgu | Kitapta olan | Doğru olan | Kanıt |
|---|---|---|---|
| Salt-okunur kısıtı | Hiç yer almıyordu | Vector index kurulu tablo DML kabul etmez | Msg 42231 |
| Clustered PK tipi | "clustered primary key indeksli olmalı" | Tek bir 4 baytlık `INT` sütun olmalı | Msg 42217 |
| FP16 sözdizimi | `WITH (PRECISION = 'half')` | Sütun tipinde: `VECTOR(1536, float16)` | Msg 155 |
| "En az 100 satır" | Önkoşul olarak yazılmıştı | Yeni index sürümüne (Azure SQL / Fabric) ait; CU7'de uygulanmıyor | Canlı test |

`ALLOW_STALE_VECTOR_INDEX` SQL Server 2025 CU7'de ne veritabanı ne sunucu kapsamında mevcut değil. Learn'ün DML desteğinden söz eden cümleleri Azure SQL / Fabric'teki yeni index sürümü içindir.

Yan etki: `chunk_id` sütunları `BIGINT` yerine `INT`'e çekildi (`_ortak/00-demo-veritabani.sql`, `bolum-24/01`, `bolum-22/06`, `bolum-24/03`).

### Change Event Streaming (Bölüm 19)

CU7'de **mevcut olmayan** nesneler kitapta kullanılıyordu:

- `sys.event_stream_groups`, `sys.event_stream_group_tables`, `sys.dm_event_stream_status` — üçü de yok (Msg 208), CES etkinleştirilse bile
- `sys.sp_start_event_stream_group`, `sys.sp_stop_event_stream_group` — yok (Msg 2812)

Gerçekte mevcut olanlar: `sp_enable_event_stream`, `sp_disable_event_stream`, `sp_create_event_stream_group`, `sp_drop_event_stream_group`, `sp_add_object_to_event_stream_group`, `sp_remove_object_from_event_stream_group`. İzleme `sys.dm_change_feed_log_scan_sessions` ve `sys.dm_change_feed_errors` üzerinden yapılır.

### Diğer

- **Bölüm 5** — `JSON_OBJECT` / `JSON_OBJECTAGG`'de `VALUE` anahtar kelimesi SQL Server'da yok; iki nokta kullanılır (`'key' : value`)
- **Bölüm 5** — `CAST('false' AS JSON)` Msg 13609 verir; JSON tipi kök seviyede skaler kabul etmez, `CAST(0 AS BIT)` kullanılmalı
- **Bölüm 12** — `REGEXP_MATCHES` sütunları: `match_id`, `start_position`, `end_position`, `match_value`, `substring_matches`. `match_position` yok
- **Bölüm 12** — Hesaplanan sütun eklendiği batch içinde indekslenemez; araya `GO` gerekir
- **Bölüm 2** — `sys.tables`'ta `is_ledger` yok; `ledger_type` / `ledger_type_desc` var
- **Bölüm 18** — `sys.databases`'te `is_change_tracking_on` yok; `sys.change_tracking_databases` ile join gerekir
- **Bölüm 20** — `sys.databases.is_link_to_synapse_enabled` 2025'te yok (Synapse Link kaldırıldı); sürümden bağımsız tespit `sys.all_columns` üzerinden yapılır
- **Bölüm 21** — `sys.dm_db_vector_indexes` CU7'de yok; metadata `sys.vector_indexes` katalog görünümünden okunur
- **Bölüm 23** — `JSON_OBJECT` içinde `true` sütun adı olarak yorumlanır; `CAST(1 AS BIT)` kullanılmalı
- **Bölüm 9** — `sys.dm_db_attestation_compute_capability` CU7'de yok (Azure SQL DMV'si); enclave durumu `sys.configurations`'tan okunur
- **Bölüm 10, 18** — Resource Governor örnekleri yeniden koşumda "already exists" ile düşüyordu; workload group'u pool'dan önce düşürecek şekilde idempotent hâle getirildi

---

## Kategori A — Çevresel kısıtlar (test ortamında düzeltilemez)

Kalan 31 hatanın tamamı bu kapsamdadır. Kitap metni doğrudur; script bir dış önkoşul ister.

**A1. Azure Blob Storage credential** — `ch07-01`, `ch07-02`, `ch07-03`, `ch07-04` (Msg 3201, 15530). `BACKUP TO URL` için Database Scoped Credential + Managed Identity gerekir.

**A2. Always On AG kurulu değil** — `ch08-01`, `ch08-02`, `ch08-04`. AG'li bir cluster gerekir.

**A3. Güvenlik altyapısı** — `ch09-01` (parola politikası), `ch09-02` (column encryption key / CMK), `ch09-05` (audit dosya yolu), `ch09-06` (Entra ID), `ch23-04` / `ch29-01` (database master key).

**A4. External model / REST endpoint kimlik bilgisi** — `ch13-01`, `ch13-04`, `ch22-01`, `ch22-02`, `ch22-03`, `ch22-04`, `ch24-02`, `ch24-03`, `ch29-03`. `sp_configure 'external rest endpoint enabled', 1` açık olsa da gerçek endpoint ve credential gerekir.

**A5. Full-Text Search kurulu değil** — `ch23-02`, `ch29-02` (Msg 7609). Container imajında full-text bileşeni yok.

**A6. Fabric Mirroring / hibrit** — `ch18-03`, `ch20-03`. Fabric workspace bağlantısı gerekir.

**A7. Platform / kasıtlı** — `ch11-01` Extended Events örneği Windows yolu kullanıyor (Linux container'da geçersiz). `ch10-03` `ABORT_QUERY_EXECUTION` hint'i **kasıtlı** olarak sorguyu durduruyor; örneğin amacı bu. `ch14-03`, `ch16-04` deadlock grafiği ve tSQLt; ikisi de dış kurulum/eşzamanlı oturum ister. `ch23-03` `ai.usp_hybrid_search` yordamı `ch23-01`'de oluşur, o da external model ister.

---

## Koşum yöntemi ve iki tuzak

Testler container'ın kendi `sqlcmd`'siyle koşuldu (`docker exec`).

1. **`-I` şart.** `sqlcmd` varsayılan olarak `QUOTED_IDENTIFIER` kapalı başlar; hesaplanan sütun ve filtered index içeren örnekler Msg 1934 ile düşer. Bu bir kitap hatası değil, koşucu ayarıdır — ilk koşumda 6 script bu yüzden yanlışlıkla FAIL göründü.
2. **`docker cp` öncesi `-u root` ile temizlik.** `docker cp` dosyaları root olarak yazar; sonraki `docker exec ... rm -rf` varsayılan kullanıcıyla çalıştığında sessizce başarısız olur ve `docker cp` iç içe dizin yaratır. Sonuç: script'ler bayat kopyadan koşar ve düzeltmeler hiç görünmez.

Ayrıca: CES'i (`sp_enable_event_stream`) bir veritabanında açtıysanız `DROP DATABASE` engellenir (Msg 3763). Test setup'ı veritabanını yeniden kuramaz ve tüm koşum "already exists" hatalarıyla kirlenir. Önce `sp_disable_event_stream`.

---

# Tarihçe — 2026-05-15 koşumu (CU4-GDR, Standard Edition, Windows)

**Tarih:** 2026-05-15
**Sürüm:** SQL Server 2025 RTM-CU4-GDR (KB5089899), build 17.0.4040.1, Standard Edition
**Kapsam:** 32 bölümün kod-ornekleri/ altındaki tüm .sql dosyaları
**Sonuç:** 81 script çalıştı / 29 OK / 52 FAIL / 10 boş bölüm (24-32 arası)

Bu liste topluluk geri bildirimleriyle birlikte sürekli güncellenir; v1.1 baskısı (Mart 2027) ile derli toplu yansır.

---

## Kategori A — Çevresel kısıtlar (test ortamında düzeltilemez, kitapta "bu özellik şu önkoşulu gerektirir" notu yeterli)

### A1. Enterprise Edition gerek
- `ch06-04` (online index Enterprise edition gerek — Msg 1712)
  - **Durum:** Bölüm 6'da zaten "2025 ile Standard'a açıldı" notu mevcut. Test instance'ımız Standard, online build çalışıyor. Bu özel script muhtemelen partition switch + online operation kombinasyonu kullanıyor; o kombinasyon hâlâ Enterprise. Kitap metni doğru, sadece script özel notla işaretlenmeli.

### A2. Always On AG / mirroring kurulu değil
- `ch08-01`, `ch08-02`, `ch08-04` (Msg 35208, 35221)
  - **Durum:** Always On AG kurulum yapılmadan DDL çalıştırılamaz. Bu testler AG mevcut bir cluster gerektirir. v1.1 hazırlığında AG-kurulu sandbox üzerinde teyit edilecek.
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
- **Kategori A**'nın tümü v1.1 hazırlığı sırasında yapılandırılmış instance (AG cluster, Enterprise edition, vb.) üzerinde yeniden koşacak.
- **Kategori C** bölüm 24-29 için kod örneği yazma işidir.

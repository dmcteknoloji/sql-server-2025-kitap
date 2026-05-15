# Çalıştırma Çıktısı Gömme Listesi

**Amaç:** `kontrol/test-runs/*.txt`'deki OK çıktılarını ilgili kitap bölümlerine `<div class="result-box">` olarak gömmek. `book.css`'te `.result-box` sınıfı tanımlı.

**Tamamlanan:**
- ch01-01 → bolum-1 (kronoloji) — `SELECT @@VERSION` çıktısı, sürüm doğrulama
- ch21-01 → bolum-21 (VECTOR tipi) — vector cast + boyut uyumsuzluk hatası

**Yapılacak (28 çıktı):**

| Test ID | Hedef bölüm | Önerilen başlık | Konu |
|---------|-------------|-----------------|------|
| ch01-02 | bolum-1 | Compatibility level davranışı | Compat level değişimleri |
| ch01-03 | bolum-1 | Yıllara göre eklenen özellikler | sys.columns/objects ile tarihçe |
| ch02-04 | bolum-2 | Preview features açma sözdizimi | `ALTER DATABASE SCOPED CONFIGURATION` |
| ch03-01 | bolum-3 | Sürüm sorgusu çıktısı | Edition + cu_level |
| ch03-02 | bolum-3 | Active sessions | sys.dm_exec_sessions |
| ch03-03 | bolum-3 | Configuration sorgusu | sys.configurations |
| ch04-01 | bolum-4 | Kurulum sonrası ilk sorgu | sp_helpdb |
| ch04-02 | bolum-4 | Filegroup yapısı | sys.database_files |
| ch04-03 | bolum-4 | Memory ayarları | sp_configure |
| ch04-04 | bolum-4 | TempDB dosya sağlığı | tempdb file layout |
| ch05-01 | bolum-5 | Temel CRUD çıktısı | INSERT/SELECT/UPDATE |
| ch05-02 | bolum-5 | JOIN + aggregate | window functions |
| ch05-05 | bolum-5 | Subquery, CTE, set ops | CTE örnekleri |
| ch06-01 | bolum-6 | Heap vs clustered | sys.indexes |
| ch06-03 | bolum-6 | Index fragmentation | sys.dm_db_index_physical_stats |
| ch08-03 | bolum-8 | AG sağlık DMV'leri | sys.dm_hadr_database_replica_states |
| ch09-04 | bolum-9 | DDM mask örneği | masked_columns + role |
| ch10-02 | bolum-10 | Query Store rapor | sys.query_store_runtime_stats |
| ch10-04 | bolum-10 | IQP feedback | adaptive joins / DOP feedback |
| ch10-05 | bolum-10 | OPPO etkinleştirme | optional parameter optimization |
| ch12-03 | bolum-12 | Error handling | THROW + TRY/CATCH |
| ch13-03 | bolum-13 | DAB konfigürasyon test | dab init çıktısı |
| ch13-05 | bolum-13 | Service Broker queue setup | CREATE QUEUE/SERVICE |
| ch17-01 | bolum-17 | Clustered columnstore demo | sys.column_store_row_groups |
| ch17-03 | bolum-17 | Batch mode on rowstore | execution mode görünümü |
| ch18-02 | bolum-18 | Resource Governor mirroring | mirroring workload group |
| ch20-03 | bolum-20 | Hybrid bağlantı testi | linked server bilgisi |

**Yapılış şablonu:** Her gömme için ilgili bölümün uygun teknik paragrafının sonuna şu HTML eklenir:

```html
<div class="result-box">
<span class="rb-caption">Çalıştırma çıktısı <span class="rb-source">kontrol/test-runs/chXX-NN.txt — bolum-XX/NN-konu.sql</span></span>
[buraya .txt'den ilgili çıktı bloğu — header + tipik 5-10 satır]
</div>
```

**Disiplin:**
- Sadece OK çıktı (Msg satırı içermeyen)
- Çıktı uzun ise sadece ilgili 5-10 satırı al, "..." ile kısalt
- Hassas veri (server, IP, kullanıcı adı, kurumsal DB adları) çıktıda hâlâ varsa önce `_known-issues.md` taraması tekrar koş
- Çıktının kaynak .sql dosya adı `rb-source` içinde belirtilir (okur scripti açıp inceleyebilsin)

**Faz 6 sonu hedef:** 30/30 OK çıktısı kitaba gömülü; FAIL çıktıları ya Kategori B düzeltmesinden sonra OK olur ya da Kategori A "bilinen kısıt" olarak kalır.

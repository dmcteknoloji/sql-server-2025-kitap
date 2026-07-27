# Değişiklik Notu

Bu kitabın sürüm geçişlerinin kümülatif kaydı. Aylık değişiklikler [`ERRATA.md`](./ERRATA.md)'de, büyük sürümler aşağıda.

Format: [Keep a Changelog](https://keepachangelog.com/) tarzı; [Semantic Versioning](https://semver.org/lang/tr/) prensipleri.

---

## [v1.0.3] — 27 Temmuz 2026

### CU7 + Temmuz güvenlik bandı güncellemesi

Kitap baseline'ı CU6'dan CU7'ye (KB5096981, 16 Temmuz 2026, build 17.0.4065.4) güncellendi. CU7, CU6 sonrası 10 düzeltme taşır. İki gün önce, 14 Temmuz 2026'da yayımlanan iki GDR — RTM bandı için KB5102333 (17.0.1125.2), CU bandı için CU6+GDR KB5101346 (17.0.4060.2) — yedi CVE kapattı.

#### Eklendi

- **Bölüm 9 (Güvenlik), yeni bölüm — "Yama bantları: GDR mi, CU mu?":** GDR ve CU servisleme bantlarının farkı, Temmuz 2026'nın iki bandı aynı hafta getirmesi ve yedi CVE'nin tablosu
- **Bölüm 9:** TLS 1.3'ü registry düzenlemeden açan trace flag (KB numarayı vermiyor — kitapta açıkça belirtildi); yalnızca TLS 1.3 etkinken SQL Server 2025 setup'ının başarısız olması; UCS ve Service Broker şifrelemesinin AES-256'ya çekilmesi; SSIS Message Queue Task'ta `BinaryMessageFormatter` desteğinin kaldırılması (kırıcı değişiklik)
- **Bölüm 12 (Modern T-SQL):** `JSON_MODIFY` merge ve düğüm offset bozulma düzeltmeleri; `ALTER JSON INDEX REORGANIZE` dump düzeltmesi
- **Bölüm 8 (Yüksek Erişilebilirlik):** read-intent secondary replica'larda aralıklı Msg 976 / 978 hataları
- **Bölüm 5 (T-SQL Temelleri):** `EDIT_DISTANCE` taşma koruması ve fuzzy fonksiyonlarının MAX tip kabul etmemesi (Msg 8116)
- **Bölüm 21 (Vector / DiskANN):** vector intrinsic'lerinde ve dinamik yönetim fonksiyonlarında bellek sızıntısı düzeltmesi
- **Bölüm 22 (AI_GENERATE_EMBEDDINGS):** `EXTERNAL MODEL` nesnelerinde hatalı kimlik bilgisi işleme kaynaklı istenmeyen izin devralması + izin gözden geçirme notu

#### Değiştirildi

- Bölüm 1, 2, 3: sürüm referansları, `@@VERSION` ve ShowPlan `Build` çıktıları CU7'ye (RTM-CU7, build 17.0.4065.4) güncellendi
- Bölüm 1'in sürüm çıktısı CU7 kurulu bir container'da yeniden koşturuldu; arşiv `kontrol/test-runs/ch01-01.txt`
- Ön bölüm baseline notu, künye, sözlük CU/build girişleri CU7'ye güncellendi
- Yol haritası: v1.1 kapsamı CU8-CU11 olarak güncellendi

#### Kod örneği düzeltmeleri (CU7'de yeniden koşuldu)

Tüm kod örnekleri CU7 kurulu bir instance'ta yeniden çalıştırıldı. Motor tarafından reddedilen ve düzeltilen maddeler:

- **Vector index salt-okunur kısıtı (yeni içerik):** vector index kurulu tablo DML kabul etmez (Msg 42231). Bölüm 21'e önkoşul, Bölüm 24'e RAG hattının "partili ritim" tasarımı olarak eklendi. `ALLOW_STALE_VECTOR_INDEX` SQL Server 2025 CU7'de yok
- **Clustered PK önkoşulu:** tek bir 4 baytlık `INT` sütun olmalı (Msg 42217); demo şemasındaki `chunk_id` `BIGINT` yerine `INT`
- **FP16 sözdizimi:** `WITH (PRECISION = 'half')` geçersiz (Msg 155); half precision sütun tipinde verilir — `VECTOR(1536, float16)`
- **"En az 100 satır" şartı:** Azure SQL / Fabric'teki yeni index sürümüne ait; CU7'de uygulanmıyor
- `JSON_OBJECT` / `JSON_OBJECTAGG`'de `VALUE` yerine iki nokta sözdizimi; `CAST('false' AS JSON)` yerine `CAST(0 AS BIT)`
- `REGEXP_MATCHES` sütun adı `match_position` değil `start_position`
- `sys.tables`'ta `is_ledger` değil `ledger_type`; `sys.dm_db_vector_indexes` CU7'de yok, `sys.vector_indexes` kullanılır
- Kilit bekleme sorgusu `sys.dm_tran_locks` ile join'e çevrildi; Resource Governor örneği idempotent hâle getirildi

#### Known issue

- `SESSION_CONTEXT` paralel plan'larda hatalı sonuç veya AV dump (CU5'ten devam)
- `MSDASQL` sağlayıcısı + provider string ile linked server sorguları Msg 7416 ile başarısız olabilir (CU6'dan devam)

#### Güvenlik

- CVE-2026-47295, CVE-2026-47296, CVE-2026-55002, CVE-2026-54116 (ayrıcalık yükseltme); CVE-2026-50468 (bilgi ifşası); CVE-2026-54117, CVE-2026-54118 (uzaktan kod çalıştırma) — 14 Temmuz 2026 GDR'leriyle kapatıldı
- CU7'nin kendi KB'sinde numaralı CVE listelenmedi; aynı MSMQ deserialization düzeltmesini taşır

---

## [v1.0.2] — 19 Haziran 2026

### CU6 güncellemesi

Kitap baseline'ı CU5'ten CU6'ya (KB5093421, 17 Haziran 2026, build 17.0.4055.5) güncellendi. CU6, CU5 sonrası 19 düzeltme taşır.

#### Eklendi

- **Bölüm 21 (Vector / DiskANN):** paralel vector index oluşturmada kaynak tükenmesi düzeltmesi notu; ayrıca `bcp` ile `vector(16)`/`vector(32)` bulk import/export ve sıkı TLS sertifika doğrulaması için `-H` / `-J` seçenekleri
- **Bölüm 9 (Güvenlik):** SSIS parola tabanlı şifrelemenin PBKDF2 SHA-256 / 100.000 iterasyona yükseltilmesi (SQL 2025 hedefli paketler; uyumlu SSDT/SSMS gerekir)

#### Değiştirildi

- Bölüm 1, 2, 3: sürüm referansları ve `@@VERSION` çıktıları CU6'ya (RTM-CU6, build 17.0.4055.5) güncellendi
- Ön bölüm baseline notu, künye, sözlük CU/build girişleri CU6'ya güncellendi
- Yol haritası: v1.1 kapsamı CU7-CU10 olarak güncellendi (CU6 artık v1.0.2'de)

#### CU6 diğer düzeltmeler (kitap kapsamında not düşüldü)

- JSON indeks sütununa `NULL` JSON dokümanı ekleme hatası düzeltildi
- `tempdb` alan muhasebesi düzeltmesi; `FULLTEXT_INDEX_VERSION` varsayılanı Azure SQL MI'de 2'ye çekildi
- SSIS paketlerinin `Encrypt=Strict` ile dağıtım/çalıştırma düzeltmesi; SNI SSL'de sıfır uzunluklu TLS record düzeltmesi

#### Known issue

- `SESSION_CONTEXT` paralel plan'larda hatalı sonuç (CU5'ten devam — Bölüm 9 uyarı kutusu geçerli)
- **Yeni:** `MSDASQL` (OLE DB Provider for ODBC) sağlayıcısı + provider string ile linked server sorguları daha sıkı bağlantı doğrulaması nedeniyle Msg 7416 ile başarısız olabilir

#### Güvenlik

- CU6'da numaralı yeni bir CVE yok; güvenlik tarafı SSIS PBKDF2 sertleştirmesi, TLS sertifika doğrulama seçenekleri ve sıfır uzunluklu TLS record düzeltmesiyle ilerledi

---

## [v1.0.1] — 25 Mayıs 2026

### CU5 güncellemesi

Kitap baseline'ı CU4'ten CU5'e (KB5084896, 20 Mayıs 2026, build 17.0.4045.5) güncellendi.

#### Eklendi

- **Bölüm 6 (Optimized Locking):** CU5 ile gelen `max lock manager cache memory (%)` konfigürasyonu — lock manager cache bellek üst sınırını yüzdesel olarak kontrol etme
- **Bölüm 9 (Güvenlik/RLS):** `SESSION_CONTEXT` paralel plan known issue uyarı kutusu — CU5'te belgelenen, paralel sorgu plan'larında hatalı sonuç veya access violation üretebilme sorunu

#### Değiştirildi

- Bölüm 1, 2, 3: sürüm referansları ve `@@VERSION` çıktıları CU5'e güncellendi
- Ön bölüm baseline notu, künye, sözlük CU girişleri CU5'e güncellendi
- Yol haritası: v1.1 kapsamı CU6-CU8 olarak daraltıldı (CU5 artık v1.0.1'de)

#### Güvenlik

- CVE-2026-40370: SSIS Web Service Task XXE açığı (file:// protokolü engellendi) — CU5 ve RTM GDR (KB5091223) ile düzeltildi
- `sp_help_spatial_geography_index` / `sp_help_spatial_geometry_index` SQL injection düzeltmesi

#### CU5 diğer yenilikler (kitap kapsamında not düşüldü)

- `FulltextIndexVersion2` database-scoped config ile etkinleştirme
- Change feed parametreleri `mssql.conf` ile yapılandırılabilir (Linux)
- In-Memory OLTP GC hash index scan CPU starvation düzeltmesi

---

## [v1.0.0] — 15 Mayıs 2026

### İlk yayın

Çağlar Özenç'in 7 ay süren yazımının sonucu. SQL Server 2025'in Türkçe başucu kitabının ilk basımı.

#### Eklendi

- **6 kısım × 32 bölüm × 11 rol için yol haritası**
  - Kısım I — Ortak Temeller (B1-5)
  - Kısım II — DBA Yolu (B6-11)
  - Kısım III — Geliştirici Yolu (B12-16)
  - Kısım IV — Veri/Analitik Yolu (B17-20)
  - Kısım V — AI/Mimari Yolu (B21-26)
  - Kısım VI — Türkiye Penceresi ve Gelecek (B27-32)
- **Arka bölüm:** 158 terim sözlüğü (TR/EN), birincil kaynak listesi (30+ URL), Changelog, Yazar/Yayıncı, Künye
- **Açılış:** Kapak, tam başlık, TOC (448 sayfa), Yazardan Önsöz, Kitabın Haritası
- **12 SVG diyagram** (kronoloji, modern mimari, HNSW, RAG, AI pipeline, AI-ready, regulation, rowgroup lifecycle, embedding pipeline, hybrid search, HTAP, MCP agent flow)
- **100+ T-SQL kod örneği** test edilmiş ve doğrulanmış (`kod-ornekleri/` repo'da)
- **Test koşum altyapısı:** `kontrol/run-tests.sh` credential maskeli batch runner
- **Build pipeline:** WeasyPrint 68.1 + cairosvg + Python 3.11 (HTML/CSS kaynaktan tek-PDF)

#### Baseline

- SQL Server 2025 RTM-CU4-GDR (KB5089899), build 17.0.4040.1
- Compatibility Level 170 default
- Preview kapsamı: vector indexes, Change Event Streaming, fuzzy matching

#### Mayıs 2026 ekosistem güncellemeleri (v1.0'a entegre)

- EF Core 11 native DiskANN vector indeks desteği (Nisan 2026)
- Fabric Eventstream otomatik Event Hub provisioning (2026 baharı)
- SQL MCP Server Data API Builder altında: RBAC + Key Vault + Azure Managed Redis + custom OAuth/Entra + OpenTelemetry

---

## [v0.95-beta] — 15 Mayıs 2026

### Lansman öncesi beta hazırlık

#### Değiştirildi
- Tüm bölüm HTML'leri Mayıs 2026 baseline'ına çekildi
- Stub bölümler (13, 14, 15, 17, 20, 25, 29) genişletildi
- Türkçe AI ekosistemi (bolum-29) Kumru/BGE-M3/Ollama/TURNA derinleştirmesi

#### Düzeltildi
- 29 kod örneği bug'ı Microsoft Learn ile çapraz kontrol edildi ve düzeltildi (vector function syntax, DMV sütun adları, sys.external_models yapısı, REGEXP_LIKE predicate kullanımı, BASE64_ENCODE binary tip zorunluluğu, JSON_MODIFY boolean ataması)

#### Eklendi
- Çalıştırma çıktısı kutu sınıfı (`<div class="result-box">`) — 30 OK çıktısı bölümlere gömüldü
- Preview uyarı kutusu sınıfı (`<div class="preview-warning">`) — bolum-19, 21'in başına
- Bölüm 28'e "Eylül 2026 uyum bandı" notu (EU AI Act 2 Ağustos geçişi)
- TOC sayfa numaraları dinamik senkronlandı (gerçek PDF sayfalarıyla)
- Künye (kolofon) arka bölüme
- Yeni 5 SVG diyagram (rowgroup-lifecycle, embedding-pipeline, hybrid-search, htap-mimari, mcp-agent-akisi)

---

## Sürüm yol haritası

| Sürüm | Hedef | İçerik |
|---|---|---|
| v1.0.x | Aylık | Errata + küçük güncellemeler (web sürüm) |
| **v1.0.1** | 25 Mayıs 2026 | CU5 güncellemesi — baseline CU5'e, Bölüm 6 ve 9 icerik eklendi |
| **v1.0.2** | 19 Haziran 2026 | CU6 güncellemesi — baseline CU6'ya, Bölüm 9 ve 21 içerik eklendi |
| **v1.1** | Mart 2027 | CU7-CU10 birikim + EU AI Act yüksek risk yansıması + topluluk errata/önerilerinden gelen iyileştirmeler |
| v1.2 | Eylül 2027 | KVKK cirosal ceza sonrası uyum güncellemesi + Türkçe AI ekosistemi yenilenmiş modeller |
| **v2.0** | 2028 | SQL Server vNext baskısı — mimari kısımlar yeniden ele alınır |

---

## Sürüm bildirimleri

GitHub Releases üzerinden bildirim almak için: [Watch, Releases only](../..)

Önemli güncellemeler ayrıca caglarozenc.com/kitap/changelog ve [@caglarozenc Twitter](https://twitter.com/caglarozenc) üzerinden duyurulur.

---

İletişim: caglarozenc@gmail.com · github.com/caglarozenc · dmcteknoloji.com

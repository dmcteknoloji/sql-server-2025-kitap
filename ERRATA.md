# Errata — SQL Server 2025: Herkes İçin, Her Rol İçin

**Sürüm:** v1.0.3 (27 Temmuz 2026)
**Son güncelleme:** 27 Temmuz 2026 — CU7 + Temmuz güvenlik bandı
**Kaynak:** [Issues `errata` etiketi](../../issues?q=label%3Aerrata)

Bu sayfa kitabın v1.0 baskısındaki düzeltmelerin canlı listesidir. Bir hata fark ettiyseniz [issue açın](../../issues/new?template=errata.md), `errata` etiketiyle. Doğrulandığında bu sayfaya işlenir; v1.1'de gövdeye yansır.

---

## Düzeltmeler

> Lansman gününde bu bölüm boş başlar. Okuyucu katkılarıyla aşağıdaki şablonda büyür:

```
### Sayfa NN / Bölüm M — [kısa konu]

**Sayfa NN, paragraf P:**

Yanlış: "[mevcut metin alıntı]"
Doğru: "[düzeltme]"

Kaynak: [Microsoft Learn URL veya KB makalesi]
Bildiren: [okuyucu adı / GitHub kullanıcısı]
Tarih: YYYY-MM-DD
GitHub issue: #XX
```

---

## Sürüm güncelleme bantları

### Mayıs 2026 — Lansman baseline (v1.0)

- SQL Server 2025 CU4 + KB5089899 güvenlik güncellemesi (build 17.0.4040.1)
- Compatibility Level 170 default
- Vector indexes PREVIEW kapsamında
- Standard Edition'da Resource Governor açık, online vector index build mevcut

### 25 Mayıs 2026 — CU5 (KB5084896) güncellemesi (v1.0.1)

CU5 20 Mayıs 2026'da yayımlandı (build 17.0.4045.5). Kitap v1.0.1 ile CU5 baseline'ına güncellendi.

**CU5 yenilikler:**
- `max lock manager cache memory (%)` konfigürasyonu — lock manager cache bellek üst sınırı kontrolü
- `FulltextIndexVersion2` database-scoped config ile etkinleştirme
- Change feed parametreleri `mssql.conf` ile yapılandırılabilir (Linux)

**CU5 güvenlik düzeltmeleri:**
- CVE-2026-40370: SSIS Web Service Task XXE açığı (file:// protokolü engellendi)
- `sp_help_spatial_geography_index` / `sp_help_spatial_geometry_index` SQL injection düzeltmesi

**CU5 known issue:**
- `SESSION_CONTEXT` paralel plan'larda hatalı sonuç veya access violation dump üretebilir (connection pooling session reset sonrası)

**Etkilenen bölümler:**
- Bölüm 1, 2, 3: sürüm referansları ve @@VERSION çıktıları CU5'e güncellendi
- Bölüm 6: `max lock manager cache memory (%)` notu eklendi
- Bölüm 9: SESSION_CONTEXT known issue uyarı kutusu eklendi

Kaynak: [KB5084896](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/cumulativeupdate5)

### 19 Haziran 2026 — CU6 (KB5093421) güncellemesi (v1.0.2)

CU6 17 Haziran 2026'da yayımlandı (build 17.0.4055.5); CU5 sonrası 19 düzeltme. Kitap v1.0.2 ile CU6 baseline'ına güncellendi.

**CU6 öne çıkan düzeltmeler:**
- Paralel vector index oluşturmada kaynak tükenmesi / performans düşüşü düzeltmesi
- `bcp` ile `vector(16)`/`vector(32)` bulk import/export + `-H`/`-J` sıkı TLS sertifika doğrulaması
- SSIS parola tabanlı şifreleme PBKDF2 SHA-256 / 100.000 iterasyona yükseltildi (uyumlu SSDT/SSMS gerekir)
- JSON indeks sütununa `NULL` JSON dokümanı ekleme hatası; `tempdb` alan muhasebesi; `FULLTEXT_INDEX_VERSION` varsayılanı (Azure SQL MI) düzeltmeleri

**CU6 known issue:**
- `SESSION_CONTEXT` paralel plan'larda hatalı sonuç (CU5'ten devam)
- **Yeni:** `MSDASQL` sağlayıcısı + provider string ile linked server sorguları Msg 7416 ile başarısız olabilir (daha sıkı bağlantı doğrulaması)

**Güvenlik:** CU6'da numaralı yeni CVE yok; SSIS PBKDF2 + TLS sertifika doğrulama + sıfır uzunluklu TLS record düzeltmeleriyle ilerledi.

**Etkilenen bölümler:**
- Bölüm 1, 2, 3: sürüm referansları ve @@VERSION çıktıları CU6'ya güncellendi
- Bölüm 9: SSIS PBKDF2 sertleştirmesi eklendi
- Bölüm 21: vector index paralel build düzeltmesi + `bcp` vector desteği eklendi

Kaynak: [KB5093421](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/cumulativeupdate6)

### 27 Temmuz 2026 — CU7 (KB5096981) + Temmuz güvenlik bandı (v1.0.3)

CU7 16 Temmuz 2026'da yayımlandı (build 17.0.4065.4); CU6 sonrası 10 düzeltme. İki gün önce, 14 Temmuz 2026'da iki GDR yayımlandı: RTM bandı için KB5102333 (build 17.0.1125.2), CU bandı için CU6+GDR KB5101346 (build 17.0.4060.2). Kitap v1.0.3 ile CU7 baseline'ına güncellendi.

**CU7 düzeltmeleri (10 madde):**
- Read-intent secondary replica'lara giden izleme sorguları aralıklı olarak Msg 976 / 978 ile başarısız oluyordu (High Availability)
- UCS şifrelemesi: TLS açıkça etkinleştirilmemişse AES-128 yerine AES-256
- TLS 1.3'ü registry düzenlemeden etkinleştiren trace flag eklendi (KB flag numarasını vermiyor)
- Service Broker dialog şifrelemesi AES-256'ya çekildi
- `EDIT_DISTANCE` fonksiyonuna taşma kaynaklı DoS'u engelleyen mantıksal sınır
- SSIS Message Queue Task'ta legacy `BinaryMessageFormatter` desteği kaldırıldı — **kırıcı değişiklik** (güvenilmeyen MSMQ mesajlarından RCE)
- Zaman dilimi hata günlüğü sırasında non-yielding scheduler düzeltmesi
- İç JSON indeks tablolarında istatistik varken `ALTER JSON INDEX REORGANIZE` dump üretimi düzeltildi
- Düğüm ebeveyn offset hesabı hatası `JSON_MODIFY` sırasında JSON bozuyordu
- `JSON_MODIFY` merge işlemi bozulması ve dump üretimi düzeltildi

**Temmuz 2026 GDR CVE'leri (KB5102333 / KB5101346, 14 Temmuz 2026):**
- CVE-2026-47295 — Elevation of Privilege
- CVE-2026-47296 — Elevation of Privilege
- CVE-2026-50468 — Information Disclosure
- CVE-2026-54116 — Elevation of Privilege (Windows MultiPoint Services)
- CVE-2026-54117 — Remote Code Execution
- CVE-2026-54118 — Remote Code Execution
- CVE-2026-55002 — Elevation of Privilege

Kapatılan açıklar: Message Queue Task'ta güvensiz deserialization (RCE); vector intrinsic'lerinde ve dinamik yönetim fonksiyonlarında bellek sızıntısı; replication ve SQL Agent saklı yordamlarında girdi doğrulama kaynaklı ayrıcalık yükseltme; `EXTERNAL MODEL` nesnelerinde hatalı kimlik bilgisi işleme (istenmeyen izin devralması).

**Kod örnekleri CU7'de yeniden koşuldu — bulunan ve düzeltilen kitap hataları:**

Vector index (Bölüm 21, 24), dördü de motorda doğrulandı:

| Bulgu | Kitapta olan | Doğru olan | Kanıt |
|---|---|---|---|
| Salt-okunur kısıtı | Hiç yer almıyordu | Vector index kurulu tablo DML kabul etmez; index düşür-yükle-yeniden kur döngüsü gerekir | Msg 42231 |
| Clustered PK tipi | "clustered primary key indeksli olmalı" | Tek bir 4 baytlık `INT` sütun olmalı; `BIGINT` reddedilir | Msg 42217 |
| FP16 sözdizimi | `WITH (PRECISION = 'half')` | Sütun tipinde: `VECTOR(1536, float16)` | Msg 155 |
| "En az 100 satır" | Önkoşul olarak yazılmıştı | Yeni index sürümüne (Azure SQL / Fabric) ait; SQL Server 2025 CU7'de tek satırla da kurulur | Canlı test |

`ALLOW_STALE_VECTOR_INDEX` SQL Server 2025 CU7'de ne veritabanı ne sunucu kapsamında mevcut değil. Learn'ün ilgili cümleleri Azure SQL / Fabric'teki yeni index sürümü içindir; belgeyi okurken hangi ürün için yazıldığına bakın.

Demo şeması düzeltildi: `ai.document_chunks.chunk_id` `BIGINT` → `INT` (aksi hâlde vector index örneği hiç çalışmıyordu).

Kod örneği düzeltmeleri:

- Bölüm 5 — `JSON_OBJECT` / `JSON_OBJECTAGG`: `VALUE` anahtar kelimesi SQL Server'da yok, iki nokta kullanılır (`'key' : value`)
- Bölüm 5 — `CAST('false' AS JSON)` Msg 13609 verir; JSON tipi kök seviyede skaler kabul etmez, `CAST(0 AS BIT)` kullanılmalı
- Bölüm 12 — `REGEXP_MATCHES` sütunları: `match_id`, `start_position`, `end_position`, `match_value`, `substring_matches`. `match_position` diye bir sütun yok
- Bölüm 12 — Hesaplanan sütun eklendiği batch içinde indekslenemez; araya `GO` gerekir
- Bölüm 2 — `sys.tables`'ta `is_ledger` sütunu yok; `ledger_type` / `ledger_type_desc` var
- Bölüm 25 — `request_session_id` / `resource_type` / `request_mode` sütunları `sys.dm_tran_locks`'a aittir, `sys.dm_os_waiting_tasks`'a değil; ikisi join edilmeli
- Bölüm 21 — `sys.dm_db_vector_indexes` CU7'de yok (Learn'de belgeli, yeni index sürümü için); metadata `sys.vector_indexes` katalog görünümünden okunur
- Bölüm 10 — Resource Governor örneği yeniden koşumda "already exists" ile düşüyordu; idempotent hâle getirildi

**CU7 known issue (ikisi de devam):**
- `SESSION_CONTEXT` paralel plan'larda hatalı sonuç veya AV dump (CU5'ten devam)
- `MSDASQL` sağlayıcısı + provider string ile linked server sorguları Msg 7416 ile başarısız olabilir (CU6'dan devam)

**Etkilenen bölümler:**
- Bölüm 1, 2, 3: sürüm referansları, `@@VERSION` ve ShowPlan `Build` çıktıları CU7'ye güncellendi
- Bölüm 5: `EDIT_DISTANCE` taşma koruması + MAX tip sınırı (Msg 8116)
- Bölüm 8: read-intent secondary'lerde aralıklı 976/978 hataları
- Bölüm 9: TLS 1.3 trace flag, TLS 1.3-only setup sınırı, UCS + Service Broker AES-256, SSIS `BinaryMessageFormatter` kaldırılması; yeni bölüm "Yama bantları: GDR mi, CU mu?" + CVE tablosu
- Bölüm 12: `JSON_MODIFY` bozulma düzeltmeleri + `ALTER JSON INDEX REORGANIZE`
- Bölüm 21: vector intrinsic bellek sızıntısı düzeltmesi
- Bölüm 22: `EXTERNAL MODEL` kimlik bilgisi işleme açığı + izin gözden geçirme notu

Kaynak: [KB5096981](https://support.microsoft.com/en-us/servicing/sql/sql-server-2025/cumulative-update/kb5096981-cu7) · [KB5101346](https://support.microsoft.com/help/5101346) · [KB5102333](https://support.microsoft.com/help/5102333)

### 2 Ağustos 2026 — EU AI Act yüksek risk yükümlülükleri

- Bölüm 28'e uyum bandı: yüksek risk sınıflandırma + GPAI dokümantasyon yükümlülükleri + ulusal denetleyici otoritelerin yetki devri
- KVKK Kurulu yeni çıkarımsal AI rehberi: [link]
- Notebook + Python kodu ile uyum kontrolü örnekleri (Eylül 2026 web sürümünde)

### [Tarih] — Vector index GA olduğunda

- Bölüm 21, 22, 23, 24'teki "PREVIEW" notları kaldırılır
- `CREATE VECTOR INDEX` sözdizimi son hâline alınır
- v1.1 ana baskıya hazırlık başlar

---

## Bilinen kısıtlar (Mayıs 2026 baseline)

Bu kısıtlar v1.0'da kabul edildi; çoğu çevresel veya zaman bağımlı. v1.1'de yeniden ele alınır.

| Konu | Bölüm | Açıklama |
|---|---|---|
| Vector indexes PREVIEW | 21, 22, 23 | `PREVIEW_FEATURES = ON` gerek; API'ler değişebilir |
| CES PREVIEW | 19 | `sys.sp_enable_event_stream` ile etkinleştirilir |
| ONNX local runtime | 22 | Mayıs 2026'da Windows üzerinde önerilir; Linux destek CU bağımlı |
| EF Core 11 native DiskANN | 15, 22 | Nisan 2026'da geldi; bazı API'ler oturma sürecinde |
| Synapse Link kaldırıldı | 20 | Mevcut kurulumlar Fabric Mirroring'e taşınmalı |

---

## Hata bildirme

GitHub'da bir issue açın: [Issues → New → Errata template](../../issues/new?template=errata.md)

Form:
- Sayfa numarası
- Paragraf/satır referansı
- Mevcut metin (alıntı)
- Önerilen düzeltme
- Kaynak (Microsoft Learn / KB / dokümantasyon link)

Doğrulandığında bu sayfaya işlenir; haftalık olarak Twitter/X'te özet paylaşılır; v1.1'de gövdeye yansır.

---

## Teşekkürler

Okuyucu katkısıyla büyüyen bu sayfa, kitabın canlı yayın karakterinin somut belgesidir.

**v1.0.x katkıda bulunanlar:**

_(Lansman sonrası okur isimleri buraya işlenir.)_

---

İletişim: caglarozenc@gmail.com · github.com/caglarozenc · dmcteknoloji.com

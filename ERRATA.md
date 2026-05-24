# Errata — SQL Server 2025: Herkes İçin, Her Rol İçin

**Sürüm:** v1.0.1 (25 Mayıs 2026)
**Son güncelleme:** 25 Mayıs 2026 — CU5 güncellemesi
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

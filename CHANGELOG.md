# Değişiklik Notu

Bu kitabın sürüm geçişlerinin kümülatif kaydı. Aylık değişiklikler [`ERRATA.md`](./ERRATA.md)'de, büyük sürümler aşağıda.

Format: [Keep a Changelog](https://keepachangelog.com/) tarzı; [Semantic Versioning](https://semver.org/lang/tr/) prensipleri.

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
- **Build pipeline:** WeasyPrint 68.1 + cairosvg + Python 3.11 (HTML/CSS → tek-PDF)

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
| **v1.1** | Mart 2027 | CU6-CU8 birikim + EU AI Act yüksek risk yansıması + topluluk errata/önerilerinden gelen iyileştirmeler |
| v1.2 | Eylül 2027 | KVKK cirosal ceza sonrası uyum güncellemesi + Türkçe AI ekosistemi yenilenmiş modeller |
| **v2.0** | 2028 | SQL Server vNext baskısı — mimari kısımlar yeniden ele alınır |

---

## Sürüm bildirimleri

GitHub Releases üzerinden bildirim almak için: [Watch → Releases only](../..)

Önemli güncellemeler ayrıca caglarozenc.com/kitap/changelog ve [@caglarozenc Twitter](https://twitter.com/caglarozenc) üzerinden duyurulur.

---

İletişim: caglarozenc@gmail.com · github.com/caglarozenc · dmcteknoloji.com

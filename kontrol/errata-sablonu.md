# Errata — SQL Server 2025: Herkes İçin, Her Rol İçin

**Sürüm:** v1.0 (20 Haziran 2026)
**Son güncelleme:** [otomatik]
**Kaynak:** github.com/caglarozenc/sql-server-2025-kitap/issues etiketli `errata`

Bu sayfa kitabın v1.0 baskısında çıkan hatalar ve düzeltmelerinin canlı listesidir. Okuyucu bir hata fark ettiğinde GitHub issue açar; doğrulandığında bu sayfaya işlenir; v1.1'de gövdeye yansır.

---

## v1.0.x güncellemeleri (kümülatif)

### Sayfa 11 / Bölüm 1 — kronoloji [örnek format]

**Sayfa 11, paragraf 2:**

> Yanlış: "SQL Server 1989'da OS/2 1.0 üzerinde piyasaya çıktı"
> Doğru: "SQL Server 1989'da OS/2 1.0 üzerinde piyasaya çıktı, ilk sürüm aslında 1988 Eylül'ünde duyurulmuş ve 1989 Nisan'ında satışa sunulmuştur."
>
> **Bildiren:** [okuyucu adı]
> **Tarih:** [tarih]
> **GitHub issue:** #XX

---

### Sayfa NN / Bölüm M — [konu] [şablon]

**Sayfa NN, paragraf P:**

> Yanlış: "[mevcut yanlış cümle veya kod]"
> Doğru: "[düzeltme]"
>
> **Bildiren:** [okuyucu]
> **Tarih:** [tarih]
> **GitHub issue:** #XX

---

## Sürüm güncelleme bantları

### Mayıs 2026 — Lansman baseline
- SQL Server 2025 CU4 + KB5089899 güvenlik güncellemesi (build 17.0.4040.1)
- Compatibility Level 170 default
- Vector indexes PREVIEW kapsamında

### [Tarih] — CU5 yayını sonrası
[Şablon: CU5 ne getirdi → kitabın hangi bölümlerini etkiliyor → kısa düzeltme satırları]

### 2 Ağustos 2026 — EU AI Act yüksek risk yükümlülükleri
- Bölüm 28'e uyum bandı eklendi: yüksek risk sınıflandırma + GPAI dökümantasyon yükümlülükleri
- KVKK Kurulu çıkardığı yeni rehber: [link]

### [Tarih] — Vector index GA olduğunda
- Bölüm 21, 22, 23, 24'teki "PREVIEW" notları kaldırılır
- API değişiklikleri yansıtılır
- v1.1 hazırlığı başlar

---

## Bilinen kısıtlar (Mayıs 2026 baseline)

Bu kısıtlar v1.0'da kabul edildi; çoğu çevresel veya zaman bağımlı. v1.1'de yeniden ele alınır.

| Konu | Bölüm | Açıklama |
|---|---|---|
| Vector indexes PREVIEW | 21, 22, 23 | `ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON` gerek; API'ler değişebilir |
| CES PREVIEW | 19 | Aynı şekilde preview features açık olmalı |
| ONNX local runtime sözdizimi | 22 | Mayıs 2026 itibariyle Windows üzerinde önerilir; Linux son CU notlarına göre değişir |
| EF Core 11 native DiskANN | 15, 22 | Nisan 2026'da geldi; bazı API'ler oturma sürecinde |
| Synapse Link kaldırıldı | 20 | Mevcut kurulumlar Fabric Mirroring'e taşınmalı (kitap bu yolu açar) |

---

## Hata bildirme yolu

GitHub'da bir issue açın:

1. Repo: github.com/caglarozenc/sql-server-2025-kitap
2. Issue başlığı: "Errata sayfa NN — kısa açıklama"
3. Etiket: `errata`
4. Şablon:
   - Sayfa numarası
   - Paragraf / satır referansı (PDF tıklanabilir bookmark)
   - Mevcut metin (alıntı)
   - Önerilen düzeltme
   - Kaynak (Microsoft Learn / KB / dökümantasyon link)

Doğrulandığında bu sayfaya işlenir; haftalık olarak Twitter'da özet paylaşılır; v1.1'de gövdeye yansır.

---

## Teşekkürler

Okuyucu katkısıyla büyüyen bu sayfa, kitabın canlı yayın karakterinin somut belgesidir. Her errata bildirimi v1.1'e doğru yol gösterir.

Teşekkürler:
- [İsim] — sayfa NN düzeltmesi
- [İsim] — Bölüm M konusu açıklığa kavuşturma
- [İsim] — kod örneği iyileştirmesi

---

İletişim: caglarozenc@gmail.com · github.com/caglarozenc · dmcteknoloji.com

# SQL Server 2025: Herkes İçin, Her Rol İçin

> Türkçe SQL Server 2025 başucu kitabı — kod örnekleri, errata, topluluk Q&A

[![Latest release](https://img.shields.io/badge/release-v1.0.1-blue)](../../releases)
[![Book PDF](https://img.shields.io/badge/PDF-v1.0.1%20Mayıs%202026-green)](https://caglarozenc.com/kitap/sqlserver2025)
[![Errata](https://img.shields.io/badge/errata-canli-orange)](./ERRATA.md)
[![License](https://img.shields.io/badge/lisans-CC%20BY--NC--SA%204.0%20%2B%20MIT-lightgrey)](./LICENSE)

**Yazar:** Çağlar Özenç · Microsoft Data Platform MVP
**Yayıncı:** DMC Bilgi Teknolojileri · İstanbul
**Sürüm:** v1.0.1 (25 Mayıs 2026)
**Baseline:** SQL Server 2025 CU5 (KB5084896) · build 17.0.4045.5 · Compatibility Level 170

> **Repo durumu**
> - v1.0 yayında — PDF + EPUB + web sürümü tamamen ücretsiz (CC BY-NC-SA 4.0)
> - 32 bölüm tam, 448 sayfa, 158 terim sözlük, 12 diyagram
> - 100+ T-SQL örneği gerçek SQL Server 2025 instance'ında test edilmiş
> - Errata akışı topluluk-tabanlı, sürekli açık ([ERRATA.md](./ERRATA.md))
> - v1.0.x aylık küçük güncellemeler · v1.1 ana baskı Mart 2027 hedefi

---

## Kitabı indir

📖 **PDF (ücretsiz):** [GitHub Releases → Latest](../../releases/latest)
🌐 **Landing sayfası:** [caglarozenc.com/kitap/sqlserver2025](https://caglarozenc.com/kitap/sqlserver2025) — kitap detayları, içerikler, yol haritası
📚 **Fiziksel baskı (700 ₺, opsiyonel destekçi):** 448 sayfa ofset ciltli edition, Türkiye kargo + ambalaj dahil. PDF/EPUB zaten ücretsiz; fiziksel kopya eseri rafta görmek isteyen ve topluluk yayın bakımına destekçi katkı sunmak isteyen okur içindir. [DMC ile iletişime geçin](https://dmcteknoloji.com/iletisim)

## Bu repo'da ne var?

```
.
├── kod-ornekleri/        T-SQL örnekleri (test edilmiş)
│   ├── bolum-01..26/     Teknik bölümlerin .sql dosyaları
│   ├── bolum-29/         Türkçe AI ekosistemi örnekleri
│   └── _ortak/           Setup script + demo veritabanı
│                         (Bölüm 27, 28, 30-32 metin ağırlıklıdır, kod gerektirmez)
├── kontrol/
│   ├── kod-test-rehberi.md  SQL Server 2025 instance üstünde test koşum playbook'u
│   ├── run-tests.sh         Toplu test koşucusu (credential maskeli)
│   └── test-runs/
│       └── _known-issues.md Bilinen sorunlar kataloğu (şeffaf liste)
├── README.md             (bu dosya)
├── CONTRIBUTING.md       Katkı kuralları
├── ERRATA.md             v1.0 düzeltmeleri (okuyucu katkısıyla büyür)
├── CHANGELOG.md          Sürüm geçişleri
└── LICENSE               CC BY-NC-SA 4.0 (metin) + MIT (kod)
```

**Kitap içeriği** (HTML kaynak, build pipeline) ayrı tutulur; bu repo **kod örnekleri + topluluk altyapısı** odaklıdır.

---

## Hızlı başlangıç

### Kod örneklerini çalıştır

```bash
# 1. SQL Server 2025 instance hazır olsun (CU5+ önerilir)
# 2. Demo veritabanını kur
sqlcmd -S <server> -U <user> -P <pwd> -d master -C \
       -i kod-ornekleri/_ortak/00-demo-veritabani.sql

# 3. Test runner için env vars ayarla (terminalde, satır başında BOŞLUK bırak)
 export SQLCMDSERVER='<server>'
 export SQLCMDUSER='<user>'
 export SQLCMDPASSWORD='<pwd>'
 export SQLCMDDBNAME='demo'

# 4. Tek bir bölümün örneklerini koştur
./kontrol/run-tests.sh bolum-21

# 5. Tüm bölümler
./kontrol/run-tests.sh
```

Çıktılar `kontrol/test-runs/chXX-NN.txt` — hassas bilgiler otomatik maskelidir.

Detaylı playbook: [`kontrol/kod-test-rehberi.md`](./kontrol/kod-test-rehberi.md)

### Hata bildirme

Kitapta bir hata mı buldun?

1. [Issue aç](../../issues/new) `errata` etiketiyle
2. Sayfa numarası + alıntı + önerilen düzeltme + (varsa) Microsoft Learn referansı
3. Doğrulandığında [`ERRATA.md`](./ERRATA.md)'ye işlenir; v1.1'de gövdeye yansır

### Soru sormak

[Discussions](../../discussions) üzerinden Q&A kategorisi. Topluluk yanıtı + kitap referansı + Microsoft Learn linki ile birlikte.

---

## Kitap nedir, kim için?

SQL Server 2025 Kasım 2025'te Microsoft Ignite'da genel kullanıma sunuldu. Vector veri tipi, DiskANN indeks, AI_GENERATE_EMBEDDINGS, doğal dil arayüzü ve SQL MCP Server T-SQL'in içine indi. Veri artık sadece BT'nin işi değil.

Bu kitap 11 rol için ayrı yol haritalarıyla yazıldı:

- **Öğrenci / yeni başlayan**
- **DBA**
- **Database Developer**
- **Data Engineer**
- **Data Analyst**
- **Data Scientist**
- **Solution / Data Architect**
- **Sistem Yöneticisi**
- **Network Yöneticisi**
- **Danışman**
- **C-Level** (CTO, CIO, CDO, CISO)

**Hacim:** ~450 sayfa · 32 bölüm · 6 kısım · 158 terim sözlük · 12 diyagram · 100+ T-SQL örneği

---

## Yapı (6 kısım × 32 bölüm)

| Kısım | Başlık | Bölüm | Hedef okur |
|---|---|---|---|
| I | Ortak Temeller | 1-5 | Herkes |
| II | DBA Yolu | 6-11 | DBA, Sistem Yöneticisi |
| III | Geliştirici Yolu | 12-16 | Database Dev, Backend Dev |
| IV | Veri/Analitik Yolu | 17-20 | Data Engineer, Analyst |
| V | AI/Mimari Yolu | 21-26 | Architect, Data Scientist |
| VI | Türkiye Penceresi | 27-32 | Danışman, C-Level |

Detaylı içerik: [caglarozenc.com/kitap/](https://caglarozenc.com/kitap/)

---

## Sürüm yol haritası

| Sürüm | Tarih | İçerik |
|---|---|---|
| **v1.0** | 15 Mayıs 2026 | İlk yayın · CU4-GDR baseline |
| **v1.0.1** | 25 Mayıs 2026 | CU5 güncellemesi · baseline CU5'e |
| v1.0.x | Aylık | Errata + küçük güncellemeler |
| **v1.1** | Mart 2027 | CU6-CU8 + EU AI Act yüksek risk yansıması |
| v1.2 | Eylül 2027 | KVKK cirosal ceza sonrası uyum |
| **v2.0** | 2028 | SQL Server vNext baskısı |

Detaylı: [`CHANGELOG.md`](./CHANGELOG.md)

---

## Niye ücretsiz?

Bu kitap **CC BY-NC-SA 4.0** lisansı altında ücretsiz dağıtılır. Türkçe SQL Server 2025 kapsamlı kaynak yokken bunu satışla sınırlamak topluluğa karşı bir kayıp olurdu. Yazar ve yayıncı gelirini kitap satışından değil DMC'nin kurumsal danışmanlık, eğitim ve atölyelerinden alır — kitap, bu hizmetlerin altyapısı; topluluğa armağan.

---

## Katkıda bulun

Üç katkı yolu:

1. **Errata bildir** — hatayı bulduysan issue aç
2. **Kod örneği geliştir** — PR ile yeni .sql ekle veya mevcut bir tanesini iyileştir
3. **Sözlüğe terim öner** — Türkçe SQL/AI terimleri Discussions'da tartış

**Pull request kabul kriterleri:**

- Her teknik iddia Microsoft Learn referansı ile bağlı
- Kod örneği gerçek SQL Server 2025'te koşturulmuş
- Türkçe sade dil; jargon yığını yok
- Emoji/icon/ok karakteri yok

Detaylı: [`CONTRIBUTING.md`](./CONTRIBUTING.md)

---

## İletişim

- **Yazar:** caglarozenc@gmail.com · [caglarozenc.com](https://caglarozenc.com)
- **Yayıncı:** [dmcteknoloji.com](https://dmcteknoloji.com) · İstanbul
- **Twitter/X:** @caglarozenc
- **LinkedIn:** linkedin.com/in/caglarozenc

---

## Lisans

- Kitabın metni ve diyagramlar: **CC BY-NC-SA 4.0** (atıf + ticari olmayan kullanım + benzer paylaş)
- Kod örnekleri (`kod-ornekleri/` altındaki tüm `.sql` ve script'ler): **MIT** (ticari kullanım dahil serbest)
- Microsoft Learn alıntıları: Microsoft'un kendi lisans koşulları (CC BY 4.0 dahil)

Detaylı: [`LICENSE`](./LICENSE)

**Marka beyanları:** SQL Server, Microsoft, Azure, Microsoft Fabric, Visual Studio, .NET — Microsoft Corporation'ın tescilli markaları. OpenAI, ChatGPT — OpenAI Inc. Claude — Anthropic PBC. Google, Gemini — Google LLC.

---

## Teşekkürler

**Topluluk:** Microsoft Türkiye veri platformu topluluğu, Microsoft MVP topluluğu, Türkiye SQL Server kullanıcı grupları. Errata ve iyileştirme önerileri için issue açan herkes künyede teşekkür listesinde yer alır.

**Referans:**

- Bob Ward — "SQL Server 2025 Unveiled" (Apress, 2025) — İngilizce kanonik referans
- Türkçe SQL Server alanında yıllardır kitap, blog, video ve eğitim üreten tüm yazarlara — Türkçe veri yayıncılığı geleneğine emek verenler
- Microsoft Learn dokümantasyon ekibi

DMC Bilgi Teknolojileri'nin yedi yıllık kurumsal danışmanlık tecrübesi bu kitabın saha damarını besler.

---

*"SQL artık sadece BT'nin işi değil. Bu kitap on bir rol için yazıldı çünkü 2025 sonrası dünyada artık tek bir 'kullanıcı' yok; her rol kendi sözlüğünü konuşur, kendi sorusunu sorar, kendi cevabını ister."*

— Çağlar Özenç, 15 Mayıs 2026

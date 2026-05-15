# SQL Server 2025: Herkes İçin, Her Rol İçin

> Türkçe SQL Server 2025 başucu kitabı — kod örnekleri, errata, topluluk Q&A

[![Latest release](https://img.shields.io/badge/release-v1.0-blue)](../../releases)
[![Book PDF](https://img.shields.io/badge/PDF-v1.0%20Haziran%202026-green)](https://caglarozenc.com/kitap/sqlserver2025)
[![Errata](https://img.shields.io/badge/errata-canli-orange)](./ERRATA.md)
[![License](https://img.shields.io/badge/lisans-CC%20BY--NC--SA%204.0%20%2B%20MIT-lightgrey)](./LICENSE)

**Yazar:** Çağlar Özenç · Microsoft Data Platform MVP
**Yayıncı:** DMC Bilgi Teknolojileri · İstanbul
**Sürüm:** v1.0 (Haziran 2026)
**Baseline:** SQL Server 2025 RTM-CU4-GDR (KB5089899) · build 17.0.4040.1 · Compatibility Level 170

---

## Kitabı indir

📖 **PDF (ücretsiz):** [GitHub Releases → Latest](../../releases/latest)
🌐 **Web sürüm (ücretsiz):** [caglarozenc.com/kitap/sqlserver2025](https://caglarozenc.com/kitap/sqlserver2025)
📚 **Fiziksel baskı (250 ₺, opsiyonel destekçi):** [dmcteknoloji.com/kitap](https://dmcteknoloji.com/kitap)

## Bu repo'da ne var?

```
.
├── kod-ornekleri/        Her bölümün T-SQL örnekleri (test edilmiş)
│   ├── bolum-01..32/     32 bölüm × 2-6 .sql per bölüm
│   └── _ortak/           Setup script + demo veritabanı
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
# 1. SQL Server 2025 instance hazır olsun (CU4+ önerilir)
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

Detaylı içerik: [caglarozenc.com/kitap/icerik](https://caglarozenc.com/kitap/icerik)

---

## Sürüm yol haritası

| Sürüm | Tarih | İçerik |
|---|---|---|
| **v1.0** | Haziran 2026 | İlk yayın · CU4-GDR baseline |
| v1.0.x | Aylık | Errata + küçük güncellemeler |
| **v1.1** | Mart 2027 | CU5-CU8 + EU AI Act yüksek risk yansıması |
| v1.2 | Eylül 2027 | KVKK cirosal ceza sonrası uyum |
| **v2.0** | 2028 | SQL Server vNext baskısı |

Detaylı: [`CHANGELOG.md`](./CHANGELOG.md)

---

## Niye ücretsiz?

Bu kitap **CC BY-NC-SA 4.0** lisansı altında ücretsiz dağıtılır. Türkçe SQL Server 2025 kapsamlı kaynak yokken bunu satışla sınırlamak topluluğa karşı bir kayıp olurdu. Yazar ve yayıncı gelirini kitap satışından değil DMC'nin kurumsal danışmanlık, eğitim ve atölyelerinden alır — kitap, bu hizmetlerin altyapısı; topluluğa armağan.

İstersen [GitHub Sponsors](https://github.com/sponsors/caglarozenc) üzerinden destekçi olabilirsin; künyede teşekkür listesinde yer alırsın. Hiç zorunlu değil.

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

**Beta okuyucular:** [İsim listesi — beta okur turu sonrası]

**Topluluk:** Microsoft Türkiye veri platformu topluluğu, Microsoft MVP topluluğu, Türkiye SQL Server kullanıcı grupları

**Referans:**

- Bob Ward — "SQL Server 2025 Unveiled" (Apress, 2025) — İngilizce kanonik referans
- Yaşar Gözüdeli — "MS SQL Server" (Seçkin Yayınevi) — Türkçe başucu geleneğine selam
- Microsoft Learn dokümantasyon ekibi

DMC Bilgi Teknolojileri'nin yedi yıllık kurumsal danışmanlık tecrübesi bu kitabın saha damarını besler.

---

*"SQL artık sadece BT'nin işi değil. Bu kitap on bir rol için yazıldı çünkü 2025 sonrası dünyada artık tek bir 'kullanıcı' yok; her rol kendi sözlüğünü konuşur, kendi sorusunu sorar, kendi cevabını ister."*

— Çağlar Özenç, Haziran 2026

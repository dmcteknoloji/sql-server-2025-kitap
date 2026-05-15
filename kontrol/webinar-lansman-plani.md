# Lansman Webinar Planı — 20 Haziran 2026 Cumartesi

**Tarih:** 20 Haziran 2026 Cumartesi, **18:00–19:30 (TSİ)**
**Format:** Online (Zoom / Microsoft Teams Webinar / YouTube Live)
**Kapasite:** 500 katılımcı (Türkiye SQL Server topluluğu + MVP'ler + DMC müşteri ağı)
**Kayıt:** caglarozenc.com/kitap/webinar → e-posta yakalama formu
**Ücret:** Ücretsiz (lansman etkinliği)
**Dil:** Türkçe

---

## Etkinlik akışı (90 dakika)

| Süre | Bölüm | Sunum |
|---|---|---|
| 18:00–18:05 | Açılış | DMC moderatör hoşgeldin, gündem, teknik bilgi (Q&A nasıl kullanılır) |
| 18:05–18:15 | Niye bu kitap? | Çağlar: yazım hikâyesi, neden Türkçe, neden 7 ay |
| 18:15–18:30 | SQL Server 2025'in dönüşümü | Vector, AI_GENERATE_*, MCP Server, Copilot — kısa demo ile |
| 18:30–18:50 | Canlı demo: T-SQL ile RAG | `AI_GENERATE_CHUNKS` → `AI_GENERATE_EMBEDDINGS` → `VECTOR_SEARCH` → LLM çağrısı; uçtan uca tek T-SQL session'da |
| 18:50–19:00 | 11 rol için yol haritası | Kitabın yapısı; "siz hangi yoldasınız" çerçevelemesi |
| 19:00–19:20 | Q&A | Katılımcıların chat sorularına Çağlar + DMC ekibinden uzman cevap |
| 19:20–19:30 | Kapanış + Çekiliş | İmzalı baskı çekilişi (5 kişi); satın alma + GitHub repo + topluluk daveti |

---

## Hazırlık checklisti

### 1 hafta önce (13 Haziran)
- [ ] Webinar platform kurulumu (Zoom Webinar veya MS Teams)
- [ ] Kayıt sayfası (caglarozenc.com/kitap/webinar) canlı
- [ ] Davet duyurusu LinkedIn + Twitter + MVP topluluğu
- [ ] Demo ortamı: SQL Server 2025 test instance, Ada2Embeddings model, demo veritabanı dolu
- [ ] Slayt deck: 12-15 slayt (kitabın kapağı, tez, yapı, demo, satın al, GitHub, teşekkür)

### 3 gün önce (17 Haziran)
- [ ] Demo provası — uçtan uca RAG sorgusu çalışır mı, vector index hazır mı
- [ ] Yedek plan: demo çökerse statik ekran görüntüleri
- [ ] Test mikrofon + kamera + paylaşım
- [ ] Çekiliş kuralı net: "kayıt olan + sonuna kadar kalan + Q&A'da soru soran"

### Etkinlik günü (20 Haziran)
- [ ] 17:30 platform açık, host + moderator hazır
- [ ] 17:45 katılımcılar bekleme odasında
- [ ] 18:00 canlı yayın
- [ ] Q&A esnasında DMC ekibinden 1 kişi chat moderatör olarak takip ediyor
- [ ] 19:30 sonrası: kayıt YouTube'a yüklenir (3 saat içinde), katılımcılara takip e-postası

### Etkinlik sonrası (21-22 Haziran)
- [ ] Tüm kayıt e-posta listesine "kitabı satın al" CTA'lı follow-up
- [ ] YouTube'a tam etkinlik kaydı
- [ ] Slayt deck PDF olarak indirilebilir
- [ ] Çekiliş kazananlarına imzalı baskı kargo
- [ ] LinkedIn ve Twitter'da etkinlik özeti + en iyi soru cevapları thread

---

## Slayt deck içeriği (12 slayt)

1. **Açılış** — Başlık + kapak görseli + tarih
2. **Çağlar tanıtım** — MVP + DMC + 20 yıl saha
3. **Tez** — "SQL artık sadece BT'nin işi değil"
4. **SQL 2025 ne getirdi?** — Vector + AI_GENERATE_* + MCP + Copilot
5. **Niye Türkçe kitap?** — Türkiye topluluğu büyük, Türkçe kapsamlı kaynak yok
6. **Kitabın yapısı** — 6 kısım × 32 bölüm × 11 rol grid
7. **Demo başlangıcı** — VECTOR(1536) sütun + DiskANN indeks
8. **Demo: chunking + embedding** — AI_GENERATE_CHUNKS + AI_GENERATE_EMBEDDINGS
9. **Demo: retrieval + LLM** — VECTOR_SEARCH + sp_invoke_external_rest_endpoint → LLM cevabı
10. **11 rol için yol** — okuyucu kendi profilini bulsun
11. **Satın al + topluluk** — caglarozenc.com + GitHub repo + Discord
12. **Kapanış + Q&A çağrı** — teşekkür + iletişim

---

## Hedef metrikler

| Metrik | Hedef |
|---|---|
| Kayıt sayısı | 800+ |
| Katılım (live attendance) | 300-400 |
| Q&A soru sayısı | 30+ |
| Etkinlik sonrası 24 saatte kitap satışı | 100+ |
| YouTube kayıt görüntülenme (1 hafta) | 2000+ |
| LinkedIn etkileşim | 200+ beğeni, 50+ paylaşım |

---

## Yedek planlar

### Demo çökerse
- Statik ekran görüntüleri hazır (slayt deck'in 7-8-9 numaralı slaytları)
- "Şimdi gerçek production demo'sunu görmek için kayıt sonrası YouTube'da yayınlayacağım" geçişi

### Düşük katılım olursa (< 100)
- Etkinlik kayıt yayınına ağırlık verir, lansman pazarlama planını kuvvetlendirir
- DMC müşteri ağı tek tek email davetiyle ısıtılır

### Platform sorunu
- YouTube Live'a paralel yayın (yedek)
- DMC ekibinden bir kişi backup mod hazır

---

## Sponsor entegrasyonu (opsiyonel)

DMC etkinliği finanse ediyorsa, ek kanallar:
- Microsoft Türkiye veri platformu ekibinden tanıtım
- Türkiye SQL Server kullanıcı grubu desteği
- Bir-iki MVP "kitabı okudum, fikrim" mini katılımı (5 dakika)

---

## Sonraki etkinlikler

İlk webinar başarılıysa, aylık 1 saatlik webinar serisi:

| Tarih | Konu |
|---|---|
| Temmuz 2026 | Vector arama derinleştirme — DiskANN tuning, hybrid search |
| Ağustos 2026 | EU AI Act 2 Ağustos sonrası — Bölüm 28 canlı güncelleme |
| Eylül 2026 | Türkçe AI — Kumru fine-tuning workshop |
| Ekim 2026 | HTAP — Resource Governor + Optimized Locking pratik |
| Kasım 2026 | SQL MCP Server — agent kurulum atölyesi |
| Aralık 2026 | Yıllık değerlendirme + 2027 yol haritası |

---

İletişim: caglarozenc@gmail.com · info@dmcteknoloji.com

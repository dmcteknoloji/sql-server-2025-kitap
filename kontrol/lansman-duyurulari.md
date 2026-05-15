# Lansman Duyuruları — v1.0 (20 Haziran 2026)

Beş kanal için draft. Her birine "Haziran ortası publish" hedefiyle; lansman günü Twitter/LinkedIn aktive.

---

## 1) LinkedIn — uzun yazı (lansman günü, 20 Haziran)

**Başlık:** "Yedi ay yazdığım Türkçe SQL Server 2025 kitabı bugün çıktı — ücretsiz"

**İçerik:**

Microsoft Ignite 2025'te SQL Server 2025'in genel kullanıma sunulduğunu izledim — Kasım ayıydı.

Sonra düşündüm: Türkçe konuşan bir veri profesyoneli bu sürümü öğrenmek isterse nereye bakar?

Cevap acıydı: derli toplu kapsamlı Türkçe kaynak yoktu. Bob Ward'ın "SQL Server 2025 Unveiled" kitabı İngilizce kanonik referanstı ama 600 sayfa İngilizce. Yaşar Gözüdeli'nin Seçkin Yayınevi'nden çıkmış "MS SQL Server" başucu kitabı vardı, ama eski sürüm.

Türkiye'de SQL Server topluluğu büyük. Bankacılık, telekom, e-ticaret, kamu — hepsi SQL Server'a yaslı. 2025 sürümü AI ve vector arama dünyasını veritabanı motorunun içine indirdi. Bu dönüşüm en kalın Türkçe başucu kitabını hak ediyordu.

Yedi ay yazdım. Bugün çıkıyor — ve DMC olarak satmıyoruz, **tamamen ücretsiz** veriyoruz:

**SQL Server 2025: Herkes İçin, Her Rol İçin**
v1.0 — Haziran 2026 — CC BY-NC-SA 4.0

🔗 PDF + EPUB indir: github.com/dmcteknoloji/sql-server-2025-kitap/releases
🔗 Web sürüm: caglarozenc.com/kitap/sqlserver2025
🔗 GitHub repo: github.com/dmcteknoloji/sql-server-2025-kitap

446 sayfa, 32 bölüm, 6 kısım, 11 farklı rol için yol haritası:

I — Ortak Temeller (öğrenci, yeni başlayan)
II — DBA Yolu (depolama, yedekleme, HA, güvenlik, performans)
III — Geliştirici Yolu (T-SQL yenilikleri, REST, ORM, test/CI)
IV — Veri/Analitik Yolu (OLAP, Fabric Mirroring, CES, Azure SQL)
V — AI/Mimari Yolu (vector, embedding, RAG, HTAP, MCP)
VI — Türkiye Penceresi (KVKK, EU AI Act, Türkçe AI ekosistemi, gelecek)

İçerik beş ilkeye sıkıştı:

✦ Doğrulanmış birincil kaynak — her teknik cümle Microsoft Learn / devblogs / KB ile bağlı
✦ Test edilmiş kod — 100+ T-SQL örneği SQL Server 2025'te çalıştırıldı
✦ Sade Türkçe — terim ilk geçtiğinde tek cümle tanım, jargon yığını yok
✦ Provokatif yeniden çerçeveleme — "SQL artık sadece BT'nin işi değil"
✦ Saha damarı — DMC'nin yıllar içinde topladığı kurumsal nüanslar

Bir CFO da, bir veri analisti de, bir öğrenci de kendi rolüne göre okur. Aynı kitap.

Açık konuşayım: Vector indexes hâlâ PREVIEW kapsamında; aylık CU'larla API'ler oturuyor. EU AI Act yüksek risk yükümlülükleri 2 Ağustos 2026'da başlıyor. Kitap canlı yayın olarak yaşayacak — caglarozenc.com/kitap üzerinde aylık güncellenir, Mart 2027'de v1.1, 2028'de SQL Server vNext baskısı.

GitHub repo'sunda kod örnekleri ayrı duruyor; PR'larla topluluk katkısına açık. Errata sayfası canlı.

**Neden ücretsiz?** Türkçe SQL Server kapsamlı kaynak yokken bunu satışla sınırlamak topluluğa karşı bir kayıp olurdu. DMC'nin asıl uzmanlık alanı kurumsal danışmanlık ve eğitim — kitap, bu hizmetlerin altyapısı; topluluğa armağan.

Fiziksel baskı isteyenler için 15 Temmuz'da 250 ₺'lik DMC imzalı edition var (opsiyonel, "destekçi" niyetiyle). GitHub Sponsors üzerinden destek olmak isteyenlere künyede teşekkür listesinde yer.

Türkçe SQL topluluğuna hizmet etsin.

#SQLServer #SQLServer2025 #VeriTabani #AI #MicrosoftDataPlatform #MVP #Turkce #Kitap

---

## 2) Twitter/X — thread (lansman günü, sabah 09:00)

```
1/8 Türkçe SQL Server 2025 başucu kitabı bugün çıktı — ve TAMAMEN ÜCRETSİZ.

446 sayfa, 32 bölüm, 11 rol için yol haritası. CC BY-NC-SA 4.0.

🔗 PDF indir: github.com/dmcteknoloji/sql-server-2025-kitap/releases
🔗 Web sürüm: caglarozenc.com/kitap/sqlserver2025

Thread'de niye yazdım ve niye ücretsiz. 👇

2/8 SQL Server 2025 vector, embedding, doğal dil arayüzü ve REST entegrasyonunu motorun içine indirdi.

VECTOR(N) tipi, DiskANN indeksi, AI_GENERATE_EMBEDDINGS, sp_invoke_external_rest_endpoint native — hepsi T-SQL'in içinde.

Yani SQL artık sadece BT'nin işi değil.

3/8 Türkçe kapsamlı kaynak yoktu.

Bob Ward'ın İngilizce kitabı kanonik referans ama 600 sayfa. Türkiye'de bankacılıktan telekoma her sektör SQL Server'a yaslı. Bu sürüm en kalın Türkçe başucunu hak ediyordu.

4/8 Kitap 6 kısma bölündü:

I  — Ortak Temeller
II — DBA Yolu
III— Geliştirici Yolu
IV — Veri / Analitik Yolu
V  — AI / Mimari Yolu
VI — Türkiye Penceresi (KVKK + EU AI Act dahil)

Her bölüm 11 rol için "kritik / ilgili / opsiyonel" rozetiyle.

5/8 Disiplin:

✦ Her teknik cümle Microsoft Learn / KB ile bağlı
✦ 100+ T-SQL örneği SQL Server 2025'te koşturuldu
✦ Sade Türkçe, jargon yığını yok
✦ "Eskiden / 2025 ile / Nüans" üçlüsü her teknik bölümde

6/8 Bölüm 29 "Türkçe AI Ekosistemi" özel ilgi:

Kumru-2B (VNGRS), Trendyol-LLM, TURNA (Boğaziçi), BGE-M3 multilingual — Türkçe için seçim rehberi + KVKK uyumlu self-hosted (Ollama) kurulumu.

7/8 Canlı yayın olarak yaşayacak:

▸ GitHub repo: kod örnekleri + issue tracker + errata
▸ caglarozenc.com/kitap: aylık CU değişimleri
▸ v1.1 Mart 2027 (CU5-CU8 + EU AI Act sonrası)
▸ 2028 Edition (SQL Server vNext)

8/8 Türkçe SQL Server topluluğuna hizmet etsin.

Niye ücretsiz? Türkçe kapsamlı kaynak yokken satışla sınırlamak kayıp olurdu. DMC'nin asıl işi kurumsal danışmanlık + eğitim; kitap topluluğa armağan.

📥 PDF + EPUB: github.com/dmcteknoloji/sql-server-2025-kitap/releases
🌐 Web: caglarozenc.com/kitap/sqlserver2025
📚 Fiziksel (opsiyonel): dmcteknoloji.com/kitap

#SQLServer #SQLServer2025 #Veri #AI #MVP #AcikKaynak
```

---

## 3) Microsoft MVP topluluk e-postası (10 gün önce ön duyuru, 10 Haziran)

**Konu:** Türkçe SQL Server 2025 kitabı — 20 Haziran lansmanına ön bilgi

Merhaba MVP topluluğu,

Aralık'ta başladığım Türkçe SQL Server 2025 kitabını 20 Haziran 2026'da çıkarıyorum. Türk veri profesyonelleri için ilk kapsamlı kaynak.

**Kısa öz:**
- 446 sayfa, 32 bölüm, 11 rol için ayrı yol haritası
- Mayıs 2026 CU4-GDR (KB5089899) baseline
- Doğrulanmış Microsoft Learn referansları
- DMC Bilgi Teknolojileri yayını
- Dijital PDF/EPUB + GitHub repo + fiziksel baskı

**Sizden ricalar:**
1. Lansman duyurusunu kendi kanalınızda paylaşırsanız çok memnun olurum (LinkedIn, Twitter, blog)
2. Türkiye SQL Server Topluluğu grubunda paylaşım için onay rica ediyorum
3. Kitabı kendi şirketinizde / müşterinizde dağıtım için kurumsal lisans talep ediyorsanız DMC ile irtibat: dmcteknoloji.com

**Beta okuyuculara teşekkür:** [Liste burada — beta okur turu sonrası]

GitHub repo: github.com/caglarozenc/sql-server-2025-kitap (lansman günü canlı)
Lansman sayfası: caglarozenc.com/kitap/sqlserver2025

Saygılar,
Çağlar Özenç
DMC Bilgi Teknolojileri / Microsoft Data Platform MVP

---

## 4) caglarozenc.com blog yazısı — yazarlık hikâyesi (lansman günü)

**Başlık:** "Yedi ayda yazılan kitap — neden, nasıl, ne öğrendim"

**Ana hatlar (taslak):**

▸ **Neden bu kitap?** Ignite 2025'in akşamı, BRK124 oturumundan sonra; Microsoft Türkiye topluluğunun büyüklüğü ile Türkçe kapsamlı kaynak eksikliği arasındaki uçurum

▸ **Yedi aylık takvim:** Plan dosyası, 8 faz, 32 bölüm yazımı, Türkçe AI sahasında özgün araştırma, simüle ve gerçek beta okur turu

▸ **Kavramsal omurga:** "SQL artık BT'nin işi değil" tezi; 11 rol için ayrı yol haritası; "eskiden / 2025 ile / nüans" üçlüsü her teknik bölümde

▸ **Yazım disiplini:** Birincil kaynak (Microsoft Learn / KB) zorunlu; test edilmiş kod; sade Türkçe; AI-koku yasakları (şablon başlangıç, simetrik liste, emoji)

▸ **Hata ve dürüstlük:** Vector index hâlâ PREVIEW; CU5/CU6'da değişebilir. Bu kitap canlı yayın; aylık güncellenir.

▸ **Topluluğa çağrı:** GitHub repo açık, PR'lar kabul. Errata sayfası canlı. Sözlük topluluk eli ile büyür.

▸ **Teşekkürler:** Bob Ward'ın "SQL Server 2025 Unveiled" referans olarak; beta okur turu; Microsoft Türkiye topluluğu; DMC ekibi.

▸ **Sıradaki:** v1.1 Mart 2027 (CU5-CU8 + EU AI Act); 2028 Edition (vNext).

**Tahmini uzunluk:** 1500-1800 kelime, 5-7 dakika okuma. Kitap kapağı görseliyle açılır.

---

## 5) DMC iç ve müşteri duyurusu (lansman günü, e-posta)

**Konu:** DMC v1.0 yayın: "SQL Server 2025: Herkes İçin, Her Rol İçin" — açık kaynak

Değerli DMC iş ortakları ve müşterileri,

DMC Bilgi Teknolojileri olarak, MVP Çağlar Özenç'in 7 ayda yazdığı SQL Server 2025 başucu kitabını bugün **tamamen ücretsiz** yayımladık. PDF + EPUB + web sürümü — herhangi bir kayıt veya ödeme olmadan. Türkçe SQL Server topluluğuna armağanımız.

**Neden DMC için stratejik:**
- DMC danışmanlığının yedi yıllık saha deneyimi kitabın "MVP nüansları" damarını besler
- Kitap ücretsiz; **DMC'nin gerçek değeri kurumsal eğitim ve danışmanlıkta** — kitap o kapıyı açar
- Otorite konumlandırma: Türkçe SQL Server 2025 alanında DMC = referans
- SEO + topluluk büyümesi: kitap → DMC danışmanlık taleplerinin doğal hunisi

**Kurumsal hizmetlerimiz (gelir kalemleri):**

| Hizmet | Format | Yaklaşık |
|---|---|---|
| **2 günlük SQL Server 2025 AI Atölyesi** | Online veya İstanbul, 15 kişi | Özel teklif |
| **1 saat uzman sohbet** | Online, sorunuza özel | 1.500 TL |
| **Migrasyon + modernizasyon projesi** | Uçtan uca danışmanlık | Proje bazlı |
| **Yıllık DMC abonelik** | Kitap güncel + aylık webinar + danışmanlık desteği | Kurum bazlı |
| **Bankacılık/telekom özel paket** | Custom training + on-call uzman | Özel teklif |

**Çapraz hizmet stratejisi:**
1. Müşteri ücretsiz kitabı okur → DMC otoritesini görür
2. Spesifik sorunu için 1 saat uzman sohbet alır
3. Proje haline gelirse tam DMC danışmanlık kontratı

**Müşterilerinize:** kitap link'ini paylaşın, ücretsiz indirme önerin, DMC olarak satmıyoruz; ama danışmanlık ihtiyacı için bize gelmelerini söyleyin.

İletişim: dmcteknoloji.com · info@dmcteknoloji.com

DMC Bilgi Teknolojileri
İstanbul · Haziran 2026

---

## Yayın saati önerisi (20 Haziran 2026 Cumartesi)

| Saat | Kanal |
|---|---|
| 08:30 | LinkedIn yazısı paylaş |
| 09:00 | Twitter thread aktive |
| 09:30 | caglarozenc.com blog yazısı yayımla |
| 10:00 | MVP topluluğa e-posta gönder |
| 11:00 | DMC iç ve müşteri duyurusu |
| Akşam | İlk geri dönüşlere cevap, paylaşım büyütme |

**Pazartesi (22 Haziran):** Türkiye SQL Server kullanıcı grupları (Telegram, Discord, Slack) duyuru; haftalık webinar takvim duyurusu.

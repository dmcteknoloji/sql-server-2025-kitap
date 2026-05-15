# Beta Okur Bulguları (Simülasyon)

**Tarih:** 2026-05-15
**Sürüm:** v0.95 draft, PDF 442 sayfa
**Yöntem:** Üç farklı rol perspektifinden tam okuma simülasyonu. Gerçek beta okur turu Faz 7'de (Eylül-Ekim 2026) yapılır; bu liste o tur için ön hazırlık.

Her perspektif için: rolün ihtiyaçları → bulduğu güçlü yönler → düzeltme önerileri.

---

## Beta Okur 1 — Kıdemli DBA (12 yıllık SQL Server 2008-2022 deneyimi)

**Profil:** Bir holdingde 4 cluster + 30 instance yönetiyor; Always On AG, backup/restore, performans tuning sahası. 2025'i hâlâ kurmadı.

**Güçlü bulduğu yönler:**
- Bölüm 1 (kronoloji) — "Sybase mirası 2005'te resmen silindi" kısmı tarihi netleştirdi
- Bölüm 6 (Depolama + Optimized Locking) — TID locking ve LAQ ayrımı somut, 1000 satır UPDATE örneği çok iyi
- Bölüm 7 (Backup) — ZSTD compression rakamlarıyla sunulmuş, sağ tıkla-kopyala-koy seviyesinde
- Bölüm 9 (Güvenlik) — STRIDE tablosu, Always Encrypted with secure enclaves netliği

**Düzeltme önerileri:**
1. **Bölüm 8 (HA/DR)** — async commit dispatching anlatımı yer yer çok teknik; bir grafik (sequencer / AG dispatcher) yardımcı olurdu
2. **Bölüm 10 (IQP)** — OPPO ile PSPO arasındaki nüans (parameter sensitive vs optional parameter) bir kez daha bir tablo ile özetlenebilir; çok yakın iki kavram
3. **Bölüm 11 (Yönetim araçları)** — Copilot in SSMS'in agent değil tek-soru-tek-cevap modeli olduğu vurgulanmalı; CDO beklentisini düşürür
4. **Bölüm 17 (Columnstore)** — sayfa 263'teki tablo (performans rakamları) çok değerli, ama "test edilen donanım" notu eklenmeli (yoksa pazarlama gibi okunuyor)
5. **Genel** — sözlükte "patch", "hotfix", "CU", "GDR" gibi temel DBA terimleri yok; eklenmeli

---

## Beta Okur 2 — CIO (kurumsal stratejist, teknik geçmiş 10+ yıl önce)

**Profil:** Holdingte 5 yıllık CIO; modernizasyon kararı veriyor. Teknik detayda kaybolmak istemiyor ama "neden 2025'e geçelim?" sorusuna net cevap arıyor.

**Güçlü bulduğu yönler:**
- Yazardan Önsöz tezi — "SQL artık BT'nin işi değil" provokatif yeniden çerçeveleme uyandırıcı
- Kitabın Haritası — "C-Level: Bölüm 1-2 + Kısım VI" yolu somut, 3 saatlik bir okumayla strateji oturuyor
- Bölüm 27 (Türkiye yol haritası) — 6/12/18 ay planı budget kararı için referans
- Bölüm 28 (KVKK + EU AI Act) — risk haritası net; cirosal cezalar somut sayılarla

**Düzeltme önerileri:**
1. **Yazardan Önsöz** — "TCO" tablosu ekle: 2025 Standard vs Enterprise; 32 core lisans aktarımı + Resource Governor Standard'a açılması finansal etki büyük
2. **Bölüm 2 (Tam Resim)** — "Buradan ne kazanırım?" başlığı her ana özellikten sonra 1-cümle hash etiketi gibi olmalı (yöneticilere zaman tasarrufu)
3. **Bölüm 27** — Türkiye'de 2022 lisans sonu Temmuz 2027 (mainstream support); bu tarih kapağa konulabilir; budget döngüleri için kritik
4. **Bölüm 28** — KVKK + EU AI Act overlap'i karışıklık yaratıyor; "Türkiye'de yerleşik ama AB'ye satış yapan şirket için her ikisi de zorunlu" karar ağacı tek sayfaya sığabilir
5. **Genel** — "Eğer X yaparsanız hata yaparsınız" gibi anti-pattern uyarıları C-Level için altın değerinde; bunlar yan kutuya alınabilir

---

## Beta Okur 3 — AI Engineer (3 yıllık deneyim, PyTorch + LangChain odaklı, SQL'e mesafeli)

**Profil:** Bir bankada NLP ekibinde; RAG projesi Postgres + pgvector ile yürütüyor. SQL Server 2025'in vector özellikleri hakkında merak.

**Güçlü bulduğu yönler:**
- Bölüm 21 (VECTOR + DiskANN) — Vamana graf yapısı, FP16 ile bellek tasarrufu, somut sözdizimi (boyut uyumsuzluğu hata mesajı bile gösterilmiş)
- Bölüm 22 (AI_GENERATE_EMBEDDINGS) — CREATE EXTERNAL MODEL + Azure OpenAI + Ollama + ONNX üçlüsünü tek sayfada
- Bölüm 24 (RAG) — chunk → embed → retrieve → LLM tek tek T-SQL ile (Python orchestration olmadan)
- Bölüm 29 (Türkçe AI) — Kumru / Trendyol / BGE-M3 / TURNA karşılaştırması; "Türkçe için ne kullanırım?" sorusuna ilk cevap

**Düzeltme önerileri:**
1. **Bölüm 21** — DiskANN parametre tuning örnekleri eksik (MAX_NEIGHBORS_PER_VERTEX, ALPHA); pgvector'dan gelen okuyucu için karşılaştırma tablosu lazım
2. **Bölüm 22** — rate limit + retry deseni T-SQL içinde gösterilmeli (Bölüm 13'te var ama 22'de tekrar gerekli — kullanıcı 13'ü atlayabilir)
3. **Bölüm 23 (hybrid)** — RRF formülü çok iyi ama "BM25 nasıl çalışır" hızlı kutu eklenmeli; pgvector'dan gelen okuyucu BM25'i tanımıyor olabilir
4. **Bölüm 24** — Bir "Python ile SQL Server vector" örneği eklenmeli (LangChain SqlAlchemy bağlantı); ekosistem köprüsü gerek
5. **Bölüm 26 (MCP)** — Anthropic'in MCP spec'inin tam adı + GitHub link; merak eden kişi spesifikasyona atlasın

---

## Önerilen Düzeltme Önceliği (lansman öncesi)

| Sıra | Düzeltme | Bölüm | Süre | Önem |
|------|----------|-------|------|------|
| 1 | TCO tablosu (Standard vs Enterprise) | Önsöz/Bölüm 3 | 1 saat | Yüksek |
| 2 | OPPO vs PSPO karşılaştırma tablosu | Bölüm 10 | 30 dk | Orta |
| 3 | Performans rakamlarına "test donanımı" notu | Bölüm 17 | 15 dk | Yüksek |
| 4 | Sözlüğe DBA temel terimleri (CU, GDR, hotfix) | Arka bölüm | 30 dk | Orta |
| 5 | pgvector ↔ SQL Server vector karşılaştırma kutusu | Bölüm 21 | 1 saat | Yüksek |
| 6 | BM25 hızlı tanım kutusu | Bölüm 23 | 30 dk | Orta |
| 7 | Bölüm 22'de retry + rate limit referansı | Bölüm 22 | 15 dk | Orta |
| 8 | KVKK + EU AI Act karar ağacı | Bölüm 28 | 1 saat | Yüksek |
| 9 | Türkiye 2022 mainstream support sonu tarihi | Bölüm 27 | 10 dk | Yüksek |
| 10 | "Anti-pattern uyarıları" yan kutu format | Genel | 2 saat | Düşük |

**Toplam:** ~7 saat'lik düzeltme listesi; bir günde toplu yapılabilir. Lansman öncesi Faz 8'de kapatılır.

---

## Sınırlamalar

Bu liste **simülasyon** sonucudur; gerçek beta okur turu üç açıdan farklılaşır:
1. **Gerçek okur, gerçek dünya bilgisini taşır.** Türkiye'de bankacılık DBA'i o sektörün spesifik gözlemini ekleyebilir.
2. **Anlamadığı yer**leri işaretler — bu simülasyon "Çağlar'ın yazdığı hâlâ benim için anlamlı mı?" sorusunu sormaz.
3. **Okuma zamanı şahsi.** Bir DBA üç saatte okuduğu yerden bir öğrenci bir günde bile çıkamayabilir.

Bu nedenle Faz 7 beta okur turu **vazgeçilmezdir**. Yukarıdaki liste o tura "hangi noktalarda dikkatli olun" ön hazırlığıdır.

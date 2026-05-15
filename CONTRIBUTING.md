# Katkıda Bulunma Rehberi

Hoş geldin! Bu kitap canlı bir yayın olarak tasarlandı; topluluk katkısıyla büyür. Bu sayfa nasıl katkıda bulunacağını, hangi standartların geçerli olduğunu ve neyi nereden bekleyebileceğini özetler.

---

## Üç katkı yolu

### 1. Errata bildirme

Kitapta yanlış bir cümle, hatalı bir tarih, çalışmayan bir kod örneği, eksik bir sözlük terimi mi gördün? En kıymetli katkıdır.

**Adımlar:**

1. Önce mevcut [issue'lara](../../issues?q=label%3Aerrata) bak — aynı hatayı başkası bildirmiş olabilir
2. Yeni issue aç, `errata` etiketi seç
3. Şu şablonu kullan:

```
**Sayfa:** NN
**Bölüm:** N
**Tip:** [yanlış cümle | hatalı sözdizim | eksik kavram | typo]

**Mevcut metin (alıntı):**
> ...

**Önerilen düzeltme:**
...

**Kaynak (varsa):**
- Microsoft Learn: <URL>
- KB makalesi: <URL>
- Diğer: ...
```

4. Doğrulandığında [`ERRATA.md`](./ERRATA.md)'ye işlenir; v1.1'de gövdeye yansır

---

### 2. Kod örneği geliştirme

`kod-ornekleri/bolum-XX/` altındaki bir `.sql` dosyasını iyileştirmek veya yeni bir örnek eklemek istiyorsan:

**Adımlar:**

1. Fork al, yeni branch aç: `git checkout -b kod-NN-iyilestirme`
2. Değişikliğini yap
3. **Gerçek SQL Server 2025 instance'ında koştur** ve çıktısını al
4. PR aç, açıklamada:
   - Hangi bölüm/dosya
   - Ne değişti, neden
   - Hangi SQL Server sürümünde test edildi (CU numarası)
   - Microsoft Learn referansı (varsa)

**Kod örneği kabul kriterleri:**

- Demo veritabanı (`_ortak/00-demo-veritabani.sql`) üzerinde çalışmalı
- Tek başına çalıştırılabilir olmalı (önkoşullar başlık yorumunda belirtilmeli)
- SQL Server 2025 baseline'a uygun (PostgreSQL/MySQL sözdizimi karışmamalı)
- Türkçe açıklama yorumları
- Production-uygun: secret, IP, gerçek müşteri verisi yok

---

### 3. Sözlük genişletme veya tartışma

[Discussions](../../discussions) üzerinden:

- **Q&A** kategorisi: kitapla ilgili soru-cevap
- **Sözlük önerileri** kategorisi: yeni terim, mevcut tanım iyileştirme
- **Genel** kategorisi: lansman, sürüm planlaması, topluluk fikirleri

---

## Yazım disiplini

Bu kitap belirli bir yazım çizgisinde yazıldı; katkılarda da bu çizgi korunur:

### Doğrulanmış birincil kaynak

Her teknik iddia Microsoft Learn, devblogs.microsoft.com, techcommunity.microsoft.com veya resmi KB makalesi ile bağlı olmalı. URL'i olmayan iddia kabul edilmez.

**İyi:**
> SQL Server 2025'in `OPTIMIZED_LOCKING` özelliği TID locking ve LAQ kullanır
> ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/performance/optimized-locking)).

**Kötü:**
> SQL Server 2025'te Optimized Locking 10 kat performans artışı sağlar.

(Rakam kaynaksız.)

### Test edilmiş kod

Her T-SQL örneği gerçek SQL Server 2025 instance'ında koşturulmuş ve çıktısı doğrulanmış olmalı. PR'a çıktı log'unu (hassas veri maskeli) ek olarak iliştir.

### Sade Türkçe

- Teknik terim ilk geçtiğinde **Türkçe** + (İngilizce) + tek cümle tanım. Sonraki geçişlerde sadece terim.
- Yardımcı bağlaçlar: "öyleyse", "demek ki", "şuna dikkat", "diyelim ki"
- Cümle uzunluğunda çeşitlilik. Her cümle aynı uzunlukta olmasın.

### AI-koku yasakları

Aşağıdaki kalıplar reddedilir (otomatik üretilmiş gibi okunur):

- "Çıkarım:" / "Pratik karşılığı:" / "Sonuç olarak:" / "Özetle:" / "Sonuç itibariyle:" gibi şablon paragraf başlangıçları
- "Bir yandan ... öte yandan ..." simetrik karşıtlık
- "Sadece X değil, aynı zamanda Y" formülü
- Üçlü liste yapısı tekrarı (her cümle üç madde olarak parçalanmış)
- "İlk bakışta basit gibi görünse de gerçekte..." şişirici giriş

### Görsel disiplin

- **Emoji yok:** 😀 ✓ ✗ ⚠ 🚀 vb. yasak (hiçbir dosyada)
- **Geometrik ok yok:** → ← ↑ ↓ ⇒ ⇐ — yerine tire (—) veya açıklama
- **Tik/çarpı yok:** ✓ ✗ — yerine "var/yok", "tamam/eksik"
- **HTML emoji-benzeri karakterler yok:** ● ■ □ ○

### Bölüm yapısı

Yeni bir bölüm önerirsen şu iskelete uymalı:

```html
<div class="chapter-meta">SQL Server 2025 · Çağlar Özenç & DMC Bilgi Teknolojileri</div>
<h1>Bölüm NN: Başlık</h1>
<p class="subtitle">Tek cümle açıklayıcı alt başlık</p>

<div class="role-badges">
  <span class="label">Bu bölüm:</span>
  <!-- 11 rol için role-chip critical/relevant/optional -->
</div>

<div class="exec-summary">
  <p><strong>Bu bölümün cebinizdeki cevabı:</strong> ...</p>
</div>

<h2>...</h2>
<!-- 4-10 arası h2 + paragraf + tablo + pre.tsql -->

<div class="before-after">
  <!-- Eskiden / 2025 ile / Nüans üçlüsü -->
</div>

<h2>Kısa kısa</h2>
<ul><!-- 5-8 madde özet --></ul>

<h2>İleri okuma</h2>
<ul><!-- 3-5 URL, en az 2'si Microsoft Learn / devblogs --></ul>
```

---

## PR akışı

1. **Issue ile başla** (önerin tartışılsın)
2. **Fork + branch aç** (`git checkout -b <açıklayıcı-isim>`)
3. **Değişikliği yap** (yukarıdaki disipline uygun)
4. **Test et:** kod örneği ise gerçek SQL'de koştur; metin ise prova okuma yap
5. **Commit mesajı:** Türkçe, açıklayıcı, alt-başlık formatında
   - İyi: `bolum-22: Türkçe BGE-M3 örneği için Azure ML endpoint örneği eklendi`
   - Kötü: `update`
6. **PR aç:** açıklamada hangi disiplin maddesi karşılandı, neyin test edildi, hangi kaynaklar bağlandı
7. **Review döngüsü:** maintainer (Çağlar) 7 gün içinde inceler; konuşmalar Türkçe

---

## Maintainer

Çağlar Özenç (caglarozenc@gmail.com · [@caglarozenc](https://github.com/caglarozenc))
DMC Bilgi Teknolojileri ekibi yardımcı maintainer.

Cevap süresi: 7 gün (hafta içi), 14 gün (yoğun dönemlerde).

---

## Davranış kuralları (Code of Conduct)

Kısa:

- Saygılı ol.
- Soruya saygıyla yaklaş, soran kişiye değer ver.
- Teknik konuda fikir ayrılığı normal; kişisel olmasın.
- Türkçe topluluk olarak Türkçe öncelikli; İngilizce kabul.
- Reklam, spam, ticari ürün tanıtımı yasak (DMC kendi paketleri için ayrı kanal var).

Detaylı: [Contributor Covenant 2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/)

---

## Teşekkürler

Her bir issue, PR, sözlük önerisi v1.1'e doğru yol gösteren bir adımdır. Türkçe SQL Server topluluğuna kalan kalıcı bir kaynak inşa ediyoruz.

Hoş geldin.

— Çağlar Özenç & DMC Bilgi Teknolojileri ekibi

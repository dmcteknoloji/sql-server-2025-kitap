# DBA Lansman Test Playbook — v1.0 öncesi

**Hedef:** 1 günde tüm kod örneklerini gerçek SQL Server 2025 instance'ında doğrula. Kalan bug'ları errata listesi için yakala.

**Süre:** ~6-8 saat (paralelize edilirse 4-5 saat).

**Önkoşul:**
- SQL Server 2025 RTM-CU4-GDR (KB5089899) instance (build 17.0.4040.1+)
- Sysadmin yetkili test login (üretim dışı)
- macOS/Linux/Windows sqlcmd 18+ veya `mssql-tools18`
- Yeterli disk: ~5 GB (demo DB + tempdb)

---

## Adım 0 — Ortam doğrulama (15 dk)

```bash
# 1. sqlcmd sürüm kontrolü
sqlcmd -? | head -3   # ≥ 18.x olmalı

# 2. SQL Server sürüm kontrolü
sqlcmd -S '<server>' -U '<user>' -P '<pwd>' -C -Q "SELECT @@VERSION"
# Beklenen: 17.0.4040.1 (RTM-CU4-GDR) (KB5089899)

# 3. Repo çalışma dizinine geç
cd /path/to/kitap-sqlserver2025
```

---

## Adım 1 — Demo DB setup (10 dk)

```bash
sqlcmd -S '<server>' -U '<user>' -P '<pwd>' -d 'master' -C \
       -i kod-ornekleri/_ortak/00-demo-veritabani.sql
```

**Beklenen çıktı:** "Demo veritabanı hazır: sales (relational), social (graph), ai (vector)."

**Hata varsa:**
- "CREATE DATABASE permission denied" → sysadmin yetkisi gerek
- "schema already exists" → eski 'demo' DB var; script DROP/CREATE yapacak (zaten)

---

## Adım 2 — PREVIEW_FEATURES kontrolü (2 dk)

```sql
USE demo;
SELECT name, value FROM sys.database_scoped_configurations
WHERE name = 'PREVIEW_FEATURES';
-- value = 'ON' olmalı
```

---

## Adım 3 — Toplu çalıştırma (3-4 saat)

```bash
# Credential'ı env'e koy (chat'e değil, terminal'inde, satır başında BOŞLUK bırak)
 export SQLCMDSERVER='<server>'
 export SQLCMDUSER='<user>'
 export SQLCMDPASSWORD='<pwd>'
 export SQLCMDDBNAME='demo'

# Tüm bölümleri sırayla
./kontrol/run-tests.sh 2>&1 | tee kontrol/test-runs/lansman-test-log.txt

# Veya tek bölüm
./kontrol/run-tests.sh bolum-01
```

**Output:** `kontrol/test-runs/chXX-NN.txt` — credential maskelidir (yayın güvenli).

---

## Adım 4 — Hata triajı (1 saat)

```bash
# Özet
cat kontrol/test-runs/_summary.txt

# OK/FAIL sayısı
grep -c "OK   " kontrol/test-runs/_summary.txt
grep -c "FAIL " kontrol/test-runs/_summary.txt

# FAIL nedenleri
for f in kontrol/test-runs/ch*.txt; do
  err=$(grep -m1 "^Msg [0-9]" "$f")
  [[ -n "$err" ]] && echo "${f##*/}: $err"
done > kontrol/test-runs/lansman-fail-ozet.txt
```

**Beklenen sonuç (v1.0 lansman öncesi):**
- ≥ 60 OK (yaklaşık %75'i)
- Kalan FAIL'ler büyük ölçüde **çevresel** (Kategori A):
  - Always On AG kurulu değilse: ch08-01, 02, 04
  - Backup-to-URL credential'sız: ch07-01..04
  - External REST/AI endpoint kapalıysa: ch13, ch22
  - Master key yoksa: ch23-04

Hata kategorisi tanıma yardımı: `kontrol/test-runs/_known-issues.md` tam katalog.

---

## Adım 5 — Önkoşul açma (opsiyonel, 30 dk)

Eğer Kategori A çevreseli yerel sandbox'ta açmak istersen:

```sql
-- External REST endpoint enable
EXEC sp_configure 'external rest endpoint enabled', 1;
RECONFIGURE;

-- AI features (bölüm 22 için)
EXEC sp_configure 'ai_generate_embeddings enabled', 1;
RECONFIGURE;

-- Master key (bölüm 23-04 için)
USE demo;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<güçlü-parola>';
```

Bu adımlar sonrası ilgili FAIL'lar OK'a döner.

---

## Adım 6 — Yeni FAIL → errata kararı (30 dk)

Her yeni FAIL için karar:

| Durum | Karar |
|---|---|
| Sözdizim hatası (Microsoft Learn'le çapraz çelişiyor) | **Kitap güncellemesi** — ilgili .sql düzelt + bölüm metnini gözden geçir |
| CU bağımlı davranış değişimi | **Errata bandı** — caglarozenc.com/kitap/errata sayfasına ekle |
| Test ortamı eksikliği | **Bilinen kısıt** — known-issues.md'ye ekle, lansmanı bloklamaz |

---

## Adım 7 — Lansman go/no-go (15 dk)

**Go kriterleri:**
- ≥ %70 OK (Kategori A çevresel hariç)
- Kategori B (kod bug'ı) ≤ 5 (≤ %3)
- Tüm test çıktıları hassas veriden temizlenmiş (`grep -lE "<server>" kontrol/test-runs/*.txt` boş olmalı)
- Errata sayfası canlı

**No-go varsa:** geciktir, ilgili bug'ları kapat, yeniden koş.

---

## Kapanış

```bash
# Test çıktılarını commit/arşivle
tar -czf kontrol/test-runs-$(date +%Y%m%d).tar.gz kontrol/test-runs/
# Daha sonra v1.1 zamanında karşılaştırma için saklanır
```

Süreç tamamlandığında: bug listesi → düzeltme (varsa) → final PDF re-derleme → lansman.

# SQL Server 2025 Kitabı — Kod Örnekleri

**Kitap:** SQL Server 2025 — Herkes İçin, Her Rol İçin
**Yazar:** Çağlar Özenç & DMC Bilgi Teknolojileri
**Sürüm:** v1.0 (15 Mayıs 2026)

Bu dizin kitabın teknik bölümleri için çalışan, yorumlu T-SQL ve eşlik eden kod örneklerini içerir. Her bölüm kendi alt klasöründedir.

## Klasör kapsamı

- **bolum-01 ... bolum-26**: tüm teknik bölümlerin T-SQL örnekleri
- **bolum-29**: Türkçe AI ekosistemi (Kumru, Trendyol-LLM, TURNA, BGE-M3 ile embedding örnekleri)
- **_ortak**: tüm bölümlerin paylaştığı setup script + demo veritabanı

**Klasörü olmayan bölümler** — kod örneği gerektirmeyen metin ağırlıklı bölümler:

| Bölüm | Başlık | Niye kodsuz |
|---|---|---|
| 27 | Türkiye Kurumlarında SQL Server 2025 Yol Haritası | Strateji/karar çerçevesi |
| 28 | KVKK, BTK, Veri Egemenliği ve EU AI Act | Hukuki/uyum çerçevesi |
| 30 | Sürüm Karşılaştırma Matrisi + Breaking/Deprecated | Referans tablolar |
| 31 | 2027 ve Sonrası | Roadmap/gelecek senaryoları |
| 32 | vNext Kütüphanesi (kapanış) | Kaynak listesi |

## Önkoşullar

- **SQL Server 2025** GA (build 17.0.x) — minimum CU0, önerilen **CU4 (KB5081495)** veya üstü
- **Compatibility Level 170** (database scoped)
- Preview özellikler için:
  ```sql
  ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
  ```
- **sqlcmd** veya SSMS 22 (ARM64 destekli, Copilot in SSMS dahil)
- Belirli bölümlerde ek araçlar:
  - `dbatools` (PowerShell, Bölüm 11)
  - `mssql-python` driver (Python 3.10+, Bölüm 15)
  - Azure Arc-enabled SQL Server (Bölüm 18 Fabric Mirroring)
  - Azure Event Hubs (Bölüm 19 CES)
  - Azure OpenAI veya Ollama (Bölüm 22-24 embeddings)
  - Data API Builder (Bölüm 26 MCP)

## Çalıştırma

Her klasördeki örnekler `sqlcmd` ile sıralı çalıştırılır:

```bash
sqlcmd -S localhost -d demo -i bolum-05/01-temel-crud.sql
```

veya SSMS / Azure Data Studio'da açıp çalıştırabilirsiniz.

## Klasör yapısı

```
kod-ornekleri/
├── README.md                       # bu dosya
├── _ortak/                         # ortak yardımcı script'ler
│   └── 00-demo-veritabani.sql     # demo veritabanı (tüm bölümler için)
├── bolum-01/                       # SQL Server'ın 36 Yıllık Yolculuğu
├── bolum-02/                       # 2025'te SQL Server: Tam Resim
├── bolum-03/                       # Mimari ve Edition'lar
├── bolum-04/                       # Kurulum ve Yapılandırma
├── bolum-05/                       # T-SQL Temelleri ve 2025 Yenilikleri
├── bolum-06/                       # Depolama ve İndeksler + Optimized Locking
├── bolum-07/                       # Yedekleme, Geri Yükleme ve DR
├── bolum-08/                       # Yüksek Erişilebilirlik
├── bolum-09/                       # Güvenlik ve Audit
├── bolum-10/                       # Performans Tuning ve IQP
├── bolum-11/                       # Yönetim Araçları + Copilot in SSMS
├── bolum-12/                       # Modern T-SQL Yenilikleri
├── bolum-13/                       # External REST Endpoints
├── bolum-14/                       # Application Patterns
├── bolum-15/                       # ORM ve Driver Stratejisi
├── bolum-16/                       # Test, Migration, CI/CD
├── bolum-17/                       # OLAP ve Columnstore
├── bolum-18/                       # Microsoft Fabric Mirroring
├── bolum-19/                       # Change Event Streaming (CES)
├── bolum-20/                       # Synapse Link → Fabric migration
├── bolum-21/                       # VECTOR Tipi ve DiskANN
├── bolum-22/                       # AI_GENERATE_EMBEDDINGS
├── bolum-23/                       # VECTOR_SEARCH ve Hybrid Arama
├── bolum-24/                       # RAG Hattı T-SQL ile Uçtan Uca
├── bolum-25/                       # HTAP Mimari
├── bolum-26/                       # SQL MCP Server
├── bolum-27/                       # Türkiye Yol Haritası
├── bolum-28/                       # KVKK, BTK, EU AI Act audit
├── bolum-29/                       # Türkçe AI Ekosistemi
├── bolum-30/                       # Sürüm Karşılaştırma Matrisi
├── bolum-31/                       # 2027 ve Sonrası
└── bolum-32/                       # Kapanış
```

## Demo veritabanı

Tüm örnekler `demo` adında bir veritabanı varsayar. İlk kurulum:

```bash
sqlcmd -S localhost -i _ortak/00-demo-veritabani.sql
```

## Güvenlik notu

- Hiçbir örnek gerçek production verisi içermez.
- API anahtarları, parolalar, connection string'ler placeholder olarak `<your-key-here>` formatında.
- Production'da kullanmadan önce **least privilege** ilkesine göre yetki düzenleyin.

## Lisans

Kitap içeriğiyle birlikte. Eğitim amaçlı serbest kullanım.

## Geri bildirim

`https://github.com/caglarozenc/sqlserver-2025-kitap-kod` (planlanan repo)

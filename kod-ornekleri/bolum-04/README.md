# Bölüm 4 — Kurulum ve Yapılandırma

Kurulum sonrası en gerekli yapılandırmalar; tek tek script'ler.

| Dosya | Amaç |
|---|---|
| `01-post-install-baseline.sql` | Kurulumdan sonra mutlaka çalıştırılacak baseline (memory, MAXDOP, cost threshold) |
| `02-tempdb-yapilandirma.sql` | tempdb dosya sayısı, eşit boyut, growth ayarları |
| `03-trace-flags.sql` | Önerilen trace flag'leri (1117 artık default; 7752 default değil ama bilinmesi gereken) |
| `04-azure-arc-baglanti.sql` | SQL Server'ı Azure Arc'a bağlamak için gerekli adımlar (Bölüm 18 Fabric için ön koşul) |

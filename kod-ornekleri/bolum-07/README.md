# Bölüm 7 — Yedekleme, Geri Yükleme ve DR

Backup tipleri, ZSTD sıkıştırma, geri yükleme, point-in-time recovery.

| Dosya | Amaç |
|---|---|
| `01-full-diff-log-backup.sql` | Full + differential + log backup zinciri |
| `02-zstd-compression.sql` | ZSTD backup compression (2025 yenisi) |
| `03-restore-point-in-time.sql` | Geri yükleme + STOPAT ile zaman bazlı geri dönüş |
| `04-immutable-blob-backup.sql` | Azure immutable blob'a yedek (ransomware koruma) |

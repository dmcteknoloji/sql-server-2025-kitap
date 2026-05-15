# Fabric Portal'da Mirroring Kurulum Adımları

(Microsoft Learn `learn.microsoft.com/fabric/mirroring/sql-server-tutorial` ile aynı sıra)

## 1) Workspace ve kapasite

1. `app.fabric.microsoft.com` aç
2. Soldan **Workspaces** → New → Workspace adı: `wsp-dmc-mirror`
3. **License capacity**: F SKU seç (F2 minimum, F64+ production öneri)
4. Region: SQL Server'a yakın bir bölge

## 2) Mirrored database oluştur

1. Workspace içinde **+ New** → **Mirrored database**
2. Source: **SQL Server**
3. Connection details:
   - Server: `sqlnode.example.com,1433`
   - Database: `demo`
   - Auth: **Microsoft Entra ID** (önerilen) veya SQL auth
4. **Connect** tuşu

## 3) Tabloları seç

- Tüm DB'yi seç (default) veya
- Tablo bazlı seç (önerilen — sadece gerçekten gerekenler)

## 4) Initial snapshot başlar

- Status: **Initial sync running**
- Büyük tabloda saatler sürebilir
- Snapshot sırasında ana OLTP iş yükü etkilenmez (snapshot isolation)

## 5) Continuous change feed

- Status: **Running**
- Per-table durum: row count, last sync time, latency
- OneLake tarafında Delta tabloları görünür

## 6) Bağlanan iş yükleri

- **Power BI Direct Lake** mode raporlama
- Fabric **Warehouse SQL endpoint** (read-only T-SQL)
- **Spark notebook** (PySpark, ML)
- **Real-Time Intelligence** KQL queryset

## Troubleshooting

| Problem | Çözüm |
|---|---|
| "Initial sync failed" | PK eksik tablo var mı? Desteklenmeyen tip mi? |
| Yüksek latency | F SKU yükselt; scan worker workload group |
| Transaction log büyüyor | Autoreseed çalıştı mı? `sys.dm_change_feeds_log_scan_sessions` |
| Tablo eklenmiyor | Schema değişti; reseed gerekebilir |

## Referans

- `https://learn.microsoft.com/en-us/fabric/mirroring/sql-server`
- `https://learn.microsoft.com/en-us/fabric/mirroring/sql-server-tutorial`
- `https://learn.microsoft.com/en-us/fabric/mirroring/sql-server-limitations`
- `https://learn.microsoft.com/en-us/fabric/mirroring/sql-server-performance`

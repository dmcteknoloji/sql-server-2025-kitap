# Bölüm 18 — Microsoft Fabric Mirroring

Mirroring konfigürasyonu büyük ölçüde Fabric portal'da yapılır; bu klasörde SQL Server tarafındaki ön koşul ve izleme script'leri.

| Dosya | Amaç |
|---|---|
| `01-mirroring-onkosullar.sql` | PK kontrolü, desteklenen tip kontrolü, Arc instance doğrulama |
| `02-resource-governor-mirroring.sql` | Mirroring iş yüküne dedicated workload group |
| `03-mirroring-monitoring.sql` | Mirroring durumu, gecikme, autoreseed izleme DMV |
| `04-fabric-portal-adimlar.md` | Fabric portal üstündeki adımların yazılı yürüyüşü |

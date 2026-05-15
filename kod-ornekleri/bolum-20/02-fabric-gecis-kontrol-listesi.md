# Synapse Link → Fabric Mirroring Geçiş Kontrol Listesi

## Faz 0: Mevcut durum envanteri

- [ ] Hangi DB'lerde Synapse Link aktif? (`is_link_to_synapse_enabled = 1`)
- [ ] Hangi tablolar replicate ediliyor?
- [ ] Synapse Workspace adı?
- [ ] Synapse Spark / SQL pool kullananlar kim (raporlama, ML pipeline)?
- [ ] Downtime toleransı (geçiş penceresi)?

## Faz 1: Fabric ortamı hazırla

- [ ] Fabric workspace oluştur (F SKU min F2, prod F64+)
- [ ] SQL Server Arc-enabled mı? Değilse Arc agent kur
- [ ] Managed identity gerekli izinleri al
- [ ] Network: SQL Server'dan Fabric landing zone'a outbound HTTPS

## Faz 2: Paralel mirror kur

- [ ] Aynı tabloları **Fabric Mirroring** ile yansıt (Synapse Link kapatma henüz)
- [ ] Power BI, Spark, ML raporları test ortamında **Fabric**'e yönlendir
- [ ] Doğrulama: Synapse Link tarafında ve Fabric tarafında satır sayıları eşit mi?
- [ ] Veri tazeliği gecikme karşılaştırma

## Faz 3: Cutover

- [ ] Production raporları **Fabric**'e taşı
- [ ] Power BI dataset'lerini DirectQuery → Direct Lake mode'a güncelle
- [ ] Spark / ML pipeline'ları Fabric Lakehouse'a yönlendir
- [ ] Bir hafta gözlem; problem yoksa Synapse Link'i devre dışı bırak

## Faz 4: Synapse Link temizle

- [ ] Synapse Link bağlantısını kaldır
- [ ] Synapse Workspace ile ne olacak? (Fabric'e migrate veya emekli et)
- [ ] Azure Storage account'larında eski Synapse Link veri dosyalarını gözden geçir

## Faz 5: Post-migration

- [ ] Maliyet karşılaştırma (Synapse vs Fabric F SKU)
- [ ] Performans karşılaştırma (raporlama latency)
- [ ] Documentation güncelle
- [ ] Takım eğitimi (Fabric portal, OneLake)

## Risk azaltma

- **Geri dönüş planı**: ilk hafta Synapse Link'i bekletmede tut
- **Validation**: kritik raporları her iki tarafta paralel çalıştır
- **Monitoring**: Fabric capacity throttle'ı izle

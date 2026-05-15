# DACPAC Build & Deploy

DACPAC = Data-tier Application Package; schema'yı portable bir dosyada paketleyen format.

## Build

```bash
# Microsoft.Build.Sql SDK ile (2025'in önerdiği yol)
dotnet build -c Release src/demo-database/demo-database.sqlproj
# Çıktı: src/demo-database/bin/Release/demo-database.dacpac
```

## Deploy

```bash
# SqlPackage ile deploy
sqlpackage \
    /Action:Publish \
    /SourceFile:demo-database.dacpac \
    /TargetConnectionString:"Server=sqlnode.example.com;Database=demo;Authentication=Active Directory Default;Encrypt=Strict;" \
    /p:BlockOnPossibleDataLoss=true \
    /p:DropObjectsNotInSource=false
```

## Drift detection (kaynak vs hedef fark)

```bash
sqlpackage \
    /Action:Script \
    /SourceFile:demo-database.dacpac \
    /TargetConnectionString:"..." \
    /OutputPath:drift-report.sql
```

## Common publish options

| Property | Anlamı | Default | Üretim önerisi |
|---|---|---|---|
| `BlockOnPossibleDataLoss` | Veri kaybı riskli ise durdur | true | true |
| `DropObjectsNotInSource` | Hedeftekini kaynakla aynı yap | false | false (manual flow) |
| `IgnorePermissions` | İzin değişikliklerini atla | false | Çoğunlukla true (izinler ayrı yönetilir) |
| `IgnoreUserSettingsObjects` | Kullanıcı obje farklarını atla | false | true |
| `VerifyDeployment` | Deploy sonrası doğrula | true | true |
| `IncludeTransactionalScripts` | Migration tek tx'te | false | true (atomicity) |

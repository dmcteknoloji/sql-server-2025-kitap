# Modern Connection String Örnekleri

SQL Server 2025 ile TLS 1.3 + TDS 8.0 default; `Encrypt=Strict` öneriliyor.

## .NET (Microsoft.Data.SqlClient 5.x+)

```csharp
// Entra ID + Managed Identity
"Server=tcp:sqlnode.example.com,1433;Database=demo;" +
"Authentication=Active Directory Managed Identity;" +
"Encrypt=Strict;TrustServerCertificate=false;Connect Timeout=30;"

// SQL auth
"Server=tcp:sqlnode.example.com,1433;Database=demo;" +
"User Id=sqladmin;Password=<...>;" +
"Encrypt=Strict;TrustServerCertificate=false;"

// AG listener + multi-subnet failover
"Server=tcp:aglistener.example.com,1433;Database=demo;" +
"Encrypt=Strict;MultiSubnetFailover=true;" +
"ApplicationIntent=ReadWrite;"

// Read-only routing (raporlama)
"Server=tcp:aglistener.example.com,1433;Database=demo;" +
"ApplicationIntent=ReadOnly;Encrypt=Strict;"
```

## Python (mssql-python — 2025 GA)

```python
import mssql_python as ms

conn = ms.connect(
    server="sqlnode.example.com",
    database="demo",
    authentication="ActiveDirectoryManagedIdentity",
    encrypt="strict",
    trust_server_certificate=False,
    connect_timeout=30
)
```

## Java JDBC

```
jdbc:sqlserver://sqlnode.example.com:1433;
  databaseName=demo;
  authentication=ActiveDirectoryManagedIdentity;
  encrypt=strict;
  trustServerCertificate=false;
  loginTimeout=30;
```

## Node.js (mssql + tedious)

```javascript
const config = {
    server: "sqlnode.example.com",
    database: "demo",
    authentication: {
        type: "azure-active-directory-msi-vm"
    },
    options: {
        encrypt: true,
        trustServerCertificate: false,
        port: 1433
    }
};
```

## Önerilen connection string ayarları

| Parametre | Değer | Sebep |
|---|---|---|
| `Encrypt` | `Strict` | TLS 1.3 zorunlu |
| `TrustServerCertificate` | `false` | MitM koruma |
| `Connect Timeout` | `30` | Reasonable fail-fast |
| `Connection Lifetime` | `300` | Pool eskime; AG failover sonrası yenilenir |
| `Pooling` | `true` | Default; kapatma |
| `Min Pool Size` | `0` | Idle'da 0 connection |
| `Max Pool Size` | `100` | Default; tune workload'a göre |

# Bölüm 26 — SQL Server'ı Agent'a Bağlamak: SQL MCP Server

Data API Builder (DAB) ile MCP endpoint kurulumu + güvenlik katmanı.

| Dosya | Amaç |
|---|---|
| `01-dab-mcp-kurulum.sql` | Agent için adanmış view + least privilege user |
| `02-agent-audit-rate-limit.sql` | Audit log + rate-limit procedure + anomali tespit view |

**Önkoşul:** Data API Builder CLI (`dotnet tool install -g Microsoft.DataApiBuilder`) ve DAB konfigürasyon (.sh içinde).

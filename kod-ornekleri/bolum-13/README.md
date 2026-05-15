# Bölüm 13 — External REST Endpoints

`sp_invoke_external_rest_endpoint` ile T-SQL içinden REST çağrısı.

| Dosya | Amaç |
|---|---|
| `01-credential-olustur.sql` | Endpoint için credential (managed identity veya bearer) |
| `02-rest-get.sql` | Basit GET çağrısı (JSON response parse) |
| `03-rest-post-webhook.sql` | Slack/Teams webhook gönderimi (sipariş alındığında bildirim) |
| `04-openai-api-cagri.sql` | Azure OpenAI API'ye direkt çağrı (embedding örneği) |
| `05-retry-timeout.sql` | @retry_count, @timeout, hata yönetimi |

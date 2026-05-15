# Bölüm 19 — Change Event Streaming (CES)

Transaction log'tan row-level change capture, CloudEvents JSON/Avro, Event Hubs'a yayın.

| Dosya | Amaç |
|---|---|
| `01-ces-enable.sql` | DB seviyesinde CES'i aç |
| `02-event-stream-group-olustur.sql` | sys.sp_create_event_stream_group ile yapılandırma |
| `03-cloud-events-payload-ornegi.json` | CES tarafından yayılan CloudEvents JSON örneği |
| `04-event-hubs-tuketici.py` | Python (azure-eventhub) ile event consumer |

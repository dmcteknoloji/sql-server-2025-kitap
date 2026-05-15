-- ============================================================================
-- 02-event-stream-group-olustur.sql
-- ----------------------------------------------------------------------------
-- Tablo bazlı streaming group oluşturma.
-- ============================================================================

USE demo;
GO

-- 1) Event Hubs credential
IF NOT EXISTS (SELECT 1 FROM sys.database_scoped_credentials WHERE name = N'eh_credential')
CREATE DATABASE SCOPED CREDENTIAL eh_credential
    WITH IDENTITY = 'Managed Identity';   -- Arc managed identity
GO

-- 2) Streaming group: sales.orders tablosundaki değişiklikleri yayınla
EXEC sys.sp_create_event_stream_group
    @event_stream_group_name = N'orders_stream',
    @event_stream_url = N'sb://your-eh-namespace.servicebus.windows.net/orders-events',
    @event_stream_credential = N'eh_credential',
    @event_stream_format = N'JSON',           -- veya 'AVRO'
    @event_stream_partition_count = 4,
    @event_stream_security_protocol = N'SASL_SSL',
    @event_stream_authentication = N'EntraIdManagedIdentity';
GO

-- 3) Group'a tablo ekle
EXEC sys.sp_add_object_to_event_stream_group
    @event_stream_group_name = N'orders_stream',
    @object_name = N'sales.orders';
GO

-- 4) Birden fazla tablo ekle
EXEC sys.sp_add_object_to_event_stream_group
    @event_stream_group_name = N'orders_stream',
    @object_name = N'sales.order_items';
GO

-- 5) Group başlat
EXEC sys.sp_start_event_stream_group
    @event_stream_group_name = N'orders_stream';
GO

-- 6) Durum
SELECT * FROM sys.event_stream_groups WHERE name = N'orders_stream';
SELECT * FROM sys.event_streams;
GO

-- Durdur ve sil (örnek)
-- EXEC sys.sp_stop_event_stream_group @event_stream_group_name = N'orders_stream';
-- EXEC sys.sp_drop_event_stream_group @event_stream_group_name = N'orders_stream';

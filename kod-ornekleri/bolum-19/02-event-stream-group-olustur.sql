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

-- 5) Akışı başlat
-- Not: sp_start_event_stream_group / sp_stop_event_stream_group diye yordamlar
-- YOKTUR. CES veritabanı düzeyinde açılıp kapatılır; group'lar sp_create_* /
-- sp_drop_* ile yönetilir. Mevcut yordamlar:
--   sp_enable_event_stream, sp_disable_event_stream,
--   sp_create_event_stream_group, sp_drop_event_stream_group,
--   sp_add_object_to_event_stream_group, sp_remove_object_from_event_stream_group
EXEC sys.sp_enable_event_stream;
GO

-- 6) Durum
-- Not: sys.event_streams ve sys.event_stream_groups diye katalog görünümleri
-- SQL Server 2025 CU7'de MEVCUT DEĞİLDİR (CES etkinleştirilse bile). CES durumu
-- change feed DMV'lerinden izlenir; stream group'lar sp_* yordamlarıyla yönetilir.
SELECT TOP (10)
    session_id,
    start_time,
    batch_processing_phase,
    error_count,
    latency,
    rows_left_to_publish
FROM sys.dm_change_feed_log_scan_sessions
ORDER BY start_time DESC;
GO

-- Durdur ve sil (örnek)
-- EXEC sys.sp_disable_event_stream;   -- veritabanı düzeyinde durdurur
-- EXEC sys.sp_drop_event_stream_group @event_stream_group_name = N'orders_stream';

-- ============================================================================
-- 01-ces-enable.sql
-- ----------------------------------------------------------------------------
-- Change Event Streaming'i veritabanı seviyesinde aktive et.
-- Önkoşul: PREVIEW_FEATURES = ON; Arc-enabled veya Azure VM (Entra auth için).
-- ============================================================================

USE demo;
GO

-- 1) PREVIEW açık olmalı
ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO

-- 2) CES feature flag'leri
EXEC sys.sp_enable_event_stream
    @event_stream_provider = N'AzureEventHubsAmqp';  -- veya 'AzureEventHubsKafka'
GO

-- 3) CES durumunu izle
-- Not: sys.event_streams ve sys.event_stream_groups diye katalog görünümleri
-- SQL Server 2025 CU7'de MEVCUT DEĞİLDİR (CES etkinleştirilse bile). CES durumu
-- change feed DMV'lerinden izlenir; stream group'lar sp_* yordamlarıyla yönetilir.
SELECT TOP (20)
    session_id,
    start_time,
    end_time,
    batch_processing_phase,
    error_count,
    latency,
    rows_left_to_publish
FROM sys.dm_change_feed_log_scan_sessions
ORDER BY start_time DESC;
GO

-- Hatalar
SELECT TOP (20)
    session_id,
    entry_time,
    error_number,
    error_severity,
    error_message
FROM sys.dm_change_feed_errors
ORDER BY entry_time DESC;
GO

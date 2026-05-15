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

-- 3) Aktif streams listele
SELECT *
FROM sys.event_streams;
GO

SELECT *
FROM sys.event_stream_groups;
GO

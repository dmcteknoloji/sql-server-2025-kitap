-- ============================================================================
-- 02-rest-get.sql
-- ----------------------------------------------------------------------------
-- Basit GET çağrısı: public JSON API'sinden veri çek.
-- ============================================================================

USE demo;
GO

DECLARE @response NVARCHAR(MAX);
DECLARE @ret INT;

EXEC @ret = sp_invoke_external_rest_endpoint
    @url = N'https://api.exchangerate-api.com/v4/latest/USD',
    @method = N'GET',
    @timeout = 30,
    @response = @response OUTPUT;

SELECT @ret AS http_status_class, @response AS raw_json;

-- JSON'dan alanları parse et
SELECT
    JSON_VALUE(@response, '$.result.base')           AS base_currency,
    JSON_VALUE(@response, '$.result.date')           AS rate_date,
    JSON_VALUE(@response, '$.result.rates.TRY')      AS try_rate,
    JSON_VALUE(@response, '$.result.rates.EUR')      AS eur_rate;
GO

-- Cevabı kalıcı tablo'ya kaydet
CREATE TABLE IF NOT EXISTS sales.exchange_rates_log (
    fetched_at  DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    base_currency NCHAR(3) NOT NULL,
    rate_date DATE NOT NULL,
    rate_json JSON NOT NULL
);

DECLARE @json NVARCHAR(MAX);
EXEC sp_invoke_external_rest_endpoint
    @url = N'https://api.exchangerate-api.com/v4/latest/USD',
    @method = N'GET',
    @response = @json OUTPUT;

INSERT INTO sales.exchange_rates_log (base_currency, rate_date, rate_json)
VALUES (
    N'USD',
    CAST(JSON_VALUE(@json, '$.result.date') AS DATE),
    JSON_QUERY(@json, '$.result.rates')
);
GO

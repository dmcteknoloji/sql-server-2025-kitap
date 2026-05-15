-- ============================================================================
-- 03-rls-dinamik-filtre.sql
-- ----------------------------------------------------------------------------
-- Row-Level Security: kullanıcı multi-tenant'ta sadece kendi satırlarını görür.
-- ============================================================================

USE demo;
GO

-- Önkoşul: security schema (yoksa oluştur)
IF SCHEMA_ID('security') IS NULL EXEC('CREATE SCHEMA security');
GO

-- 1) Tenant sütunu (örnek — sadece yoksa ekle)
IF COL_LENGTH('sales.orders','tenant_id') IS NULL
    ALTER TABLE sales.orders ADD tenant_id NVARCHAR(40) NOT NULL DEFAULT N'default-tenant';
GO

-- 2) Security predicate fonksiyonu
CREATE OR ALTER FUNCTION security.fn_tenant_filter(@tenant NVARCHAR(40))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
    SELECT 1 AS allowed
    WHERE @tenant = CAST(SESSION_CONTEXT(N'tenant_id') AS NVARCHAR(40))
       OR IS_MEMBER('db_owner') = 1;
GO

-- 3) Security policy
CREATE SECURITY POLICY security.tenant_filter_policy
ADD FILTER PREDICATE security.fn_tenant_filter(tenant_id) ON sales.orders,
ADD BLOCK PREDICATE security.fn_tenant_filter(tenant_id) ON sales.orders AFTER INSERT
WITH (STATE = ON);
GO

-- 4) Session context ayarla (uygulama login sırasında)
EXEC sp_set_session_context @key = N'tenant_id', @value = N'tenant-A';
SELECT * FROM sales.orders;  -- sadece tenant-A görür

EXEC sp_set_session_context @key = N'tenant_id', @value = N'tenant-B';
SELECT * FROM sales.orders;  -- sadece tenant-B görür
GO

-- Cleanup
-- DROP SECURITY POLICY security.tenant_filter_policy;
-- DROP FUNCTION security.fn_tenant_filter;
-- ALTER TABLE sales.orders DROP COLUMN tenant_id;

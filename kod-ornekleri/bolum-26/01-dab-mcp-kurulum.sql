-- ============================================================================
-- 01-dab-mcp-kurulum.sql
-- ----------------------------------------------------------------------------
-- SQL MCP Server için Data API Builder (DAB) hazırlık.
-- DAB komutları .sh içinde (terminal); burada SQL tarafındaki hazırlık.
-- ============================================================================

USE demo;
GO

-- Agent'ın erişeceği objeler için adanmış schema (least privilege)
IF SCHEMA_ID('agent_view') IS NULL EXEC('CREATE SCHEMA agent_view');
GO

-- View'ler ile sadece görmesi gereken sütunları aç (PII'yi maskele)
IF OBJECT_ID('agent_view.customer_summary','V') IS NOT NULL
    DROP VIEW agent_view.customer_summary;
GO
CREATE VIEW agent_view.customer_summary
AS
SELECT
    customer_id,
    full_name,
    city,
    LEFT(email, 2) + '***@' + SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS email_masked,
    created_at
FROM sales.customers;
GO

IF OBJECT_ID('agent_view.order_summary','V') IS NOT NULL
    DROP VIEW agent_view.order_summary;
GO
CREATE VIEW agent_view.order_summary
AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    o.total_amount,
    COUNT(oi.product_id) AS item_count
FROM sales.orders o
LEFT JOIN sales.order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.customer_id, o.order_date, o.status, o.total_amount;
GO

-- Agent için adanmış login (en az ayrıcalık)
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'agent_reader')
    CREATE USER agent_reader WITHOUT LOGIN;
GO

GRANT SELECT ON SCHEMA::agent_view TO agent_reader;
DENY SELECT ON SCHEMA::sales TO agent_reader;  -- ana tablolar görünmez
GO

PRINT N'Agent için adanmış view + en az ayrıcalık kullanıcı hazır';
GO

/* DAB tarafı (terminal komutları, .sh içinde):
   dotnet tool install -g Microsoft.DataApiBuilder
   dab init --database-type mssql --connection-string "..."
   dab configure --runtime-mcp-enabled true
   dab add Customer --source agent_view.customer_summary --permissions "authenticated:read"
   dab add Order --source agent_view.order_summary --permissions "authenticated:read"
   dab start  # MCP endpoint: http://localhost:5000/mcp
*/

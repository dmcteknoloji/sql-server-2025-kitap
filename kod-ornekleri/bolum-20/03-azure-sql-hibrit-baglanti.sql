-- ============================================================================
-- 03-azure-sql-hibrit-baglanti.sql
-- ----------------------------------------------------------------------------
-- On-prem SQL Server 2025 + Azure SQL DB: hibrit köprü senaryoları.
-- ============================================================================

USE demo;
GO

-- 1) Linked Server: Azure SQL DB'ye köprü
EXEC sp_addlinkedserver
    @server = N'AZUREDB',
    @srvproduct = N'',
    @provider = N'MSOLEDBSQL19',
    @datasrc = N'your-azuresql.database.windows.net',
    @catalog = N'your-db';
GO

-- Auth (Entra ID önerilir; 2025'te encryption zorunlu)
EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'AZUREDB',
    @useself = N'False',
    @rmtuser = N'app@dmcteknoloji.com',
    @rmtpassword = NULL;   -- Entra ID üstünden
GO

-- 2) Azure SQL DB'den veri çek
SELECT TOP 100 *
FROM AZUREDB.your_db.dbo.azure_table;
GO

-- 3) sp_invoke_external_rest_endpoint ile Azure SQL REST API (alternatif)
-- Azure SQL Database REST API: https://learn.microsoft.com/en-us/rest/api/sql/

-- 4) PolyBase ile Azure Blob Storage parquet okuma (2025 native)
CREATE EXTERNAL DATA SOURCE blob_storage
WITH (
    LOCATION = 'abs://container@youraccount.blob.core.windows.net',
    CREDENTIAL = blob_credential
);

CREATE EXTERNAL FILE FORMAT parquet_format
WITH (FORMAT_TYPE = PARQUET);

CREATE EXTERNAL TABLE ext_sales (
    sale_date DATE,
    product_id INT,
    quantity INT,
    total DECIMAL(14,2)
)
WITH (
    LOCATION = '/sales/2026/',
    DATA_SOURCE = blob_storage,
    FILE_FORMAT = parquet_format
);

SELECT TOP 10 * FROM ext_sales WHERE sale_date >= '2026-05-01';
GO

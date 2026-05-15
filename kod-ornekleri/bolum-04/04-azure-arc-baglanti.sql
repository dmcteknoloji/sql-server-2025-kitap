-- ============================================================================
-- 04-azure-arc-baglanti.sql
-- ----------------------------------------------------------------------------
-- SQL Server 2025'i Azure Arc'a bağlamak için kontrol script'i.
-- Fabric Mirroring (Bölüm 18), CES Entra auth (Bölüm 19) için ön koşul.
-- ============================================================================

-- Bu instance Arc'a bağlı mı?
-- Arc agent kuruluyken aşağıdaki view doluyor
SELECT *
FROM sys.dm_server_services
WHERE servicename LIKE N'%Arc%';
GO

-- Azure Arc resource ID ve managed identity
-- (Arc-enabled instance'da bu sütunlar dolu olur)
SELECT
    SERVERPROPERTY('AzureMachineName')      AS arc_machine_name,
    SERVERPROPERTY('AzureResourceGroupName') AS resource_group,
    SERVERPROPERTY('AzureSubscriptionId')   AS subscription_id;
GO

-- Arc kurulumu için PowerShell (Windows) — örnek
/*
Connect-AzAccount
Set-AzContext -SubscriptionId "<subscription-id>"

# Arc agent indir + kur
azcmagent connect `
    --resource-group "rg-sql-arc" `
    --tenant-id "<tenant>" `
    --location "westeurope" `
    --subscription-id "<subscription-id>"

# Managed identity assign et
az sql server-arc-instance create `
    --instance-name "sql2025" `
    --resource-group "rg-sql-arc"
*/

-- Linux için: /var/opt/mssql/mssql.conf düzenle, sonra Arc CLI
-- Referans:
-- https://learn.microsoft.com/en-us/sql/sql-server/azure-arc/overview

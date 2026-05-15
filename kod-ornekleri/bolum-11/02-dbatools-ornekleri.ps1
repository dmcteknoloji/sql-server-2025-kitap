# ============================================================================
# 02-dbatools-ornekleri.ps1
# ----------------------------------------------------------------------------
# dbatools (Microsoft önerdiği PowerShell modülü) ile günlük DBA işleri.
# Kurulum: Install-Module -Name dbatools -Force
# ============================================================================

Import-Module dbatools

$server = "sqlnode1.example.com"

# 1) Instance overview
Get-DbaInstanceProperty -SqlInstance $server | Format-Table Name, Value -AutoSize

# 2) Tüm DB'leri listele
Get-DbaDatabase -SqlInstance $server | Format-Table Name, Status, RecoveryModel, SizeMB -AutoSize

# 3) Backup health
Get-DbaLastBackup -SqlInstance $server | Format-Table Database, LastFullBackup, LastDiffBackup, LastLogBackup

# 4) Disk space
Get-DbaDiskSpace -ComputerName $server | Format-Table Name, Label, SizeInGB, FreeInGB, PercentFree

# 5) Wait stats (top 10)
Get-DbaWaitStatistic -SqlInstance $server | Select-Object -First 10 | Format-Table

# 6) Index fragmentation
Get-DbaIndexFragmentation -SqlInstance $server -Database demo |
    Where-Object { $_.PercentFragmentation -gt 10 } |
    Format-Table

# 7) Backup tüm DB'leri Azure'a
Backup-DbaDatabase `
    -SqlInstance $server `
    -Database demo `
    -AzureBaseUrl "https://yourstorage.blob.core.windows.net/backups" `
    -AzureCredential "AzureBackupCredential" `
    -Type Full `
    -CompressBackup

# 8) AG durumu
Get-DbaAvailabilityGroup -SqlInstance $server |
    Format-Table Name, PrimaryReplica, AvailabilityReplicas, AvailabilityDatabases

# 9) Tüm instance'lara karşı sağlık taraması
$servers = "sqlnode1.example.com","sqlnode2.example.com"
Test-DbaConnection -SqlInstance $servers | Format-Table ComputerName, ConnectSuccess, AuthScheme

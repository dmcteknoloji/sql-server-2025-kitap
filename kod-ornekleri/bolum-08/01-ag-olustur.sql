-- ============================================================================
-- 01-ag-olustur.sql
-- ----------------------------------------------------------------------------
-- Always On Availability Group oluşturma — primary tarafında.
-- Önkoşul: WSFC kurulu, endpoint'ler hazır, secondary instance erişilebilir.
-- ============================================================================

-- 1) Endpoint (her replika için bir kez)
CREATE ENDPOINT [hadr_endpoint]
    STATE = STARTED
    AS TCP (LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
        ROLE = ALL,
        AUTHENTICATION = WINDOWS NEGOTIATE,
        ENCRYPTION = REQUIRED ALGORITHM AES
    );
GO

-- 2) Availability group
CREATE AVAILABILITY GROUP [ag_demo]
WITH (
    AUTOMATED_BACKUP_PREFERENCE = SECONDARY,
    DB_FAILOVER = ON,
    DTC_SUPPORT = NONE,
    CLUSTER_TYPE = WSFC,                    -- Linux'ta EXTERNAL veya NONE
    REQUIRED_SYNCHRONIZED_SECONDARIES_TO_COMMIT = 1
)
FOR DATABASE demo
REPLICA ON
    'SQLNODE1' WITH (
        ENDPOINT_URL = 'TCP://sqlnode1.example.com:5022',
        AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
        FAILOVER_MODE = AUTOMATIC,
        SEEDING_MODE = AUTOMATIC,
        SECONDARY_ROLE (
            ALLOW_CONNECTIONS = READ_ONLY,
            READ_ONLY_ROUTING_URL = 'TCP://sqlnode1.example.com:1433'
        ),
        BACKUP_PRIORITY = 50
    ),
    'SQLNODE2' WITH (
        ENDPOINT_URL = 'TCP://sqlnode2.example.com:5022',
        AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
        FAILOVER_MODE = AUTOMATIC,
        SEEDING_MODE = AUTOMATIC,
        SECONDARY_ROLE (
            ALLOW_CONNECTIONS = READ_ONLY,
            READ_ONLY_ROUTING_URL = 'TCP://sqlnode2.example.com:1433'
        ),
        BACKUP_PRIORITY = 100
    ),
    'SQLNODE3' WITH (
        ENDPOINT_URL = 'TCP://sqlnode3.example.com:5022',
        AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
        FAILOVER_MODE = MANUAL,
        SEEDING_MODE = AUTOMATIC,
        BACKUP_PRIORITY = 50
    );
GO

-- 3) Secondary'larda join
-- ALTER AVAILABILITY GROUP [ag_demo] JOIN;
-- ALTER AVAILABILITY GROUP [ag_demo] GRANT CREATE ANY DATABASE;

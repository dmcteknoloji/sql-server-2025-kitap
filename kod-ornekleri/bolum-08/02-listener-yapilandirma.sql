-- ============================================================================
-- 02-listener-yapilandirma.sql
-- ----------------------------------------------------------------------------
-- AG listener: client'lar tek isimle bağlanır; failover şeffaf.
-- ============================================================================

ALTER AVAILABILITY GROUP [ag_demo]
ADD LISTENER 'aglistener' (
    WITH IP ((N'10.0.0.10', N'255.255.255.0')),
    PORT = 1433
);
GO

-- Read-only routing list (her replika için)
ALTER AVAILABILITY GROUP [ag_demo]
MODIFY REPLICA ON 'SQLNODE1' WITH (
    PRIMARY_ROLE (READ_ONLY_ROUTING_LIST = (('SQLNODE2','SQLNODE3'), 'SQLNODE1'))
);
GO

-- IP yönetimi (2025: REMOVE IP destekleniyor)
-- ALTER AVAILABILITY GROUP [ag_demo]
-- MODIFY LISTENER 'aglistener' (REMOVE IP (N'10.0.0.10'));

-- Client connection string örneği
-- Server=tcp:aglistener,1433;Database=demo;
--   Encrypt=true;TrustServerCertificate=false;
--   ApplicationIntent=ReadWrite;
--   MultiSubnetFailover=true;

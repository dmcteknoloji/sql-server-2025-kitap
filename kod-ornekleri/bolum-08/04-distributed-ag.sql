-- ============================================================================
-- 04-distributed-ag.sql
-- ----------------------------------------------------------------------------
-- Distributed Availability Group: iki ayrı cluster'daki AG'leri köprüler.
-- DR senaryosu için tipik.
-- ============================================================================

-- Primary cluster'da: ag_demo zaten var
-- DR site'ta: ag_demo_dr ayrı bir AG (kendi cluster'ında)

-- Distributed AG, primary cluster'dan oluşturulur:
CREATE AVAILABILITY GROUP [dag_demo]
WITH (
    DISTRIBUTED
)
AVAILABILITY GROUP ON
    'ag_demo' WITH (
        LISTENER_URL = 'tcp://aglistener.example.com:5022',
        AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
        FAILOVER_MODE = MANUAL,
        SEEDING_MODE = AUTOMATIC
    ),
    'ag_demo_dr' WITH (
        LISTENER_URL = 'tcp://aglistener-dr.example.com:5022',
        AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
        FAILOVER_MODE = MANUAL,
        SEEDING_MODE = AUTOMATIC
    );
GO

-- DR site'ta join
-- ALTER AVAILABILITY GROUP [dag_demo] JOIN AVAILABILITY GROUP ON ag_demo_dr;

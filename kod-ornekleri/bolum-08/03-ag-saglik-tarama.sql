-- ============================================================================
-- 03-ag-saglik-tarama.sql
-- ----------------------------------------------------------------------------
-- AG durumunu, sync state ve gecikme metriklerini izleme.
-- ============================================================================

-- Replica durumu
SELECT
    ag.name AS ag_name,
    ar.replica_server_name,
    ars.role_desc,
    ars.connected_state_desc,
    ars.synchronization_health_desc,
    ars.operational_state_desc
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar ON ar.group_id = ag.group_id
JOIN sys.dm_hadr_availability_replica_states ars ON ars.replica_id = ar.replica_id;
GO

-- Database-level sync durumu + log send queue + redo queue
SELECT
    dc.database_name,
    ar.replica_server_name,
    drs.synchronization_state_desc,
    drs.synchronization_health_desc,
    drs.log_send_queue_size,
    drs.log_send_rate,
    drs.redo_queue_size,
    drs.redo_rate,
    drs.last_commit_time,
    drs.last_redone_time
FROM sys.dm_hadr_database_replica_states drs
JOIN sys.availability_databases_cluster dc ON dc.group_database_id = drs.group_database_id
JOIN sys.availability_replicas ar ON ar.replica_id = drs.replica_id
ORDER BY dc.database_name, ar.replica_server_name;
GO

-- AG metrik history (2025'te commit time milisaniyede)
SELECT
    replica_id,
    group_id,
    last_received_time,
    last_hardened_time,
    last_commit_time,
    log_send_rate,
    redo_rate
FROM sys.dm_hadr_database_replica_states
ORDER BY group_id;
GO

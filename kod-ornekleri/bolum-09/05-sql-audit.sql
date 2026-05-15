-- ============================================================================
-- 05-sql-audit.sql
-- ----------------------------------------------------------------------------
-- SQL Server Audit: kim ne yaptı, dosyaya / Windows event log'a.
-- KVKK ve EU AI Act denetim izi için temel.
-- ============================================================================

USE master;
GO

-- 1) Server audit hedefi (dosya)
CREATE SERVER AUDIT [audit_demo]
TO FILE (
    FILEPATH = N'C:\Audit\',
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 50,
    RESERVE_DISK_SPACE = OFF
)
WITH (
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE
);
GO

ALTER SERVER AUDIT [audit_demo] WITH (STATE = ON);
GO

-- 2) Server-level audit specification (login, role member değişimleri)
CREATE SERVER AUDIT SPECIFICATION [audit_server_spec]
FOR SERVER AUDIT [audit_demo]
    ADD (FAILED_LOGIN_GROUP),
    ADD (SUCCESSFUL_LOGIN_GROUP),
    ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
    ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),
    ADD (LOGIN_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);
GO

-- 3) Database-level audit (sensitive table'a erişim)
USE demo;
GO

CREATE DATABASE AUDIT SPECIFICATION [audit_db_spec]
FOR SERVER AUDIT [audit_demo]
    ADD (SELECT, INSERT, UPDATE, DELETE ON sales.customers BY public),
    ADD (SELECT ON sales.payments BY public)
WITH (STATE = ON);
GO

-- 4) Audit kayıtlarını oku
SELECT
    event_time,
    action_id,
    succeeded,
    server_principal_name,
    database_name,
    object_name,
    statement
FROM sys.fn_get_audit_file(N'C:\Audit\audit_demo*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
GO

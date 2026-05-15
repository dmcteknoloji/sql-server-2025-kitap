-- ============================================================================
-- 04-plan-forcing.sql
-- ----------------------------------------------------------------------------
-- Query Store ile plan zorlama: regression olmuş sorguya eski iyi planı geri ver.
-- ============================================================================

USE demo;
GO

-- 1) Regression olmuş sorguyu Query Store'da bul
WITH plan_versions AS (
    SELECT
        q.query_id,
        qt.query_sql_text,
        p.plan_id,
        rs.avg_cpu_time,
        rs.last_execution_time,
        ROW_NUMBER() OVER (PARTITION BY q.query_id ORDER BY rs.avg_cpu_time) AS rank_fastest
    FROM sys.query_store_query q
    JOIN sys.query_store_query_text qt ON qt.query_text_id = q.query_text_id
    JOIN sys.query_store_plan p  ON p.query_id = q.query_id
    JOIN sys.query_store_runtime_stats rs ON rs.plan_id = p.plan_id
    WHERE rs.last_execution_time > DATEADD(HOUR, -24, SYSDATETIMEOFFSET())
)
SELECT query_id, plan_id, query_sql_text, avg_cpu_time
FROM plan_versions
WHERE rank_fastest = 1;   -- en iyi plan
GO

-- 2) En iyi planı zorla
-- EXEC sys.sp_query_store_force_plan @query_id = 42, @plan_id = 17;

-- 3) Zorlanan planları listele
SELECT
    p.query_id,
    p.plan_id,
    p.is_forced_plan,
    p.force_failure_count,
    p.last_force_failure_reason_desc
FROM sys.query_store_plan p
WHERE p.is_forced_plan = 1;
GO

-- 4) Plan forcing'i kaldır
-- EXEC sys.sp_query_store_unforce_plan @query_id = 42, @plan_id = 17;

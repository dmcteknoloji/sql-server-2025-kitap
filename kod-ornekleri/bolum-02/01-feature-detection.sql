-- ============================================================================
-- 01-feature-detection.sql
-- ----------------------------------------------------------------------------
-- SQL Server 2025 ana yeniliklerinin instance'ınızda aktif olup olmadığını
-- test eder. CU sürümünüze ve preview ayarına göre sonuç değişir.
-- ============================================================================

PRINT N'--- Vector tipi ---';
BEGIN TRY
    DECLARE @v VECTOR(3) = '[1.0, 2.0, 3.0]';
    PRINT N'  VECTOR tipi: AKTİF';
END TRY
BEGIN CATCH
    PRINT N'  VECTOR tipi: HATA — ' + ERROR_MESSAGE();
END CATCH;
GO

PRINT N'--- Regex fonksiyonları ---';
BEGIN TRY
    -- REGEXP_LIKE bir predicate'tir; SELECT column olarak değil CASE/WHERE içinde kullanılır
    DECLARE @rx INT = (SELECT CASE WHEN REGEXP_LIKE(N'test123', N'\d+') THEN 1 ELSE 0 END);
    IF @rx = 1 PRINT N'  REGEXP_LIKE: AKTİF'; ELSE PRINT N'  REGEXP_LIKE: BEKLENMEYEN SONUÇ';
END TRY
BEGIN CATCH
    PRINT N'  REGEXP_LIKE: HATA — ' + ERROR_MESSAGE();
END CATCH;
GO

PRINT N'--- Fuzzy matching ---';
BEGIN TRY
    SELECT EDIT_DISTANCE(N'kitap', N'kitab') AS edit_dist;
    PRINT N'  EDIT_DISTANCE: AKTİF';
END TRY
BEGIN CATCH
    PRINT N'  EDIT_DISTANCE: HATA — ' + ERROR_MESSAGE();
END CATCH;
GO

PRINT N'--- JSON tipi (native binary) ---';
BEGIN TRY
    DECLARE @j JSON = '{"name":"Çağlar","role":"MVP"}';
    PRINT N'  JSON tipi: AKTİF';
END TRY
BEGIN CATCH
    PRINT N'  JSON tipi: HATA — ' + ERROR_MESSAGE();
END CATCH;
GO

PRINT N'--- AI_GENERATE_EMBEDDINGS (external model gerekir) ---';
SELECT
    CASE WHEN OBJECT_ID('sys.external_models','U') IS NOT NULL
              OR EXISTS(SELECT 1 FROM sys.system_objects WHERE name = N'ai_generate_embeddings')
         THEN N'AKTİF (function var, external model kurulu mu kontrol et)'
         ELSE N'YOK'
    END AS ai_generate_status;
GO

PRINT N'--- Change Event Streaming (CES) ---';
SELECT
    CASE WHEN EXISTS(SELECT 1 FROM sys.system_objects WHERE name = N'sp_create_event_stream_group')
         THEN N'AKTİF'
         ELSE N'YOK'
    END AS ces_status;
GO

PRINT N'--- Optimized Locking ---';
SELECT name, value, value_in_use, description
FROM sys.configurations
WHERE name LIKE '%lock%' OR name LIKE '%adr%' OR name LIKE '%optimized%';
GO

PRINT N'--- Compatibility level ---';
SELECT name, compatibility_level
FROM sys.databases
WHERE database_id > 4;
GO

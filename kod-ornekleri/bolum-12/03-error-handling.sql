-- ============================================================================
-- 03-error-handling.sql
-- ----------------------------------------------------------------------------
-- TRY...CATCH, THROW, transaction-safe pattern.
-- ============================================================================

USE demo;
GO

-- 1) TRY...CATCH temel
BEGIN TRY
    BEGIN TRAN;

    INSERT INTO sales.customers (full_name, email, city)
    VALUES (N'Test 1', N'test1@example.com', N'X');

    -- Duplicate (constraint hatası alacak)
    INSERT INTO sales.customers (full_name, email, city)
    VALUES (N'Test 2', N'test1@example.com', N'X');

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    PRINT N'Hata: ' + ERROR_MESSAGE();
    PRINT N'Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
    PRINT N'State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
    PRINT N'Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
END CATCH;
GO

-- Cleanup
DELETE FROM sales.customers WHERE email = N'test1@example.com';
GO

-- 2) THROW (custom error)
CREATE OR ALTER PROCEDURE sales.usp_create_order
    @customer_id INT,
    @total DECIMAL(14,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = @customer_id)
        THROW 50001, N'Geçersiz müşteri ID', 1;

    IF @total <= 0
        THROW 50002, N'Sipariş tutarı pozitif olmalı', 1;

    INSERT INTO sales.orders (customer_id, total_amount, status)
    VALUES (@customer_id, @total, N'pending');

    SELECT SCOPE_IDENTITY() AS new_order_id;
END;
GO

-- Test
BEGIN TRY
    EXEC sales.usp_create_order @customer_id = 999, @total = 100;
END TRY
BEGIN CATCH
    PRINT N'Beklenen hata: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 3) ATOMIC block (natively compiled SP için)
-- Bu sadece in-memory OLTP'de geçerli.
-- CREATE PROCEDURE ... WITH NATIVE_COMPILATION, SCHEMABINDING
-- AS BEGIN ATOMIC WITH (...) ... END;

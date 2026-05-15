-- ============================================================================
-- 04-tsqlt-unit-test.sql
-- ----------------------------------------------------------------------------
-- tSQLt: T-SQL için unit test framework.
-- Kurulum: https://tsqlt.org/downloads/
-- ============================================================================

USE demo;
GO

-- Test class (schema) oluştur
EXEC tSQLt.NewTestClass 'tests_sales';
GO

-- Test 1: usp_create_order başarılı senaryo
CREATE OR ALTER PROCEDURE tests_sales.[test usp_create_order inserts a row]
AS
BEGIN
    -- Arrange: gerçek tabloyu izole et (FakeTable)
    EXEC tSQLt.FakeTable 'sales.orders', @Identity = 1;

    -- Act
    EXEC sales.usp_create_order @customer_id = 1, @total = 100.00;

    -- Assert
    DECLARE @actual INT = (SELECT COUNT(*) FROM sales.orders);
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @actual;
END;
GO

-- Test 2: invalid customer_id THROW etmeli
CREATE OR ALTER PROCEDURE tests_sales.[test usp_create_order throws for invalid customer]
AS
BEGIN
    EXEC tSQLt.FakeTable 'sales.orders';
    EXEC tSQLt.FakeTable 'sales.customers';

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%Geçersiz müşteri ID%';

    EXEC sales.usp_create_order @customer_id = 999, @total = 100;
END;
GO

-- Test 3: negatif total THROW
CREATE OR ALTER PROCEDURE tests_sales.[test usp_create_order rejects negative total]
AS
BEGIN
    EXEC tSQLt.FakeTable 'sales.orders';

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%pozitif%';

    EXEC sales.usp_create_order @customer_id = 1, @total = -50;
END;
GO

-- Tüm testleri çalıştır
EXEC tSQLt.RunAll;
GO

-- Belirli class
-- EXEC tSQLt.Run 'tests_sales';

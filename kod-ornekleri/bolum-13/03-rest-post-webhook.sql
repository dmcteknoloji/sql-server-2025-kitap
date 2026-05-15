-- ============================================================================
-- 03-rest-post-webhook.sql
-- ----------------------------------------------------------------------------
-- Slack/Teams webhook ile sipariş alındı bildirimi.
-- T-SQL içinden uygulama gerektirmeden mesaj.
-- ============================================================================

USE demo;
GO

CREATE OR ALTER PROCEDURE sales.usp_notify_order_slack
    @order_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @customer_name NVARCHAR(200);
    DECLARE @total DECIMAL(14,2);
    DECLARE @order_date DATETIME2(0);

    SELECT
        @customer_name = c.full_name,
        @total = o.total_amount,
        @order_date = o.order_date
    FROM sales.orders o
    JOIN sales.customers c ON c.customer_id = o.customer_id
    WHERE o.order_id = @order_id;

    DECLARE @payload NVARCHAR(MAX) = (
        SELECT
            CONCAT(N'Yeni sipariş: #', @order_id, N' — ', @customer_name,
                   N' — ', FORMAT(@total, N'C', N'tr-TR')) AS text
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    DECLARE @response NVARCHAR(MAX);
    EXEC sp_invoke_external_rest_endpoint
        @url = N'https://hooks.slack.com/services/T0/B0/X',
        @method = N'POST',
        @payload = @payload,
        @timeout = 10,
        @response = @response OUTPUT;
END;
GO

-- Trigger: yeni sipariş insert edildiğinde otomatik bildir
CREATE OR ALTER TRIGGER sales.tr_orders_slack
ON sales.orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @oid BIGINT;
    SELECT @oid = order_id FROM inserted;
    EXEC sales.usp_notify_order_slack @order_id = @oid;
END;
GO

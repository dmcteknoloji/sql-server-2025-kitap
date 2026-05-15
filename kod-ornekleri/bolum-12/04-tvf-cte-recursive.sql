-- ============================================================================
-- 04-tvf-cte-recursive.sql
-- ----------------------------------------------------------------------------
-- Inline TVF, CTE, recursive CTE — modern T-SQL.
-- ============================================================================

USE demo;
GO

-- 1) Inline TVF (en performanslı kullanıcı fonksiyonu)
CREATE OR ALTER FUNCTION sales.ufn_customer_orders(@customer_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT o.order_id, o.order_date, o.total_amount, o.status
    FROM sales.orders o
    WHERE o.customer_id = @customer_id
);
GO

SELECT * FROM sales.ufn_customer_orders(1);
GO

-- 2) CTE (Common Table Expression)
WITH order_totals AS (
    SELECT
        c.customer_id,
        c.full_name,
        COUNT(o.order_id) AS order_count,
        ISNULL(SUM(o.total_amount), 0) AS total_spent
    FROM sales.customers c
    LEFT JOIN sales.orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.full_name
)
SELECT *
FROM order_totals
WHERE total_spent > 500;
GO

-- 3) Recursive CTE: ürün kategorisi ağacı (örnek için yeni tablo)
IF OBJECT_ID('sales.category_tree','U') IS NULL
BEGIN
    CREATE TABLE sales.category_tree (
        category_id INT NOT NULL PRIMARY KEY,
        name NVARCHAR(120) NOT NULL,
        parent_id INT NULL REFERENCES sales.category_tree(category_id)
    );
END;

INSERT INTO sales.category_tree VALUES
(1, N'Tüm Ürünler', NULL),
(2, N'Kitap', 1),
(3, N'Elektronik', 1),
(4, N'Roman', 2),
(5, N'Teknik', 2),
(6, N'Bilgisayar Çevre', 3),
(7, N'Mobil', 3);

WITH category_hierarchy AS (
    -- Anchor: en üst seviye
    SELECT category_id, name, parent_id, 0 AS depth, CAST(name AS NVARCHAR(MAX)) AS path
    FROM sales.category_tree
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive: alt kategoriler
    SELECT
        c.category_id, c.name, c.parent_id, ch.depth + 1,
        ch.path + N' / ' + c.name
    FROM sales.category_tree c
    JOIN category_hierarchy ch ON c.parent_id = ch.category_id
)
SELECT depth, path
FROM category_hierarchy
ORDER BY path;
GO

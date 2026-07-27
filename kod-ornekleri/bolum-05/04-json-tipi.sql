-- ============================================================================
-- 04-json-tipi.sql
-- ----------------------------------------------------------------------------
-- Native JSON tipi (binary format) — 2025'te NVARCHAR(MAX) yerine kullanılır.
-- ============================================================================

USE demo;
GO

-- JSON tipi sütunlu tablo
IF OBJECT_ID('sales.customer_preferences','U') IS NULL
BEGIN
    CREATE TABLE sales.customer_preferences (
        customer_id INT NOT NULL PRIMARY KEY REFERENCES sales.customers(customer_id),
        prefs       JSON NOT NULL
    );
END
GO

-- Insert
DELETE FROM sales.customer_preferences;
INSERT INTO sales.customer_preferences (customer_id, prefs) VALUES
(1, '{"language":"tr","newsletter":true,"favorite_categories":["Kitap","Elektronik"]}'),
(2, '{"language":"tr","newsletter":false,"favorite_categories":["Elektronik"]}'),
(3, '{"language":"en","newsletter":true,"favorite_categories":["Gıda","Kitap"]}');
GO

-- JSON_VALUE: bir alanı oku
SELECT
    c.full_name,
    JSON_VALUE(cp.prefs, '$.language')  AS lang,
    JSON_VALUE(cp.prefs, '$.newsletter') AS newsletter
FROM sales.customers c
JOIN sales.customer_preferences cp ON cp.customer_id = c.customer_id;
GO

-- JSON_QUERY: alt-obje veya array oku
SELECT
    c.full_name,
    JSON_QUERY(cp.prefs, '$.favorite_categories') AS fav_cats
FROM sales.customers c
JOIN sales.customer_preferences cp ON cp.customer_id = c.customer_id;
GO

-- JSON_OBJECTAGG: satırları JSON objeye agrega et
SELECT JSON_OBJECTAGG(p.sku : p.price) AS price_map
FROM sales.products p;
GO

-- JSON_ARRAYAGG: satırları JSON array'e agrega et
SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        'product_id' : p.product_id,
        'name' : p.name,
        'price' : p.price
    )
) AS products_json
FROM sales.products p;
GO

-- JSON path ile UPDATE (modify)
UPDATE sales.customer_preferences
SET prefs = JSON_MODIFY(prefs, '$.newsletter', CAST(0 AS BIT))
WHERE customer_id = 1;
GO

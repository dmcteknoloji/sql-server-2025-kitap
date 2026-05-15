-- ============================================================================
-- 04-ddm-maskeleme.sql
-- ----------------------------------------------------------------------------
-- Dynamic Data Masking: hassas sütunlar maskelenmiş görünür.
-- Sadece UNMASK yetkili kullanıcı gerçek değeri görür.
-- ============================================================================

USE demo;
GO

-- E-posta maskele
ALTER TABLE sales.customers
ALTER COLUMN email
ADD MASKED WITH (FUNCTION = 'email()');
GO

-- Telefon (varsayılan)
ALTER TABLE sales.customers
ALTER COLUMN phone
ADD MASKED WITH (FUNCTION = 'default()');
GO

-- TC kimlik sütunu örneği (eklendiğini varsay)
-- ALTER TABLE sales.customers ADD national_id CHAR(11) NULL;
-- ALTER TABLE sales.customers
-- ALTER COLUMN national_id
-- ADD MASKED WITH (FUNCTION = 'partial(2,"*******",2)');  -- 12*******34

-- Test: az yetkili kullanıcı maskelenmiş görür
CREATE USER masked_user WITHOUT LOGIN;
GRANT SELECT ON sales.customers TO masked_user;
GO

EXECUTE AS USER = 'masked_user';
SELECT TOP 5 full_name, email, phone FROM sales.customers;
REVERT;
GO

-- UNMASK yetkisi ver
GRANT UNMASK TO masked_user;

EXECUTE AS USER = 'masked_user';
SELECT TOP 5 full_name, email, phone FROM sales.customers;
REVERT;
GO

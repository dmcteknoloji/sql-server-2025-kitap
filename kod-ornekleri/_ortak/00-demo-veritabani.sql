-- ============================================================================
-- 00-demo-veritabani.sql
-- ----------------------------------------------------------------------------
-- Kitap genelindeki örnekler için minimal demo veritabanı.
-- SQL Server 2025 GA (CU4+) gerektirir; compatibility level 170.
-- Çalıştır: sqlcmd -S localhost -i _ortak/00-demo-veritabani.sql
-- ============================================================================

USE master;
GO

IF DB_ID('demo') IS NOT NULL
BEGIN
    ALTER DATABASE demo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE demo;
END
GO

CREATE DATABASE demo;
GO

ALTER DATABASE demo SET COMPATIBILITY_LEVEL = 170;
ALTER DATABASE demo SET ACCELERATED_DATABASE_RECOVERY = ON;
ALTER DATABASE demo SET READ_COMMITTED_SNAPSHOT ON;
GO

-- Preview özellikler (vector index, fuzzy matching, CES) için
ALTER DATABASE demo SET COMPATIBILITY_LEVEL = 170;
GO
USE demo;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO

-- ----------------------------------------------------------------------------
-- 1) Temel tablolar — Kısım I-IV örnekleri için
-- ----------------------------------------------------------------------------

CREATE SCHEMA sales;
GO

CREATE TABLE sales.customers (
    customer_id    INT          NOT NULL IDENTITY PRIMARY KEY,
    full_name      NVARCHAR(200) NOT NULL,
    email          NVARCHAR(254) NOT NULL UNIQUE,
    phone          NVARCHAR(20)  NULL,
    city           NVARCHAR(80)  NULL,
    created_at     DATETIME2(0)  NOT NULL CONSTRAINT df_customers_created DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE sales.products (
    product_id     INT           NOT NULL IDENTITY PRIMARY KEY,
    sku            NVARCHAR(40)  NOT NULL UNIQUE,
    name           NVARCHAR(200) NOT NULL,
    category       NVARCHAR(80)  NOT NULL,
    price          DECIMAL(12,2) NOT NULL,
    description    NVARCHAR(MAX) NULL,
    created_at     DATETIME2(0)  NOT NULL CONSTRAINT df_products_created DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE sales.orders (
    order_id       BIGINT        NOT NULL IDENTITY PRIMARY KEY,
    customer_id    INT           NOT NULL REFERENCES sales.customers(customer_id),
    order_date     DATETIME2(0)  NOT NULL CONSTRAINT df_orders_date DEFAULT SYSUTCDATETIME(),
    status         NVARCHAR(20)  NOT NULL CONSTRAINT df_orders_status DEFAULT 'pending',
    total_amount   DECIMAL(14,2) NOT NULL
);
GO

CREATE TABLE sales.order_items (
    order_id       BIGINT        NOT NULL REFERENCES sales.orders(order_id),
    product_id     INT           NOT NULL REFERENCES sales.products(product_id),
    quantity       INT           NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id)
);
GO

-- Örnek müşteriler (gerçek değil; test verisi)
INSERT INTO sales.customers (full_name, email, phone, city) VALUES
(N'Ayşe Demir',   N'ayse.demir@example.com',   N'+90 532 000 0001', N'İstanbul'),
(N'Mehmet Yılmaz',N'mehmet.yilmaz@example.com',N'+90 532 000 0002', N'Ankara'),
(N'Zeynep Kaya',  N'zeynep.kaya@example.com',  N'+90 532 000 0003', N'İzmir'),
(N'Ali Çelik',    N'ali.celik@example.com',    N'+90 532 000 0004', N'Bursa'),
(N'Fatma Şahin',  N'fatma.sahin@example.com',  N'+90 532 000 0005', N'Antalya');
GO

INSERT INTO sales.products (sku, name, category, price, description) VALUES
(N'BK-001', N'Veri Mimarisi Kitabı',          N'Kitap',      450.00, N'Veritabanı sistemlerinde modern mimari yaklaşımları'),
(N'BK-002', N'SQL Server Performans Tuning',  N'Kitap',      520.00, N'Query Store ve IQP ile detaylı performans optimizasyonu'),
(N'EL-001', N'Mekanik Klavye',                N'Elektronik', 1850.00, N'Cherry MX Brown switch, RGB aydınlatma'),
(N'EL-002', N'27 inç Monitor',                N'Elektronik', 4500.00, N'4K çözünürlük, IPS panel, USB-C dock'),
(N'KH-001', N'Kahve Çekirdeği 1kg',           N'Gıda',       350.00, N'Etiyopya Yirgacheffe single origin');
GO

INSERT INTO sales.orders (customer_id, order_date, status, total_amount) VALUES
(1, '2026-04-15 10:30:00', 'completed', 970.00),
(2, '2026-04-18 14:20:00', 'completed', 1850.00),
(3, '2026-05-02 09:15:00', 'pending',   4850.00),
(1, '2026-05-10 16:45:00', 'completed', 700.00);
GO

INSERT INTO sales.order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 450.00),(1, 2, 1, 520.00),
(2, 3, 1, 1850.00),
(3, 4, 1, 4500.00),(3, 5, 1, 350.00),
(4, 5, 2, 350.00);
GO

-- ----------------------------------------------------------------------------
-- 2) Graph node/edge tabloları — Bölüm 2 ve DMC Mağaza örnekleri için
-- ----------------------------------------------------------------------------
-- SQL Server Graph Database (2017+) ile arkadaşlık, ürün benzerliği, vb.

CREATE SCHEMA social;
GO

CREATE TABLE social.person (
    person_id   INT           NOT NULL IDENTITY PRIMARY KEY,
    name        NVARCHAR(120) NOT NULL,
    city        NVARCHAR(80)  NULL
) AS NODE;
GO

CREATE TABLE social.friend_of (
    since_date  DATE NULL
) AS EDGE;
GO

CREATE TABLE social.bought (
    purchase_date DATE NULL,
    rating        TINYINT NULL
) AS EDGE;
GO

INSERT INTO social.person (name, city) VALUES
(N'Ayşe',  N'İstanbul'),
(N'Mehmet',N'Ankara'),
(N'Zeynep',N'İzmir'),
(N'Ali',   N'Bursa'),
(N'Fatma', N'Antalya');
GO

-- Arkadaşlık edge'leri (yönlü; senaryomuzda bidirectional yorumlanır)
INSERT INTO social.friend_of ($from_id, $to_id, since_date)
VALUES
((SELECT $node_id FROM social.person WHERE name=N'Ayşe'),
 (SELECT $node_id FROM social.person WHERE name=N'Mehmet'), '2024-01-10'),
((SELECT $node_id FROM social.person WHERE name=N'Mehmet'),
 (SELECT $node_id FROM social.person WHERE name=N'Zeynep'), '2024-03-22'),
((SELECT $node_id FROM social.person WHERE name=N'Zeynep'),
 (SELECT $node_id FROM social.person WHERE name=N'Ali'),    '2025-02-14'),
((SELECT $node_id FROM social.person WHERE name=N'Ali'),
 (SELECT $node_id FROM social.person WHERE name=N'Fatma'),  '2025-06-30');
GO

-- ----------------------------------------------------------------------------
-- 3) Vector tablo iskeleti — Kısım V örnekleri için
-- ----------------------------------------------------------------------------
-- VECTOR_SEARCH ve embeddings örnekleri buraya yazar.

CREATE SCHEMA ai;
GO

CREATE TABLE ai.document_chunks (
    -- Vector index önkoşulu: clustered PK tek bir 4 baytlık INT sütun olmalı (Msg 42217).
    -- BIGINT kullanılırsa CREATE VECTOR INDEX reddedilir.
    chunk_id      INT          NOT NULL IDENTITY PRIMARY KEY,
    source_doc    NVARCHAR(200) NOT NULL,
    chunk_index   INT          NOT NULL,
    content       NVARCHAR(MAX) NOT NULL,
    embedding     VECTOR(1536) NULL,   -- text-embedding-3-small boyutu
    created_at    DATETIME2(0) NOT NULL CONSTRAINT df_chunks_created DEFAULT SYSUTCDATETIME()
);
GO

PRINT 'Demo veritabanı hazır: sales (relational), social (graph), ai (vector).';
GO

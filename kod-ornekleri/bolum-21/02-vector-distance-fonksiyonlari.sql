-- ============================================================================
-- 02-vector-distance-fonksiyonlari.sql
-- ----------------------------------------------------------------------------
-- VECTOR_DISTANCE: cosine, euclidean, dot product.
-- ============================================================================

USE demo;
GO

-- Test vektörler
DECLARE @v1 VECTOR(3) = '[1.0, 0.0, 0.0]';
DECLARE @v2 VECTOR(3) = '[0.0, 1.0, 0.0]';   -- orthogonal
DECLARE @v3 VECTOR(3) = '[1.0, 0.0, 0.0]';   -- v1 ile aynı
DECLARE @v4 VECTOR(3) = '[0.7071, 0.7071, 0.0]'; -- 45° v1'den

-- Cosine distance: 0 = aynı yön, 2 = zıt yön
SELECT
    VECTOR_DISTANCE('cosine', @v1, @v2) AS orthogonal_dist,   -- ~1.0
    VECTOR_DISTANCE('cosine', @v1, @v3) AS same_dist,         -- 0.0
    VECTOR_DISTANCE('cosine', @v1, @v4) AS angle_dist;        -- ~0.293 (1 - cos(45°))
GO

-- Euclidean distance: L2 norm
-- SQL Server'da PostgreSQL'in '::' cast operatörü YOKTUR; CAST(... AS ...) kullanılır.
DECLARE @u1 VECTOR(2) = CAST('[1.0, 0.0]' AS VECTOR(2));
DECLARE @u2 VECTOR(2) = CAST('[0.0, 1.0]' AS VECTOR(2));
DECLARE @u3 VECTOR(2) = CAST('[3.0, 4.0]' AS VECTOR(2));
DECLARE @u0 VECTOR(2) = CAST('[0.0, 0.0]' AS VECTOR(2));

SELECT
    VECTOR_DISTANCE('euclidean', @u1, @u2) AS euclid_unit_diag,  -- sqrt(2) ≈ 1.414
    VECTOR_DISTANCE('euclidean', @u0, @u3) AS euclid_345;        -- 5.0
GO

-- Dot product (inner product) — negative similarity
DECLARE @d1 VECTOR(2) = CAST('[1.0, 0.0]' AS VECTOR(2));
DECLARE @d2 VECTOR(2) = CAST('[0.0, 1.0]' AS VECTOR(2));
SELECT
    VECTOR_DISTANCE('dot', @d1, @d1) AS dot_same,    -- -1 (negate)
    VECTOR_DISTANCE('dot', @d1, @d2) AS dot_ortho;   -- 0
GO

-- VECTOR_NORM, VECTOR_NORMALIZE (L2)
-- VECTOR_NORM imzası: (vector, norm_type) — norm1 / norm2 / norminf
DECLARE @v VECTOR(3) = '[3.0, 4.0, 0.0]';
SELECT
    VECTOR_NORM(@v, 'norm2') AS magnitude_l2,   -- 5 (L2/Euclidean)
    VECTOR_NORM(@v, 'norm1') AS magnitude_l1,   -- 7 (Manhattan)
    VECTOR_NORMALIZE(@v, 'norm2') AS unit_vec;  -- [0.6, 0.8, 0]
GO

-- Pratik: iki ürün açıklamasının benzerliği
-- (embedding'leri gerçek modelden alınmalı; burada placeholder)
DECLARE @prod1_emb VECTOR(3) = '[0.1, 0.2, 0.3]';
DECLARE @prod2_emb VECTOR(3) = '[0.15, 0.25, 0.32]';
DECLARE @prod3_emb VECTOR(3) = '[0.8, -0.1, 0.5]';

SELECT
    'prod1 vs prod2' AS pair, VECTOR_DISTANCE('cosine', @prod1_emb, @prod2_emb) AS cos_dist
UNION ALL SELECT
    'prod1 vs prod3', VECTOR_DISTANCE('cosine', @prod1_emb, @prod3_emb);
GO

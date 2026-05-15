-- ============================================================================
-- 02-graph-mini-ornek.sql
-- ----------------------------------------------------------------------------
-- Graph node/edge tablolar, MATCH operatörü ve SHORTEST_PATH.
-- Önkoşul: _ortak/00-demo-veritabani.sql çalıştırılmış olmalı.
-- ============================================================================

USE demo;
GO

-- 1) Direkt arkadaşları bul (MATCH operatörü)
SELECT
    p1.name AS person,
    p2.name AS friend,
    f.since_date
FROM social.person p1,
     social.friend_of f,
     social.person p2
WHERE MATCH(p1-(f)->p2)
ORDER BY p1.name;
GO

-- 2) Belirli bir kişinin (Ayşe) tüm direkt arkadaşları
SELECT p2.name AS direct_friend
FROM social.person p1,
     social.friend_of f,
     social.person p2
WHERE MATCH(p1-(f)->p2)
  AND p1.name = N'Ayşe';
GO

-- 3) İki kişi arasında en kısa yol (SHORTEST_PATH; 2019+)
-- "Ayşe'den Fatma'ya kaç kişi atlayarak ulaşırım?"
-- ÖNEMLİ: SHORTEST_PATH ile elde edilen path agg fonksiyonları
-- (LAST_VALUE/STRING_AGG/COUNT WITHIN GROUP (GRAPH PATH)) WHERE clause'unda
-- doğrudan filtrelemez (Msg 13961). Outer query ile filtrelenir.
SELECT *
FROM (
    SELECT
        p1.name AS start_node,
        STRING_AGG(p2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS friendship_path,
        LAST_VALUE(p2.name) WITHIN GROUP (GRAPH PATH) AS end_node,
        COUNT(p2.name) WITHIN GROUP (GRAPH PATH) AS hops
    FROM social.person AS p1,
         social.friend_of FOR PATH AS f,
         social.person FOR PATH AS p2
    WHERE MATCH(SHORTEST_PATH(p1(-(f)->p2)+))
      AND p1.name = N'Ayşe'
) AS sp
WHERE sp.end_node = N'Fatma';
GO

-- 4) Bir kişiden 2 atlama uzaklıktaki tüm kişiler (arkadaşımın arkadaşı)
SELECT DISTINCT
    p1.name AS me,
    p3.name AS friend_of_friend
FROM social.person p1,
     social.friend_of f1,
     social.person p2,
     social.friend_of f2,
     social.person p3
WHERE MATCH(p1-(f1)->p2-(f2)->p3)
  AND p1.name = N'Ayşe'
  AND p3.person_id <> p1.person_id;
GO

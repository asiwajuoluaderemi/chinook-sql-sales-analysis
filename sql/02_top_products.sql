/*
  File:    02_top_products.sql
  Project: Chinook SQL sales analysis
  Goal:    Find which products sell the most.
*/

-- ==========================================
-- 1. How many songs sold 1 time and 2 times?
-- ==========================================
-- The brackets run first: copies sold for each song.
-- The outside query counts how many songs have each number.
SELECT UnitsSold,
       COUNT(*) AS Songs
FROM (
    SELECT t.TrackId,
           SUM(il.Quantity) AS UnitsSold
    FROM InvoiceLine AS il
    JOIN Track AS t
      ON il.TrackId = t.TrackId
    GROUP BY t.TrackId
)
GROUP BY UnitsSold
ORDER BY UnitsSold DESC;

-- ==========================================
-- 2. How many songs were never sold?
-- ==========================================
-- LEFT JOIN keeps every song. Songs with no sale have an empty InvoiceLine.
SELECT COUNT(*) AS NeverSold
FROM Track AS t
LEFT JOIN InvoiceLine AS il
  ON t.TrackId = il.TrackId
WHERE il.TrackId IS NULL;

-- ==========================================
-- 3. Top 10 artists by revenue
-- ==========================================
-- Chain of joins: line -> song -> album -> artist.

-- Check first: the chain must keep all 2240 lines.
SELECT COUNT(*) AS Rows_After_Joins
FROM InvoiceLine AS il
JOIN Track  AS t  ON il.TrackId = t.TrackId
JOIN Album  AS al ON t.AlbumId  = al.AlbumId
JOIN Artist AS ar ON al.ArtistId = ar.ArtistId;

-- The ranking
SELECT ar.ArtistId,
       ar.Name AS ArtistName,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue,
       SUM(il.Quantity) AS UnitsSold
FROM InvoiceLine AS il
JOIN Track  AS t  ON il.TrackId = t.TrackId
JOIN Album  AS al ON t.AlbumId  = al.AlbumId
JOIN Artist AS ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId, ar.Name
ORDER BY Revenue DESC, ar.Name
LIMIT 10;

-- ==========================================
-- 4. Revenue by genre, with share of total
-- ==========================================
-- Chain of joins: line -> song -> genre.
SELECT g.Name AS Genre,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue,
       SUM(il.Quantity) AS UnitsSold,
       ROUND(100.0 * SUM(il.UnitPrice * il.Quantity)
             / (SELECT SUM(UnitPrice * Quantity) FROM InvoiceLine), 1) AS Share_Percent
FROM InvoiceLine AS il
JOIN Track AS t ON il.TrackId = t.TrackId
JOIN Genre AS g ON t.GenreId  = g.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY Revenue DESC, g.Name
LIMIT 10;

-- ==========================================
-- 5. Genres that never sold
-- ==========================================
-- LEFT JOIN keeps every genre. HAVING works on the piles after GROUP BY.
SELECT g.Name AS Genre
FROM Genre AS g
LEFT JOIN Track AS t ON g.GenreId = t.GenreId
LEFT JOIN InvoiceLine AS il ON t.TrackId = il.TrackId
GROUP BY g.GenreId, g.Name
HAVING COUNT(il.InvoiceLineId) = 0;
/*
  File:    05_window_function.sql
  Project: Chinook SQL sales analysis
  Goal:    Use window functions to rank genres by revenue.
*/

-- Check first: window functions need SQLite 3.25 or higher.
SELECT sqlite_version();

-- ==========================================
-- 1. Rank genres by revenue: three ways to rank
-- ==========================================
-- The brackets run first: revenue for each genre.
-- The window functions then add rank columns. They do not squash the rows.
SELECT Genre,
       Revenue,
       ROW_NUMBER() OVER (ORDER BY Revenue DESC, Genre) AS Row_No,
       RANK()       OVER (ORDER BY Revenue DESC)        AS Rank_No,
       DENSE_RANK() OVER (ORDER BY Revenue DESC)        AS Dense_Rank_No
FROM (
    SELECT g.Name AS Genre,
           ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
    FROM InvoiceLine AS il
    JOIN Track AS t ON il.TrackId = t.TrackId
    JOIN Genre AS g ON t.GenreId  = g.GenreId
    GROUP BY g.GenreId, g.Name
)
ORDER BY Revenue DESC, Genre;

-- ==========================================
-- 2. Top artist in each genre
-- ==========================================
-- Innermost brackets: revenue for each artist inside each genre.
-- Middle level: PARTITION BY restarts the ranking for every genre.
-- Outside: keep only the rank-1 artists. RANK shows ties honestly.
SELECT Genre,
       Artist,
       Revenue,
       Rank_In_Genre
FROM (
    SELECT Genre,
           Artist,
           Revenue,
           RANK() OVER (PARTITION BY Genre ORDER BY Revenue DESC) AS Rank_In_Genre
    FROM (
        SELECT g.Name AS Genre,
               ar.Name AS Artist,
               ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
        FROM InvoiceLine AS il
        JOIN Track  AS t  ON il.TrackId  = t.TrackId
        JOIN Album  AS al ON t.AlbumId   = al.AlbumId
        JOIN Artist AS ar ON al.ArtistId = ar.ArtistId
        JOIN Genre  AS g  ON t.GenreId   = g.GenreId
        GROUP BY g.GenreId, g.Name, ar.ArtistId, ar.Name
    ) 
)
WHERE Rank_In_Genre = 1
ORDER BY Revenue DESC, Genre, Artist;
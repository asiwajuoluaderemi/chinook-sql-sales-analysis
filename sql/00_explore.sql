/*
  File:    00_explore.sql
  Project: Chinook SQL sales analysis
  Goal:    Look at the tables before we ask business questions.
  Tip:     Every query ends with a semicolon (;).
*/

-- ==========================================
-- 1. List all tables in the database
-- ==========================================
-- sqlite_master is a special table. SQLite keeps its list of tables in it.
SELECT name
FROM sqlite_master
WHERE type = 'table';


-- ==========================================
-- 2. Look at the first rows of each table
-- ==========================================
-- SELECT * means "all columns". LIMIT 5 means "only the first 5 rows".

-- Customer: one row for each person who buys
SELECT *
FROM Customer
LIMIT 5;

-- Invoice: one row for each receipt
SELECT *
FROM Invoice
LIMIT 5;

-- InvoiceLine: one row for each song on a receipt
SELECT *
FROM InvoiceLine
LIMIT 5;

-- Track: one row for each song
SELECT *
FROM Track
LIMIT 5;


-- ==========================================
-- 3. Count the rows in each table
-- ==========================================
-- COUNT(*) counts the rows. AS gives the answer a name.

SELECT COUNT(*) AS Total_Customers    FROM Customer;      -- 59
SELECT COUNT(*) AS Total_Invoices     FROM Invoice;       -- 412
SELECT COUNT(*) AS Total_InvoiceLines FROM InvoiceLine;   -- 2240
SELECT COUNT(*) AS Total_Tracks       FROM Track;         -- 3503

-- ==========================================
-- 4. Look at Album, Artist and Genre
-- ==========================================
-- Album: one row for each album
SELECT *
FROM Album
LIMIT 5;

-- Artist: one row for each artist
SELECT *
FROM Artist
LIMIT 5;

-- Genre: one row for each type of music
SELECT *
FROM Genre
LIMIT 5;

-- Count the rows in each table
SELECT COUNT(*) AS Total_Albums  FROM Album;
SELECT COUNT(*) AS Total_Artists FROM Artist;
SELECT COUNT(*) AS Total_Genres  FROM Genre;
/*
  File:    01_join_checks.sql
  Project: Chinook SQL sales analysis
  Goal:    Join the main tables and check that each join keeps the right number of rows.
  Rule:    After every JOIN, count the rows to check the join.
*/

-- ==========================================
-- 1. Invoices with the customer name
-- ==========================================
-- The link is the CustomerId column in both tables.
SELECT i.InvoiceId,
       c.FirstName,
       c.LastName,
       i.Total
FROM Invoice AS i
JOIN Customer AS c
  ON i.CustomerId = c.CustomerId
ORDER BY i.InvoiceId
LIMIT 5;

-- Check: expect 412 rows (one row for each invoice)
SELECT COUNT(*) AS Rows_After_Join
FROM Invoice AS i
JOIN Customer AS c
  ON i.CustomerId = c.CustomerId;


-- ==========================================
-- 2. Invoice lines with the song name
-- ==========================================
-- The link is the TrackId column in both tables.
SELECT il.InvoiceLineId,
       t.Name AS SongName,
       il.UnitPrice
FROM InvoiceLine AS il
JOIN Track AS t
  ON il.TrackId = t.TrackId
ORDER BY il.InvoiceLineId
LIMIT 5;

-- Check: expect 2240 rows (one row for each invoice line)
SELECT COUNT(*) AS Rows_After_Join
FROM InvoiceLine AS il
JOIN Track AS t
  ON il.TrackId = t.TrackId;


-- ==========================================
-- 3. Warning: join on Id columns, never on prices
-- ==========================================
-- UnitPrice is in both InvoiceLine and Track, but it is NOT a link.
-- Joining on price matches every 0.99 line with every 0.99 song
-- and makes millions of wrong rows. Always join on the Id columns.

-- ==========================================
-- 4. Money check: lines must equal receipts
-- ==========================================
-- Money from the lines: price x quantity
SELECT ROUND(SUM(UnitPrice * Quantity), 2) AS LineTotal
FROM InvoiceLine;

-- Money from the receipts: the Total column
SELECT ROUND(SUM(Total), 2) AS InvoiceTotal
FROM Invoice;
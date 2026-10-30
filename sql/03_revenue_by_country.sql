
/*
  File:    03_revenue_by_country.sql
  Project: Chinook SQL sales analysis
  Goal:    Find how much money each country brings in.
*/

-- ==========================================
-- 1. Check: does BillingCountry match the customer's country?
-- ==========================================
-- If the answer is 0, both countries are the same on every invoice,
-- and we can use BillingCountry without a join.
SELECT COUNT(*) AS Different_Country
FROM Invoice AS i
JOIN Customer AS c
  ON i.CustomerId = c.CustomerId
WHERE i.BillingCountry <> c.Country;

-- How many countries are there?
SELECT COUNT(DISTINCT BillingCountry) AS Countries
FROM Invoice;

-- ==========================================
-- 2. Revenue by country (top 10)
-- ==========================================
SELECT BillingCountry AS Country,
       COUNT(DISTINCT CustomerId) AS Customers,
       COUNT(*) AS Invoices,
       ROUND(SUM(Total), 2) AS Revenue,
       ROUND(100.0 * SUM(Total) / (SELECT SUM(Total) FROM Invoice), 1) AS Share_Percent
FROM Invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC, Country
LIMIT 10;
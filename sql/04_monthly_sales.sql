/*
  File:    04_monthly_sales.sql
  Project: Chinook SQL sales analysis
  Goal:    See how sales change over time.
*/

-- ==========================================
-- 1. Date range
-- ==========================================
-- strftime cuts a piece out of the date text.
SELECT MIN(InvoiceDate) AS First_Invoice,
       MAX(InvoiceDate) AS Last_Invoice,
       COUNT(DISTINCT strftime('%Y-%m', InvoiceDate)) AS Months
FROM Invoice;

-- ==========================================
-- 2. Revenue by year
-- ==========================================
SELECT strftime('%Y', InvoiceDate) AS Year,
       COUNT(*) AS Invoices,
       ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY Year
ORDER BY Year;

-- ==========================================
-- 3. Revenue by month
-- ==========================================
SELECT strftime('%Y-%m', InvoiceDate) AS Month,
       COUNT(*) AS Invoices,
       ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

SELECT COUNT(*) AS total_customers
FROM Customer;

SELECT *
FROM Customer
LIMIT 5;

-- Which countries generate the most customers?
SELECT 
    Country,
    COUNT(*) AS total_customers
FROM Customer
GROUP BY Country
ORDER BY total_customers DESC;

-- Which countries generate the highest revenue?
SELECT
    c.Country,
    ROUND(SUM(i.Total), 2) AS total_revenue
FROM Customer c
JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY total_revenue DESC;

-- Which customers generate the most revenue?
SELECT 
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    c.Country,
    ROUND(SUM(i.Total), 2) AS TotalRevenue
FROM Customer c
JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId,
    CustomerName,
    c.Country
ORDER BY TotalRevenue DESC
LIMIT 10;

-- Which music genres generate the most revenue?
SELECT
    g.Name AS Genre,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS TotalRevenue
FROM InvoiceLine il
JOIN Track t
    ON il.TrackId = t.TrackId
JOIN Genre g
    ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalRevenue DESC;

-- How does revenue change over time (by month)?
SELECT
    strftime('%Y-%m', InvoiceDate) AS YearMonth,
    ROUND(SUM(Total), 2) AS MonthlyRevenue
FROM Invoice
GROUP BY YearMonth
ORDER BY YearMonth;

-- Which customers are at risk of churn due to inactivity?
SELECT
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    MAX(i.InvoiceDate) AS LastPurchaseDate
FROM Customer c
JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, CustomerName
ORDER BY LastPurchaseDate;

-- churn-risk customers (inactive > 1 year)
SELECT
    CustomerName,
    LastPurchaseDate
FROM (
    SELECT
        c.CustomerId,
        c.FirstName || ' ' || c.LastName AS CustomerName,
        MAX(i.InvoiceDate) AS LastPurchaseDate
    FROM Customer c
    JOIN Invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, CustomerName
)
WHERE date(LastPurchaseDate) < date('2013-01-01')
ORDER BY LastPurchaseDate;

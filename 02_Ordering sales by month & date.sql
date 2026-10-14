-- SELECT * FROM dbo.onlineretail_clean


SELECT
    YEAR(InvoiceDate) AS Sales_Year,
    MONTH(InvoiceDate) AS Sales_Month,
    SUM(Quantity * Price) AS Gross_Sales,
    COUNT(DISTINCT Invoice) AS Invoice_Count,
    SUM(Quantity) AS Units_Sold
FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate IS NOT NULL
  AND Quantity > 0
  AND Price >= 0
  AND Invoice NOT LIKE 'C%'
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate)
ORDER BY
    Sales_Year,
    Sales_Month

-- Finding Top-20 best selling products

SELECT TOP (20)
    StockCode,
    MAX(Description) AS Product_Name,
    SUM(Quantity) AS Units_Sold,
    SUM(Quantity * Price) AS Total_Revenue,
    COUNT(DISTINCT Invoice) AS Number_Of_Invoices

FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate IS NOT NULL
  AND Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
GROUP BY StockCode
ORDER BY Total_Revenue DESC;

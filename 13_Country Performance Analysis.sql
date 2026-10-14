USE RetailAnalyticsDB
GO


SELECT
    Country,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    SUM(Quantity) AS Units_Sold,
    SUM(Quantity * Price) AS Total_Revenue,
    CAST(
        SUM(Quantity * Price) /
        NULLIF(COUNT(DISTINCT Invoice), 0)
        AS DECIMAL(12,2)
    ) AS Revenue_Per_Order
FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate IS NOT NULL
  AND Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
GROUP BY Country
ORDER BY Total_Revenue DESC;

USE RetailAnalyticsDB
GO


CREATE OR ALTER VIEW dbo.vw_Product_Performance
AS
SELECT
    StockCode,
    MAX(Description) AS Product_Name,
    SUM(Quantity) AS Total_Units_Sold,
    SUM(Quantity * Price) AS Total_Revenue,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate IS NOT NULL
  AND Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
GROUP BY StockCode;
GO

SELECT TOP (20) *
FROM dbo.vw_Product_Performance
ORDER BY Total_Revenue DESC;

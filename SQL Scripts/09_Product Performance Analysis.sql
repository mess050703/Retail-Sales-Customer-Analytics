USE RetailAnalyticsDB
GO

WITH ProductSales AS (
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
    GROUP BY StockCode
)
SELECT
    StockCode,
    Product_Name,
    Total_Units_Sold,
    Total_Revenue,
    Total_Orders,
    Unique_Customers,
    RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Rank
FROM ProductSales
ORDER BY Revenue_Rank;

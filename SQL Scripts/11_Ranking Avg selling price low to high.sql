USE RetailAnalyticsDB
GO

-- Finding Top 20 productts with high sales volume but low revenue

WITH ProductSales AS (
    SELECT
        StockCode,
        MAX(Description) AS Product_Name,
        SUM(Quantity) AS Total_Units_Sold,
        SUM(Quantity * Price) AS Total_Revenue,
        SUM(Quantity * Price)
            / NULLIF(SUM(Quantity), 0) AS Average_Selling_Price
    FROM dbo.OnlineRetail_Clean
    WHERE InvoiceDate IS NOT NULL
      AND Invoice NOT LIKE 'C%'
      AND Quantity > 0
      AND Price > 0
    GROUP BY StockCode
)
SELECT TOP (20)
    StockCode,
    Product_Name,
    Total_Units_Sold,
    Total_Revenue,
    Average_Selling_Price
FROM ProductSales
WHERE Total_Units_Sold >= 100
ORDER BY Average_Selling_Price ASC;

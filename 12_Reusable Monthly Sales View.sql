USE RetailAnalyticsDB
GO


CREATE OR ALTER VIEW dbo.vw_Monthly_Sales
AS
SELECT
    DATEFROMPARTS(
        YEAR(InvoiceDate),
        MONTH(InvoiceDate),
        1
    ) AS Sales_Month,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    SUM(Quantity) AS Units_Sold,
    SUM(Quantity * Price) AS Total_Revenue
FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate IS NOT NULL
  AND Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate);
GO

SELECT *
FROM dbo.vw_Monthly_Sales
ORDER BY Sales_Month;

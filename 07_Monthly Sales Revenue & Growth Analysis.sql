
USE RetailAnalyticsDB;
GO

WITH MonthlySales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(InvoiceDate),
            MONTH(InvoiceDate),
            1
        ) AS Sales_Month,

        SUM(Quantity * Price) AS Monthly_Revenue,

        COUNT(DISTINCT Invoice) AS Total_Invoices

    FROM dbo.OnlineRetail_Clean
    WHERE InvoiceDate IS NOT NULL
      AND Invoice NOT LIKE 'C%'
      AND Quantity > 0
      AND Price > 0

    GROUP BY
        YEAR(InvoiceDate),
        MONTH(InvoiceDate)
),

SalesGrowth AS (
    SELECT
        Sales_Month,
        Monthly_Revenue,
        Total_Invoices,

        LAG(Monthly_Revenue) OVER (
            ORDER BY Sales_Month
        ) AS Previous_Month_Revenue

    FROM MonthlySales
)

SELECT
    Sales_Month,
    Monthly_Revenue,
    Total_Invoices,
    Previous_Month_Revenue,

    Monthly_Revenue - Previous_Month_Revenue
        AS Revenue_Change,

    CAST(
        100.0 * (
            Monthly_Revenue - Previous_Month_Revenue
        ) / NULLIF(Previous_Month_Revenue, 0)
        AS DECIMAL(10,2)
    ) AS Growth_Percentage

FROM SalesGrowth
ORDER BY Sales_Month;


SELECT
    YEAR(InvoiceDate) AS Sales_Year,
    MONTH(InvoiceDate) AS Sales_Month,
    COUNT(DISTINCT Invoice) AS Total_Invoices,
    SUM(Quantity) AS Total_Units_Sold,
    SUM(Quantity * Price) AS Total_Revenue
FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate >= '2010-11-01'
  AND InvoiceDate < '2011-01-01'
  AND Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate)
ORDER BY
    Sales_Year,
    Sales_Month;



WITH MonthlySales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(InvoiceDate),
            MONTH(InvoiceDate),
            1
        ) AS Sales_Month,
        SUM(Quantity * Price) AS Monthly_Revenue
    FROM dbo.OnlineRetail_Clean
    WHERE InvoiceDate IS NOT NULL
      AND Invoice NOT LIKE 'C%'
      AND Quantity > 0
      AND Price > 0
    GROUP BY
        YEAR(InvoiceDate),
        MONTH(InvoiceDate)
)
SELECT
    Sales_Month,
    Monthly_Revenue,
    RANK() OVER (
        ORDER BY Monthly_Revenue DESC
    ) AS Revenue_Rank
FROM MonthlySales
ORDER BY Revenue_Rank;

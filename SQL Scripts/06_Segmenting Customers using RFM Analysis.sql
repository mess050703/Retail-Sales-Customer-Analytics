-- RFM Analysis ordered by Monetary Value


USE RetailAnalyticsDB;
GO

DECLARE @AnalysisDate DATE;

SELECT @AnalysisDate =
    DATEADD(DAY, 1, MAX(CAST(InvoiceDate AS DATE)))
FROM dbo.OnlineRetail_Clean
WHERE InvoiceDate IS NOT NULL;

WITH CustomerRFM AS (
    SELECT
        Customer_ID,

        DATEDIFF(
            DAY,
            MAX(CAST(InvoiceDate AS DATE)),
            @AnalysisDate
        ) AS Recency_Days,

        COUNT(DISTINCT Invoice) AS Frequency,

        SUM(Quantity * Price) AS Monetary_Value

    FROM dbo.OnlineRetail_Clean
    WHERE Customer_ID IS NOT NULL
      AND Invoice NOT LIKE 'C%'
      AND Quantity > 0
      AND Price > 0
      AND InvoiceDate IS NOT NULL

    GROUP BY Customer_ID
),

RFMScores AS (
    SELECT
        Customer_ID,
        Recency_Days,
        Frequency,
        Monetary_Value,

        NTILE(5) OVER (
            ORDER BY Recency_Days DESC
        ) AS Recency_Score,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS Frequency_Score,

        NTILE(5) OVER (
            ORDER BY Monetary_Value ASC
        ) AS Monetary_Score

    FROM CustomerRFM
),

CustomerSegments AS (
    SELECT *,
        CASE
            WHEN Recency_Score >= 4
             AND Frequency_Score >= 4
             AND Monetary_Score >= 4
                THEN 'Loyal Customers'

            WHEN Recency_Score <= 2
             AND Frequency_Score >= 3
                THEN 'At Risk'

            WHEN Recency_Score >= 4
             AND Frequency_Score <= 2
                THEN 'New or Recent Customers'

            WHEN Frequency_Score >= 3
                THEN 'Regular Customers'

            ELSE 'Occasional Customers'
        END AS Customer_Segment

    FROM RFMScores
)

/*       SELECT *
         FROM CustomerSegments
         ORDER BY Monetary_Value DESC;       */


SELECT
    Customer_Segment,
    COUNT(*) AS Total_Customers,
    AVG(CAST(Recency_Days AS DECIMAL(10,2)))
        AS Average_Recency_Days,
    AVG(CAST(Frequency AS DECIMAL(10,2)))
        AS Average_Orders,
    SUM(Monetary_Value) AS Total_Customer_Spend,
    AVG(Monetary_Value) AS Average_Customer_Spend
FROM CustomerSegments
GROUP BY Customer_Segment
ORDER BY Total_Customer_Spend DESC

-- Investigating Cancellations & Return

SELECT
    CASE
        WHEN Invoice LIKE 'C%' THEN 'Cancellation'
        WHEN Quantity < 0 THEN 'Negative Quantity / Return'
        WHEN Quantity = 0 THEN 'Zero Quantity'
        ELSE 'Positive Quantity'
    END AS Transaction_Type,

    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Invoice) AS Total_Invoices,
    SUM(Quantity * Price) AS Transaction_Value

FROM dbo.OnlineRetail_Clean

GROUP BY
    CASE
        WHEN Invoice LIKE 'C%' THEN 'Cancellation'
        WHEN Quantity < 0 THEN 'Negative Quantity / Return'
        WHEN Quantity = 0 THEN 'Zero Quantity'
        ELSE 'Positive Quantity'
    END
ORDER BY Total_Rows DESC

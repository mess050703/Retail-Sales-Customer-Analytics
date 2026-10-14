-- Finding Top 20 customers by total_amount spent

SELECT TOP (20)
    Customer_ID,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    SUM(Quantity * Price) AS Total_Spend,
    SUM(Quantity) AS Total_Units_Purchased,
    MIN(InvoiceDate) AS First_Purchase,
    MAX(InvoiceDate) AS Last_Purchase
FROM dbo.OnlineRetail_Clean
WHERE Customer_ID IS NOT NULL
  AND Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
GROUP BY Customer_ID
ORDER BY Total_Spend DESC;

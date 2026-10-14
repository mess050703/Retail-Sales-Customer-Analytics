 -- Do not re-execute the query 

/*
SELECT
    NULLIF(LTRIM(RTRIM(Invoice)), '') AS Invoice,
    NULLIF(LTRIM(RTRIM(StockCode)), '') AS StockCode,
    NULLIF(LTRIM(RTRIM(Description)), '') AS Description,

    TRY_CONVERT(INT, Quantity) AS Quantity,

    TRY_CONVERT(
        DATETIME2(0),
        LTRIM(RTRIM(InvoiceDate)),
        105
    ) AS InvoiceDate,

    TRY_CONVERT(DECIMAL(12, 4), Price) AS Price,

    TRY_CONVERT(INT, Customer_ID) AS Customer_ID,

    NULLIF(LTRIM(RTRIM(Country)), '') AS Country

INTO dbo.OnlineRetail_Clean
FROM dbo.Online_Retail_II;

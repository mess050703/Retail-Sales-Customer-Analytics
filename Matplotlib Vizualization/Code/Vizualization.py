import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# ==========================================
# 1. FOLDER PATHS
# ==========================================

DATA = Path(r"C:\SQL Tutorial Prac\Project 1\CSV Exports")

OUTPUT = Path(
    r"C:\SQL Tutorial Prac\Project 1\Matplotlib Visualization\visualizations"
)

OUTPUT.mkdir(parents=True, exist_ok=True)

# ==========================================
# 2. LOAD CSV FILES
# ==========================================

files = {
    "monthly": "monthly_growth.csv",
    "products": "top_products.csv",
    "countries": "country_sales.csv",
    "segments": "customer_segments.csv"
}

for filename in files.values():
    if not (DATA / filename).exists():
        raise FileNotFoundError(
            f"Cannot find: {DATA / filename}\n"
            "Check that the CSV is saved in the DATA folder."
        )


# Monthly sales CSV: no headers
monthly = pd.read_csv(
    DATA / "monthly_growth.csv",
    encoding="utf-8-sig",
    header=None,
    names=[
        "Sales_Month",
        "Monthly_Revenue",
        "Total_Invoices",
        "Previous_Month_Revenue",
        "Revenue_Change",
        "Growth_Percentage"
    ],
    na_values=["NULL"]
)

# Product CSV: no headers
products = pd.read_csv(
    DATA / "top_products.csv",
    encoding="utf-8-sig",
    header=None,
    names=[
        "StockCode",
        "Product_Name",
        "Total_Units_Sold",
        "Total_Revenue",
        "Total_Orders",
        "Unique_Customers",
        "Revenue_Rank"
    ],
    na_values=["NULL"]
)

# Country CSV: no headers
countries = pd.read_csv(
    DATA / "country_sales.csv",
    encoding="utf-8-sig",
    header=None,
    names=[
        "Country",
        "Total_Orders",
        "Unique_Customers",
        "Units_Sold",
        "Total_Revenue",
        "Revenue_Per_Order"
    ],
    na_values=["NULL"]
)

# Customer segment CSV: no headers
segments = pd.read_csv(
    DATA / "customer_segments.csv",
    encoding="utf-8-sig",
    header=None,
    names=[
        "Customer_Segment",
        "Total_Customers",
        "Average_Recency_Days",
        "Average_Orders",
        "Total_Customer_Spend",
        "Average_Customer_Spend"
    ],
    na_values=["NULL"]
)


# ==========================================
# 3. CLEAN COLUMN NAMES
# ==========================================

def clean_columns(df):
    df.columns = [
        str(col).strip().replace("\ufeff", "").strip('"').strip("'")
        for col in df.columns
    ]
    return df


monthly = clean_columns(monthly)
products = clean_columns(products)
countries = clean_columns(countries)
segments = clean_columns(segments)


# Match column names even if they contain spaces,
# underscores, or different capitalization.

def find_column(df, possible_names):
    def normalize(name):
        return "".join(
            char.lower() for char in str(name)
            if char.isalnum()
        )

    lookup = {normalize(col): col for col in df.columns}

    for name in possible_names:
        key = normalize(name)
        if key in lookup:
            return lookup[key]

    raise KeyError(
        f"Could not find any of {possible_names}.\n"
        f"Actual columns: {df.columns.tolist()}"
    )


# ==========================================
# 4. CHART 1: MONTHLY REVENUE
# ==========================================

date_col = find_column(
    monthly, ["Sales_Month", "Month", "InvoiceDate"]
)

revenue_col = find_column(
    monthly, ["Monthly_Revenue", "Total_Revenue", "Revenue"]
)

monthly[date_col] = pd.to_datetime(
    monthly[date_col], errors="coerce"
)

monthly[revenue_col] = pd.to_numeric(
    monthly[revenue_col], errors="coerce"
)

monthly = monthly.dropna(subset=[date_col, revenue_col])
monthly = monthly.sort_values(date_col)

plt.figure(figsize=(12, 6))

plt.plot(
    monthly[date_col],
    monthly[revenue_col],
    marker="o"
)

plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.grid(alpha=0.3)
plt.tight_layout()

plt.savefig(OUTPUT / "01_monthly_revenue.png", dpi=300)
plt.close()


# ==========================================
# 5. CHART 2: MONTHLY REVENUE GROWTH
# ==========================================

growth_col = find_column(
    monthly, ["Growth_Percentage", "Growth", "Growth_Pct"]
)

monthly[growth_col] = pd.to_numeric(
    monthly[growth_col], errors="coerce"
)

growth_data = monthly.dropna(subset=[growth_col])

plt.figure(figsize=(12, 6))

plt.bar(
    growth_data[date_col].dt.strftime("%b %Y"),
    growth_data[growth_col]
)

plt.axhline(0, linewidth=1)
plt.title("Month-over-Month Revenue Growth")
plt.xlabel("Month")
plt.ylabel("Growth (%)")
plt.xticks(rotation=45)
plt.tight_layout()

plt.savefig(OUTPUT / "02_monthly_growth.png", dpi=300)
plt.close()


# ==========================================
# 6. CHART 3: TOP 10 PRODUCTS BY REVENUE
# ==========================================

product_name_col = find_column(
    products, ["Product_Name", "Description", "Product"]
)

product_revenue_col = find_column(
    products, ["Total_Revenue", "Monthly_Revenue", "Revenue"]
)

products[product_revenue_col] = pd.to_numeric(
    products[product_revenue_col], errors="coerce"
)

top_products = products.dropna(
    subset=[product_name_col, product_revenue_col]
).nlargest(10, product_revenue_col)

top_products = top_products.sort_values(product_revenue_col)

plt.figure(figsize=(12, 7))

plt.barh(
    top_products[product_name_col].astype(str),
    top_products[product_revenue_col]
)

plt.title("Top 10 Products by Revenue")
plt.xlabel("Revenue")
plt.ylabel("Product")
plt.tight_layout()

plt.savefig(OUTPUT / "03_top_products.png", dpi=300)
plt.close()


# ==========================================
# 7. CHART 4: TOP 10 COUNTRIES BY REVENUE
# ==========================================

country_col = find_column(
    countries, ["Country", "Country_Name"]
)

country_revenue_col = find_column(
    countries, ["Total_Revenue", "Revenue", "Gross_Sales"]
)

countries[country_revenue_col] = pd.to_numeric(
    countries[country_revenue_col], errors="coerce"
)

top_countries = countries.dropna(
    subset=[country_col, country_revenue_col]
).nlargest(10, country_revenue_col)

top_countries = top_countries.sort_values(country_revenue_col)

plt.figure(figsize=(10, 6))

plt.barh(
    top_countries[country_col].astype(str),
    top_countries[country_revenue_col]
)

plt.title("Top 10 Countries by Revenue")
plt.xlabel("Revenue")
plt.ylabel("Country")
plt.tight_layout()

plt.savefig(OUTPUT / "04_country_sales.png", dpi=300)
plt.close()


# ==========================================
# 8. CHART 5: CUSTOMER SEGMENT SPENDING
# ==========================================

segment_col = find_column(
    segments, ["Customer_Segment", "Segment"]
)

spending_col = find_column(
    segments,
    ["Total_Customer_Spend", "Total_Spend",
     "Total_Monetary_Value", "Monetary_Value"]
)

segments[spending_col] = pd.to_numeric(
    segments[spending_col], errors="coerce"
)

segment_data = segments.dropna(
    subset=[segment_col, spending_col]
)

plt.figure(figsize=(11, 6))

plt.bar(
    segment_data[segment_col].astype(str),
    segment_data[spending_col]
)

plt.title("Revenue Contribution by Customer Segment")
plt.xlabel("Customer Segment")
plt.ylabel("Total Customer Spend")
plt.xticks(rotation=30, ha="right")
plt.tight_layout()

plt.savefig(OUTPUT / "05_customer_segments.png", dpi=300)
plt.close()


# ==========================================
# 9. FINISHED
# ==========================================

print("\nSUCCESS! All five charts were generated.")
print("Charts saved in:", OUTPUT)

for image_file in sorted(OUTPUT.glob("*.png")):
    print("-", image_file.name)

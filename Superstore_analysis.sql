-- Query 1: Revenue by Category
SELECT "Category", ROUND(SUM("Sales"), 2) AS total_revenue
FROM superstore_sales
GROUP BY "Category"
ORDER BY total_revenue DESC;

-- Query 2: Top 5 Best Selling Products
SELECT "Product Name", ROUND(SUM("Sales"), 2) AS total_sales
FROM superstore_sales
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 5;

-- Query 3: Orders by Region
SELECT "Region", COUNT(*) AS total_orders
FROM superstore_sales
GROUP BY "Region"
ORDER BY total_orders DESC;

-- Query 4: Monthly Sales Trend
SELECT EXTRACT(MONTH FROM "Order Date") AS month,
ROUND(SUM("Sales"), 2) AS total_sales
FROM superstore_sales
GROUP BY month
ORDER BY month;

-- Query 5: Top 10 Products with Above Average Sales
select "Product Name", SUM("Sales") as total_product_sales
FROM superstore_sales
GROUP BY "Product Name"
HAVING SUM("Sales") >
(SELECT avg(Product_sales) from
(SELECT "Product Name", SUM("Sales") as Product_sales
FROM superstore_sales
GROUP by "Product Name") as P_Sales)
ORDER BY total_product_sales DESC
LIMIT 10;

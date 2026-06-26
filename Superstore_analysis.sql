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

-- Query 6: Shows each Regions Total Sales alongside the overall Total Sales and Percentages
SELECT "Region", SUM("Sales") AS region_sales,
(SELECT SUM("Sales")
FROM superstore_sales) as overall_total,
ROUND(SUM("Sales")/ (SELECT SUM("Sales") FROM superstore_sales) * 100, 2) AS "Percentage %"
FROM superstore_sales
GROUP BY "Region"
ORDER BY region_sales DESC

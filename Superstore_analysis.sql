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

-- Query 7: Shows insights On Each Region's Total Sales, Percentage and Performance Classification
SELECT "Region",
SUM("Sales") AS total_sales,
ROUND(SUM("Sales")/ (SELECT SUM("Sales") FROM superstore_sales) * 100, 2) AS "Percentage %",
CASE
WHEN SUM("Sales") > 700000 THEN 'HIGH'
WHEN SUM("Sales") > 500000 THEN 'MEDIUM'
ELSE 'LOW'
END AS performance
FROM superstore_sales
GROUP BY "Region"
ORDER BY total_sales DESC;

-- Query 8: Shows The Top 10 Customer's Total Purchases And Segments they belong to.
SELECT o."Customer Name",
o."Segment",
ROUND(SUM(o."Sales"), 2) AS total_purchases,
COUNT(DISTINCT o."Order ID") AS total_orders
FROM superstore_sales o
JOIN superstore_sales c
ON o."Customer ID"=c."Customer ID"
GROUP BY o."Customer Name", o."Segment"
ORDER BY total_purchases DESC
LIMIT 10

-- Query 9: Shows the Quarterly Sales Trend by Year.
SELECT
EXTRACT(YEAR FROM "ORDER DATE") AS Year,
EXTRACT(QUARTER FROM "ORDER DATE") AS Quarter,
ROUND(SUM("SALES"), 2) AS total_sales
FROM superstore_sales
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

-- Query 10: Shows Q4 Sales by Segment.
SELECT "Segment",
ROUND(SUM("Sales"), 2) AS total_sales
FROM superstore_sales
WHERE EXTRACT(QUARTER FROM "Order Date") = 4
GROUP BY "Segment"
ORDER BY "Segment";

-- Query 11: Three way Join: segment by category total sales
SELECT
Customers."Segment",
Products."Category",
ROUND(SUM(Orders."Sales"), 2) as total_sales
FROM
(SELECT DISTINCT "Order ID", "Customer ID",
"Product ID", "Sales"
FROM superstore_sales) as Orders
join
(SELECT DISTINCT"Customer ID", "Customer Name", "Segment" FROM superstore_sales) as Customers
on Orders."Customer ID"= Customers."Customer ID"
JOIN
(SELECT DISTINCT "Product ID", "Product Name", "Category" FROM superstore_sales) as Products
on Orders."Product ID" = Products."Product ID"
GROUP BY 1, 2
ORDER BY  total_sales DESC

-- Query 12: Shows Loyal Consistent Customers Since Inception
SELECT "Customer ID", "Customer Name", 
COUNT(DISTINCT Extract (YEAR FROM "Order Date")) AS Years_active
FROM superstore_sales
GROUP BY 1,2
HAVING Years_active >= 2
ORDER BY Years_active DESC

-- Query 13 is divided into two
-- 13a. Shows the top 20 Customer Revenue Breakdown and Percentage
select
"Customer ID",
"Customer Name",
ROUND(SUM("Sales"), 2) as customer_sales,
ROUND(SUM("Sales") / (select SUM("Sales") from superstore_sales) * 100, 2) as revenue_percentage
from superstore_sales
group by 1, 2
order by customer_sales DESC
LIMIT 20

-- 13b. Shows Customer Revenue Concentration (CEO Summary)
select
ROUND(SUM("customer_sales") / 
(select SUM("Sales") from superstore_sales) * 100, 2) as top20_revenue_percentage
from(select sum("Sales") as customer_sales from superstore_sales
group by "Customer ID"
order by customer_sales desc
LIMIT 20) as top_20

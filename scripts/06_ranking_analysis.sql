/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products generate the highest revenue?
SELECT TOP 5
	DP.product_name,
	SUM(FS.sales_amount) AS highest_revenue
FROM gold.fact_sales FS 
LEFT JOIN gold.dim_products DP ON FS.product_key = DP.product_key
GROUP BY DP.product_name
ORDER BY highest_revenue DESC

-- Which 5 products subcategory generate the highest revenue?
SELECT TOP 5
	DP.product_subcategory,
	SUM(FS.sales_amount) AS highest_revenue
FROM gold.fact_sales FS 
LEFT JOIN gold.dim_products DP ON FS.product_key = DP.product_key
GROUP BY DP.product_subcategory
ORDER BY highest_revenue DESC

-- What are the 5 worst-perfoming products in terms of sales?
SELECT TOP 5
	DP.product_name,
	SUM(FS.sales_amount) AS highest_revenue
FROM gold.fact_sales FS 
LEFT JOIN gold.dim_products DP ON FS.product_key = DP.product_key
GROUP BY DP.product_name
ORDER BY highest_revenue ASC

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	DC.customer_key,
	DC.first_name,
	DC.last_name,
	SUM(FS.sales_amount) AS revenue_customer
FROM gold.fact_sales FS
LEFT JOIN gold.dim_customers DC ON FS.customer_key = DC.customer_key
GROUP BY DC.customer_key, DC.first_name, DC.last_name
ORDER BY revenue_customer DESC

-- Find the top 3 customers with the fewest orders placed
SELECT TOP 3
	DC.customer_key,
	DC.first_name,
	DC.last_name,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales FS
LEFT JOIN gold.dim_customers DC ON FS.customer_key = DC.customer_key
GROUP BY DC.customer_key, DC.first_name, DC.last_name
ORDER BY total_orders ASC

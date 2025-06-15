/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- Segment products into cost ranges and 
-- count how many products fall into each segment

WITH cte_cost_category AS(
SELECT 
	product_name,
	product_cost,
	CASE WHEN product_cost < 100 THEN 'Below 100'
		   WHEN product_cost BETWEEN 100 AND 500 THEN 'Between 100-500'
		   WHEN product_cost BETWEEN 100 AND 500 THEN 'Between 500-1000'
		   ELSE 'Above 1000'
	END product_cost_category
FROM gold.dim_products
) 
SELECT
	product_cost_category,
	COUNT(product_name) AS total_products
FROM cte_cost_category
GROUP BY product_cost_category
ORDER by total_products DESC

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH cte_spending AS(
SELECT
	DC.customer_key AS customer_key,
	SUM(FS.sales_amount) AS total_amount,
	MIN(FS.order_date) AS min_date,
	MAX(FS.order_date) AS max_date,
	DATEDIFF (MONTH, MIN(FS.order_date), MAX(FS.order_date)) AS lifespan,
	SUM(FS.sales_amount) AS sales_value
FROM gold.fact_sales FS
LEFT JOIN gold.dim_customers DC ON FS.customer_key = DC.customer_key
GROUP BY DC.customer_key--,FS.order_date

)
SELECT
group_customer,
COUNT(customer_key) AS total_customer
FROM(
 SELECT
	customer_key,
	CASE WHEN total_amount > 5000  AND lifespan>= 12 THEN 'VIP'
		   WHEN total_amount <= 5000 AND lifespan >=12 THEN 'Regular'
		   ELSE 'New'
	END AS group_customer
 FROM cte_spending ) sub
 GROUP BY group_customer

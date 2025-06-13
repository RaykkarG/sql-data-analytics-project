/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the total Sales
SELECT
  SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales

-- Find how many items are sold
SELECT
  SUM(quantity) AS items_sold
FROM gold.fact_sales

-- Find the average selling price
SELECT
  AVG(price) AS avg_selling_price
FROM gold.fact_sales

-- Find the total number of orders
SELECT 
  COUNT(DISTINCT order_number) AS number_Orders
FROM gold.fact_sales

-- Find the total number of products
SELECT 
  COUNT(DISTINCT product_number) AS number_Orders
FROM gold.dim_products

-- Find the total number of customers
SELECT 
  COUNT(DISTINCT customer_id) AS number_customers
FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT 
  COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales'		     AS measure_name, SUM(sales_amount) AS Measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity'		   AS measure_name, SUM(quantity) AS Measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price'		   AS measure_name, AVG(price) AS Measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders'	   AS measure_name, COUNT(DISTINCT order_number) AS Measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products'  AS measure_name, COUNT(DISTINCT product_number) AS Measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers' AS measure_name, COUNT(DISTINCT customer_key) AS Measure_value FROM gold.dim_customers


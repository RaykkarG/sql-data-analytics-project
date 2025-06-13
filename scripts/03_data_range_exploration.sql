/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the date of the first and last order & How many years of sales are avaiable
SELECT 
  MIN(order_date) AS first_order,
  MAX(order_date) AS last_order,
  DATEDIFF(YEAR,MIN(order_date), MAX(order_date)) AS order_range_year
FROM gold.fact_sales

--Find the youngest and oldest customer
SELECT 
  MIN (birthdate) AS oldest_customer,
  DATEDIFF(YEAR, MIN (birthdate), GETDATE()) AS oldest_age,
  MAX (birthdate) AS youngest_customer,
  DATEDIFF(YEAR, MAX (birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers


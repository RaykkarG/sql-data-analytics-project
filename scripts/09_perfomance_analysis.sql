/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- SUBQUERY VERSION
SELECT
	year_sales,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales_amount,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS avg_target,
	CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below AVG'
		   WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above AVG'
	ELSE 'AVG'
	END AS Target_description,
				--Year-over-year Analysis
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) AS diff_prev_year_sales,
	CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) < 0 THEN 'Decrease'
		   WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) > 0 THEN 'Increase'
	ELSE 'No change'
	END AS previous_sales_change

FROM(
	SELECT
		YEAR(FS.order_date) AS year_sales,
		DP.product_name AS product_name,
		SUM(FS.sales_amount) AS current_sales
	FROM gold.fact_sales FS
	LEFT JOIN gold.dim_products DP ON FS.product_key = DP.product_key
	WHERE YEAR(FS.order_date) IS NOT NULL
	GROUP BY YEAR(FS.order_date), DP.product_name
) AS sub
ORDER BY product_name, year_sales



-- CTE VERSION
WITH cte_avg_product AS(
SELECT
		YEAR(FS.order_date) AS year_sales,
		DP.product_name AS product_name,
		SUM(FS.sales_amount) AS current_sales
FROM gold.fact_sales FS
LEFT JOIN gold.dim_products DP ON FS.product_key = DP.product_key
WHERE YEAR(FS.order_date) IS NOT NULL
GROUP BY YEAR(FS.order_date), DP.product_name
	)
	SELECT year_sales,
		   product_name,
		   current_sales,
		   AVG(current_sales) OVER(PARTITION BY product_name) AS avg_current_sales,
		   current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS avg_target,
		   CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below AVG'
				    WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above AVG'
				    ELSE 'AVG'
			END AS Target_description,
			--Year-over-year Analysis
		   LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) AS previous_year_sales,
		   current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) AS diff_prev_year_sales,
		   CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) < 0 THEN 'Decrease'
				    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year_sales) > 0 THEN 'Increase'
				    ELSE 'No change'
		   END AS previous_sales_change
	FROM cte_avg_product
	ORDER BY product_name, year_sales

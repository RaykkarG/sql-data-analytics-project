/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
-- Category / total sales * 100

WITH cte_percentege AS(
SELECT
	DP.product_category AS product_category,
	SUM(FS.sales_amount) AS total_amount
FROM gold.fact_sales FS
LEFT JOIN gold.dim_products DP ON FS.product_key = DP.product_key
GROUP BY DP.product_category
)
SELECT product_category,
	   total_amount,
	   SUM(total_amount) OVER() AS product_total,
	   CONCAT(ROUND((CAST(total_amount AS FLOAT) / SUM(total_amount) OVER() *100),2), '%') AS product_percentual
FROM cte_percentege
ORDER BY product_percentual DESC

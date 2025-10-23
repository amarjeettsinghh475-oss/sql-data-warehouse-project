/*
=============================================================
QUALITY CHECKS
=============================================================
Sript Purpose:
            This script performs quality checks to validate the integrity, consistency,
            and accuracy of the Gold layer.

These checks ensure:
                    - Uniqueness of surrogate kays in dimensions table.
                    - Referential integrity between fact and dimension tables.
                    - Validation of relationships in the data model for analytical purpose.

Usage Notes:
              - Run these checks after fata loading Silver Layer.
              - Investigate and resolve any discrepancies found during the checks.
*/


------------------------------------------------------------
--Checking : gold.dim_customers
------------------------------------------------------------
-- Check for uniqueness of customer_key in gold.dim_customers
-- Exception : No results

SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
GO


------------------------------------------------------------
--Checking : gold.dim_product
------------------------------------------------------------
-- Check for uniqueness of product_key in gold.dim_product
-- Exception : No results

SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;
GO


------------------------------------------------------------
--Checking : gold.fact_sales
------------------------------------------------------------
-- Check the data model connectivity between fact and dimensions
-- Exception : No results

SELECT * 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_product AS p
    ON f.product_key = p.product_key
WHERE c.customer_key IS NULL 
   OR p.product_key IS NULL;
GO

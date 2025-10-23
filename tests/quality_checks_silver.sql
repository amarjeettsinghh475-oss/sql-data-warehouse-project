/*
============================================================
Quality Checks
============================================================

Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
*/


--=======================================
--Checking 'silver.crm_cust_info'
--=======================================
--Checking Nulls or Duplicates in Primary Key
--EXPECTATIONS: NO RESULT 
SELECT
	cst_id,
	COUNT (*)
FROM silver.crm_cust_info
	GROUP BY cst_id
	HAVING COUNT (*) > 1 OR cst_id IS NULL;			    --Primary key clean and load

--Check for Unwanted Spaces
--EXPECTATIONS: NO RESULT 
SELECT
	cst_key
FROM silver.crm_cust_info
	WHERE cst_key != TRIM(cst_key);


-- Data Sandardization & Consistency  
SELECT DISTINCT											
cst_martial_status
FROM silver.crm_cust_info;



--=======================================
--Checking 'silver.crm_prd_info'
--=======================================

--Checking Nulls or Duplicates in Primary Key
--EXPECTATIONS: NO RESULT 
SELECT
	prd_id,
	COUNT (*)
FROM silver.crm_prd_info
	GROUP BY prd_id
	HAVING COUNT (*) > 1 AND prd_id IS NULL	


--Check for Unwanted Spaces
--EXPECTATIONS: NO RESULT
SELECT
	prd_name
FROM silver.crm_prd_info
	WHERE prd_name != TRIM(prd_name)


--Data Standarardizaton & consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info


--Checking for Invalid Date Orders (Start Date > EndDate)
--EXPECTATIONS: NO RESULT
SELECT*
FROM silver.crm_prd_info
WHERE prd_start_date > prd_end_date


--Checking for Nulls or Negative Values in Cost
  --EXPECTATIONS: NO RESULT
SELECT prd_cost 
from silver.crm_prd_info
where prd_cost < 0 or prd_cost IS NULL


  
--=======================================
--Checking 'silver.crm_sales_details'
--=======================================

--Checking Nulls or Duplicates in Primary Key
--EXPECTATIONS: NO RESULT 
SELECT
	sales_ord_num,
	COUNT (*)
FROM silver.crm_sales_details
	GROUP BY sales_ord_num
	HAVING COUNT (*) > 1 AND sales_ord_num IS NULL


-- Check for Invalid Dates
-- Expectation: No Invalid Dates

SELECT
    NULLIF(sales_due_dt, 0) AS sales_due_dt
FROM bronze.crm_sales_details
WHERE sales_due_dt <= 0
   OR LEN(sales_due_dt) != 8
   OR sales_due_dt > 20500101
   OR sales_due_dt < 19000101;



--Check for Unwanted Spaces
--EXPECTATIONS: NO RESULT
SELECT
	sales_ord_num
FROM silver.crm_sales_details
	WHERE sales_ord_num != TRIM(sales_ord_num)


--Data Standarardizaton & consistency (sales = Quantity * Price)
--EXPECTATIONS: NO RESULT
SELECT DISTINCT 
	sales_sales, 
	sales_price, 
	sales_quantity
FROM silver.crm_sales_details
WHERE sales_sales != sales_quantity * sales_price
      OR sales_sales IS NULL 
      OR sales_price IS NULL 
      OR sales_quantity IS NULL 
      OR sales_sales <= 0 
      OR sales_price <= 0 
      OR sales_quantity <= 0
ORDER BY sales_sales,sales_price,sales_quantity


--Checking for Invalid Date Orders (Order Date > Shipping/Due Dates)
--EXPECTATIONS: NO RESULT
SELECT *
FROM silver.crm_sales_details
WHERE sales_order_dt > sales_due_dt
  OR  sales_order_dt > sales_ship_dt;



--=======================================
--Checking 'silver.erp_customers'
--=======================================

--Identify Out of Range dates
--Expectations : BirthDates not higher than today
SELECT DISTINCT
  cst_birthdate
FROM bronze.erp_customers
WHERE cst_birthdate > GETDATE()

  
--Data Standardization & consistency
SELECT DISTINCT 
  cst_gender
FROM silver.erp_customers



--=======================================
--Checking 'silver.erp_location'
--=======================================

--Data Standardization & consistency
SELECT DISTINCT 
  loc_country
FROM silver.erp_location



--=======================================
--Checking 'silver.erp_category'
--=======================================
-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT 
    *
FROM silver.erp_category
WHERE category != TRIM(category)
   OR sub_category != TRIM(sub_category)
   OR maintenance != TRIM(maintenance);


-- Data Standardization & Consistency
SELECT DISTINCT 
    maintenance
FROM silver.erp_category





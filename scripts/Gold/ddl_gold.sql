/*
*************************************************************************************************
  DDL scripy  :  Creates Gold View

  Script Purpose : This script create views for the Gold lsyer in the Data Warehouse.
                    The Gold Layer represents the final dimension and fact tables (Star Schema)


                  Each view performs transformation and combines data from the Silver layer 
                  to produce and clean enriched, and business - ready dataset.

Usage : 
          - These views can be queried directly for analytics and reporting. 
*************************************************************************************************
*/


------------------------------------------------------------
-- DIM TABLE : CUSTOMERS (gold.dim_customers)
------------------------------------------------------------
CREATE VIEW gold.dim_customers AS 
SELECT
    ROW_NUMBER() OVER (ORDER BY crm_c.cst_id) AS customer_key,
    crm_c.cst_id                              AS customer_id,
    crm_c.cst_key                             AS customer_number,
    crm_c.cst_firstname                       AS first_name,
    crm_c.cst_lastname                        AS last_name,
    erp_l.loc_country                         AS country,
    crm_c.cst_martial_status                  AS martial_status,
    CASE 
        WHEN crm_c.cst_gndr != 'N/A' THEN crm_c.cst_gndr 
        ELSE COALESCE(erp_c.cst_gender, 'N/A')
    END                                       AS gender,
    crm_c.cst_create_date                     AS create_date,
    erp_c.cst_birthdate                       AS birth_date
FROM silver.crm_cust_info AS crm_c
LEFT JOIN silver.erp_customers AS erp_c
    ON erp_c.cst_id = crm_c.cst_key
LEFT JOIN silver.erp_location AS erp_l
    ON crm_c.cst_key = erp_l.loc_customer_id;
GO


------------------------------------------------------------
-- QUALITY CHECK : DIM_CUSTOMERS (gold.dim_customers)
-- Ensure gender column has valid values only
------------------------------------------------------------
SELECT DISTINCT gender 
FROM gold.dim_customers;
GO

 
------------------------------------------------------------
-- DIM TABLE : PRODUCT (gold.dim_product)
------------------------------------------------------------
CREATE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY sp.prd_start_date, sp.prd_key) AS product_key,
    sp.prd_id              AS product_id,
    sp.prd_key             AS product_number,
    sp.prd_name            AS product_name,
    sp.prd_cat_key         AS category_id,
    sc.category            AS category,
    sc.sub_category        AS sub_category,
    sc.maintenance         AS maintenance,
    sp.prd_cost            AS cost,
    sp.prd_line            AS product_line,
    sp.prd_start_date      AS start_date
FROM silver.crm_prd_info AS sp
LEFT JOIN silver.erp_category AS sc
    ON sp.prd_cat_key = sc.cst_id
WHERE prd_end_date IS NULL;
GO


------------------------------------------------------------
-- QUALITY CHECK : DIM_PRODUCT
-- Validate there are no null product names or negative costs
------------------------------------------------------------
SELECT 
    COUNT(*) AS null_product_names
FROM gold.dim_product
WHERE product_name IS NULL;

SELECT 
    COUNT(*) AS negative_cost_products
FROM gold.dim_product
WHERE cost < 0;

SELECT 
    category, COUNT(*) AS product_count
FROM gold.dim_product
GROUP BY category
ORDER BY product_count DESC;
GO


  
------------------------------------------------------------
-- FACT TABLE : SALES (gold.fact_sales)
------------------------------------------------------------
CREATE VIEW gold.fact_sales AS 
SELECT 
    gp.product_key,
    sd.sales_ord_num   AS order_number,
    dc.customer_key,
    sd.sales_order_dt  AS order_date,
    sd.sales_ship_dt   AS ship_date,
    sd.sales_due_dt    AS due_date,
    sd.sales_sales     AS sales_amount,
    sd.sales_quantity  AS quantity,
    sd.sales_price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_product AS gp
    ON sd.sales_prd_key = gp.product_number
LEFT JOIN gold.dim_customers AS dc
    ON sd.sales_cust_id = dc.customer_id;
GO


------------------------------------------------------------
-- QUALITY CHECK : FACT_SALES
-- Verify all sales records link correctly to customers and products
------------------------------------------------------------
SELECT * 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_product AS p
    ON f.product_key = p.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;
GO

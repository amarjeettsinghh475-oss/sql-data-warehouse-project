/**************************************************************************************************
  Script Name : silver.load_silver
  Description : This stored procedure loads data from the Bronze layer to the Silver layer.
                It truncates and reloads several CRM and ERP tables with cleaned and transformed data.
  
                - Ensures data quality through trimming, validation, and formatting.
                - Handles CRM and ERP domains separately.
                - Prints duration logs for each table load.
**************************************************************************************************/

EXEC silver.load_silver
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, 
            @end_time DATETIME, 
            @batch_start_time DATETIME, 
            @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '=================================';
        PRINT 'Loading Silver Layer';
        PRINT '=================================';

        PRINT '----------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '----------------------------------';

        ----------------------------------------------------
        -- Load silver.crm_cust_info
        ----------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserting Data Into: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
              cst_id,
              cst_key,
              cst_firstname,
              cst_lastname,
              cst_martial_status,
              cst_gndr,
              cst_create_date
        )
        SELECT
              cst_id,	
              cst_key,
              TRIM(cst_firstname) AS cst_firstname,																		
              TRIM(cst_lastname)  AS cst_lastname,																		
              CASE 
                   WHEN UPPER(TRIM(cst_martial_status)) = 'S' THEN 'Single'
                   WHEN UPPER(TRIM(cst_martial_status)) = 'M' THEN 'Married'
                   ELSE 'N/A'
              END AS cst_martial_status,
              CASE 
                   WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'															
                   WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                   ELSE 'N/A'
              END AS cst_gndr,
              cst_create_date
        FROM (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE Flag_ = 1;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        ----------------------------------------------------
        -- Load silver.crm_prd_info
        ----------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserting Data Into: silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id,
            prd_cat_key,
            prd_key,
            prd_name,
            prd_cost,
            prd_line,
            prd_start_date,
            prd_end_date
        )
        SELECT 
              prd_id,
              REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS prd_cat_key,
              SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
              prd_name,
              ISNULL(prd_cost, 0) AS prd_cost,
              CASE UPPER(TRIM(prd_line))
                    WHEN 'M' THEN 'Mountain'
                    WHEN 'R' THEN 'Road' 
                    WHEN 'S' THEN 'Other Sales'
                    WHEN 'T' THEN 'Touring' 
                    ELSE 'N/A'
              END AS prd_line,
              prd_start_date,
              DATEADD(DAY, -1, LEAD(prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date)) AS prd_end_date
        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        ----------------------------------------------------
        -- Load silver.crm_sales_details
        ----------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserting Data Into: silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sales_ord_num,
            sales_prd_key,
            sales_cust_id,
            sales_order_dt,
            sales_due_dt,
            sales_ship_dt,
            sales_sales,
            sales_quantity,
            sales_price
        )
        SELECT 
            sales_ord_num,
            sales_prd_key,
            sales_cust_id,
            CASE 
                WHEN sales_order_dt = 0 OR LEN(sales_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sales_order_dt AS VARCHAR) AS DATE)
            END AS sales_order_dt,
            CASE 
                WHEN sales_due_dt = 0 OR LEN(sales_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sales_due_dt AS VARCHAR) AS DATE)
            END AS sales_due_dt,
            CASE 
                WHEN sales_ship_dt = 0 OR LEN(sales_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sales_ship_dt AS VARCHAR) AS DATE)
            END AS sales_ship_dt,
            CASE 
                WHEN sales_sales != sales_quantity * ABS(sales_price) 
                     OR sales_sales IS NULL 
                     OR sales_sales <= 0 
                THEN sales_quantity * ABS(sales_price)
                ELSE sales_sales
            END AS sales_sales,
            sales_quantity,
            CASE 
                WHEN sales_price IS NULL OR sales_price <= 0
                THEN sales_sales / NULLIF(sales_quantity, 0)
                ELSE sales_price
            END AS sales_price
        FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        PRINT '----------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '----------------------------------';

        ----------------------------------------------------
        -- Load silver.erp_customers
        ----------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_customers';
        TRUNCATE TABLE silver.erp_customers;

        PRINT '>> Inserting Data Into: silver.erp_customers';
        INSERT INTO silver.erp_customers (
            cst_id,
            cst_birthdate,
            cst_gender
        )
        SELECT 
            CASE WHEN cst_id LIKE 'NAS%' THEN SUBSTRING(cst_id, 4, LEN(cst_id)) ELSE cst_id END AS cst_id,
            CASE WHEN cst_birthdate > GETDATE() THEN NULL ELSE cst_birthdate END AS cst_birthdate,
            CASE 
                WHEN TRIM(UPPER(cst_gender)) IN ('M', 'MALE') THEN 'Male'
                WHEN TRIM(UPPER(cst_gender)) IN ('F', 'FEMALE') THEN 'Female'
                ELSE 'N/A'
            END AS cst_gender
        FROM bronze.erp_customers;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        ----------------------------------------------------
        -- Load silver.erp_location
        ----------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_location';
        TRUNCATE TABLE silver.erp_location;

        PRINT '>> Inserting Data Into: silver.erp_location';
        INSERT INTO silver.erp_location (
            loc_customer_id,
            loc_country
        )
        SELECT
            REPLACE(loc_customer_id, '-', '') AS loc_customer_id,
            CASE 
                WHEN TRIM(loc_country) = 'DE' THEN 'Germnay'
                WHEN TRIM(loc_country) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(loc_country) = '' OR TRIM(loc_country) IS NULL THEN 'N/A'
                ELSE TRIM(loc_country)
            END AS loc_country
        FROM bronze.erp_location;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        ----------------------------------------------------
        -- Load silver.erp_category
        ----------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_category';
        TRUNCATE TABLE silver.erp_category;

        PRINT '>> Inserting Data Into: silver.erp_category';
        INSERT INTO silver.erp_category (
            cst_id,
            category,
            sub_category,
            maintenance
        )
        SELECT 
            cst_id,
            category,
            sub_category,
            maintenance
        FROM bronze.erp_category;

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        ----------------------------------------------------
        -- Completion
        ----------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '===============================================';
        PRINT 'Loading Silver Layer is completed';
        PRINT '    - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===============================================';

    END TRY
    BEGIN CATCH 
        PRINT '===================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===================================================';
    END CATCH
END
GO

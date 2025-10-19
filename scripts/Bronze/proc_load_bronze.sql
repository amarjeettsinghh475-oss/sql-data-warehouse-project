/*
==========================================================
Stored Procedure : Load Bronze Layer (Source -> Bronze)
=========================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the 'BULK INSERT' command to load data from csv Files to Bronze Tables.

Parameters:
  None.
This stored procedure does not accept any parameters or return any values.

Use Example:
  EXEC bronze.load_bronze;
==========================================================
*/

EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE 
        @start_time DATETIME, 
        @end_time DATETIME, 
        @batch_start_time DATETIME, 
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=================================';

        PRINT '----------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '----------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info; -- refresh data every time we hit execute

        PRINT '>> Inserting data into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
            FROM 'C:\Users\amarn\OneDrive\SQL\sql_datawarehouse_project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info; -- refresh data every time we hit execute

        PRINT '>> Inserting data into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
            FROM 'C:\Users\amarn\OneDrive\SQL\sql_datawarehouse_project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details; -- refresh data every time we hit execute

        PRINT '>> Inserting data into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
            FROM 'C:\Users\amarn\OneDrive\SQL\sql_datawarehouse_project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        PRINT '----------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '----------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.erp_customers';
        TRUNCATE TABLE bronze.erp_customers; -- refresh data every time we hit execute

        PRINT '>> Inserting data into: bronze.erp_customers';
        BULK INSERT bronze.erp_customers
            FROM 'C:\Users\amarn\OneDrive\SQL\sql_datawarehouse_project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.erp_location';
        TRUNCATE TABLE bronze.erp_location; -- refresh data every time we hit execute

        PRINT '>> Inserting data into: bronze.erp_location';
        BULK INSERT bronze.erp_location
            FROM 'C:\Users\amarn\OneDrive\SQL\sql_datawarehouse_project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.erp_category';
        TRUNCATE TABLE bronze.erp_category; -- refresh data every time we hit execute

        PRINT '>> Inserting Data into: bronze.erp_category';
        BULK INSERT bronze.erp_category
            FROM 'C:\Users\amarn\OneDrive\SQL\sql_datawarehouse_project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>-------------------------------';

        SET @batch_end_time = GETDATE();
        PRINT '===============================================';
        PRINT 'Loading Bronze Layer is completed';
        PRINT '    - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
        PRINT '=================================================';

    END TRY
    BEGIN CATCH 
        PRINT '===================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST(ERROR_MESSAGE() AS NVARCHAR);
        PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===================================================';
    END CATCH
END

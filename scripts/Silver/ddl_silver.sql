/**************************************************************************************************
  Script Name : silver_layer_table_creation.sql
  Description : This script creates all tables in the Silver Layer for CRM and ERP domains.
                Existing tables are dropped before recreation to ensure schema consistency.

                - Tables include audit field [dwh_create_date] with default timestamp.
                - Each CREATE TABLE statement is prefixed with a drop check.
                - No column-level comments for cleaner code style.
**************************************************************************************************/

------------------------------------------------------------
-- 1. CRM Customer Information
------------------------------------------------------------
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_martial_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


------------------------------------------------------------
-- 2. CRM Product Information
------------------------------------------------------------
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    prd_cat_key     NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_name        NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_date  DATE,
    prd_end_date    DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


------------------------------------------------------------
-- 3. CRM Sales Details
------------------------------------------------------------
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sales_ord_num   VARCHAR(20)  NOT NULL,
    sales_prd_key   NVARCHAR(20) NOT NULL,
    sales_cust_id   INT          NOT NULL,
    sales_order_dt  DATE         NULL,
    sales_ship_dt   DATE         NULL,
    sales_due_dt    DATE         NULL,
    sales_sales     INT          NULL,
    sales_quantity  INT          NULL,
    sales_price     INT          NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


------------------------------------------------------------
-- 4. ERP Customer Master
------------------------------------------------------------
IF OBJECT_ID('silver.erp_customers', 'U') IS NOT NULL
    DROP TABLE silver.erp_customers;
GO

CREATE TABLE silver.erp_customers (
    cst_id          NVARCHAR(50) NOT NULL,
    cst_birthdate   DATE         NULL,
    cst_gender      CHAR(10)     NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


------------------------------------------------------------
-- 5. ERP Location Details
------------------------------------------------------------
IF OBJECT_ID('silver.erp_location', 'U') IS NOT NULL
    DROP TABLE silver.erp_location;
GO

CREATE TABLE silver.erp_location (
    loc_customer_id NVARCHAR(50) NOT NULL,
    loc_country     VARCHAR(50)  NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


------------------------------------------------------------
-- 6. ERP Category Details
------------------------------------------------------------
IF OBJECT_ID('silver.erp_category', 'U') IS NOT NULL
    DROP TABLE silver.erp_category;
GO

CREATE TABLE silver.erp_category (
    cst_id          NVARCHAR(50) NOT NULL,
    category        VARCHAR(50)  NOT NULL,
    sub_category    VARCHAR(50)  NULL,
    maintenance     CHAR(3)      NULL,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

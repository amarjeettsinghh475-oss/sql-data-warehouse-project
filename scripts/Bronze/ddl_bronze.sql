/*
=======================================================================================
DDL SCRIPT : Create Bronze Table
=======================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'Bronze' tables
=======================================================================================
*/

-- =====================================================================================
-- 1. CRM Customer Information
-- =====================================================================================

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,            -- Unique customer ID
    cst_key             NVARCHAR(50),   -- Business/customer key from source
    cst_firstname       NVARCHAR(50),   -- Customer first name
    cst_lastname        NVARCHAR(50),   -- Customer last name
    cst_martial_status  NVARCHAR(50),   -- Marital status (Single, Married, etc.)
    cst_gndr            NVARCHAR(50),   -- Gender (Male/Female/Other)
    cst_create_date     DATE            -- Customer creation date
);

-- =====================================================================================
-- 2. CRM Product Information
-- =====================================================================================

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id          INT,            -- Product ID
    prd_key         NVARCHAR(50),   -- Product key from source
    prd_name        NVARCHAR(50),   -- Product name
    prd_cost        INT,            -- Cost of product
    prd_line        NVARCHAR(50),   -- Product line/category
    prd_start_date  DATE,           -- Product launch/start date
    prd_end_date    DATE            -- Product end/discontinue date
);

-- =====================================================================================
-- 3. CRM Sales Details
-- =====================================================================================

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sales_ord_num   VARCHAR(20)     NOT NULL,   -- e.g. Order number (string)
    sales_prd_key   NVARCHAR(20)    NOT NULL,   -- Product key (dimension reference)
    sales_cust_id   INT             NOT NULL,   -- Customer ID (dimension reference)
    sales_order_dt  INT             NOT NULL,   -- Order date
    sales_ship_dt   INT             NULL,       -- Shipment date
    sales_due_dt    INT             NULL,       -- Due date
    sales_sales     INT             NULL,       -- Total sales amount
    sales_quantity  INT             NULL,       -- Quantity sold
    sales_price     INT             NULL        -- Unit price
);

-- =====================================================================================
-- 4. ERP Customer Master
-- =====================================================================================

IF OBJECT_ID('bronze.erp_customers', 'U') IS NOT NULL
    DROP TABLE bronze.erp_customers;

CREATE TABLE bronze.erp_customers (
    cst_id         NVARCHAR(50)     NOT NULL,   -- Customer ID
    cst_birthdate  DATE             NULL,       -- Birth date
    cst_gender     CHAR(10)         NULL        -- Gender
);

-- =====================================================================================
-- 5. ERP Location Details
-- =====================================================================================

IF OBJECT_ID('bronze.erp_location', 'U') IS NOT NULL
    DROP TABLE bronze.erp_location;

CREATE TABLE bronze.erp_location (
    loc_customer_id NVARCHAR(50)    NOT NULL,   -- Customer ID (links to ERP Customers)
    loc_country     VARCHAR(50)     NULL        -- Country name
);

-- =====================================================================================
-- 6. ERP Category Details
-- =====================================================================================

IF OBJECT_ID('bronze.erp_category', 'U') IS NOT NULL
    DROP TABLE bronze.erp_category;

CREATE TABLE bronze.erp_category (
    cst_id       NVARCHAR(50)     NOT NULL,   -- Category ID
    category     VARCHAR(50)      NOT NULL,   -- Main category
    sub_category VARCHAR(50)      NULL,       -- Subcategory
    maintenance  CHAR(3)          NULL        -- Maintenance flag
);

/*
=======================================
DDL Script: Create Silver Tables
=======================================
Script Purpose:
      This script creates tables in the 'silver' schema, dropping existing tables
      if they already exists.
      Run this script to re-define the DDL structure od 'bronze' Tables
=====================================
*/
-------------------------------------------
-- 1. CRM Customer Information
-------------------------------------------

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id              INT,                -- Unique customer ID
    cst_key             NVARCHAR(50),       -- Business/customer key from silver.
    cst_firstname       NVARCHAR(50),       -- Customer first name
    cst_lastname        NVARCHAR(50),       -- Customer last name
    cst_martial_status  NVARCHAR(50),       -- Marital status (Single, Married, etc.)
    cst_gndr            NVARCHAR(50),       -- Gender (Male/Female/Other)
    cst_create_date     DATE,               -- Customer creation date
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

-------------------------------------------
-- 2. CRM Product Information
-------------------------------------------

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,                         -- Product ID
	  prd_cat_key     NVARCHAR (50),
    prd_key         NVARCHAR(50),                -- Product key from silver.
    prd_name        NVARCHAR(50),                -- Product name
    prd_cost        INT,                         -- Cost of product
    prd_line        NVARCHAR(50),                -- Product line/category
    prd_start_date  DATE,                        -- Product launch/start date
    prd_end_date    DATE,                        -- Product end/discontinue date
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-------------------------------------------
--3. CRM Sales Details
-------------------------------------------

IF OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sales_ord_num     VARCHAR(20)                NOT NULL,     -- e.g. Order number (string)
    sales_prd_key     NVARCHAR(20)               NOT NULL,     -- Product key (dimension reference)
    sales_cust_id     INT                        NOT NULL,     -- Customer ID (dimension reference)
    sales_order_dt    DATE                       NULL,         -- Order date
    sales_ship_dt     DATE                       NULL,         -- Shipment date
    sales_due_dt      DATE                       NULL,         -- Due date
    sales_sales       INT                        NULL,         -- Total sales amount
    sales_quantity    INT                        NULL,         -- Quantity sold
    sales_price       INT                        NULL,         -- Unit price
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

-------------------------------------------
-- 4. ERP Customer Master
-------------------------------------------

IF OBJECT_ID ('silver.erp_customers','U') IS NOT NULL
	DROP TABLE silver.erp_customers;

CREATE TABLE silver.erp_customers (
    cst_id				NVARCHAR(50)            NOT NULL,           -- Customer ID
    cst_birthdate		DATE           NULL,                      -- Birth date
    cst_gender			CHAR(10)       NULL  ,                    -- Gender
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

-------------------------------------------
-- 5. ERP Location Details
-------------------------------------------

IF OBJECT_ID ('silver.erp_location','U') IS NOT NULL
	DROP TABLE silver.erp_location;

CREATE TABLE silver.erp_location (
    loc_customer_id     NVARCHAR(50)            NOT NULL,   -- Customer ID (links to ERP Customers)
    loc_country			VARCHAR(50)    NULL,                    -- Country name
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-------------------------------------------
-- 6. ERP Category Details
-------------------------------------------

IF OBJECT_ID ('silver.erp_category','U') IS NOT NULL
	DROP TABLE silver.erp_category;

CREATE TABLE silver.erp_category (
    cst_id			NVARCHAR(50)          NOT NULL, 		  -- Category ID
    category		VARCHAR(50)   NOT NULL,				      	-- Main category
    sub_category	VARCHAR(50)   NULL,  					      -- Subcategory
    maintenance		CHAR(3)		NULL,						          -- Maintenance flag
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

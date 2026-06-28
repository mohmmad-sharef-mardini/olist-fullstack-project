/*
================================================================
 File:        00_create_src_tables.sql
 Project:     Olist E-Commerce Data Warehouse
 Layer:       Raw (landing zone)
 Purpose:     Create raw tables to receive Olist source CSVs
 Author:      Mohammad Sharef Mardini
 Created:     2026-06-21
 Notes:       Idempotent — safe to re-run without errors.
              Raw layer: no constraints, NVARCHAR types,
              audit columns added to every table.
================================================================
*/

-- ----------------------------------------------------------
-- 1.1  Create src_olist_customers_dataset table 
-- ----------------------------------------------------------

use OlistDW
IF OBJECT_ID('raw_ecomm.src_olist_customers_dataset', 'U') IS NULL
CREATE TABLE raw_ecomm.src_olist_customers_dataset (
    
	customer_id               NVARCHAR(50),   ---- customer regarding the order id
    customer_unique_id        NVARCHAR(50),   ---- customer id  - Not Uinque
    customer_zip_code_prefix  NVARCHAR(10),
    customer_city             NVARCHAR(100),
    customer_state            NVARCHAR(50),

    -- audit columns
    load_ts       DATETIME2     DEFAULT SYSDATETIME(),
    batch_id      INT,
    source_file   NVARCHAR(200)
);
GO

-- ----------------------------------------------------------
-- 1.2  Create src_olist_geolocation_dataset table 
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_geolocation_dataset','U') IS NULL
CREATE TABLE raw_ecomm.src_olist_geolocation_dataset(

	geolocation_zip_code_prefix	 NVARCHAR(25), 
	geolocation_lat				 NVARCHAR(50), 
	geolocation_lng				 NVARCHAR(50), 
	geolocation_city			 NVARCHAR(100), 
	geolocation_state			 NVARCHAR(50), 

-- audit columns 
	load_ts						DATETIME2 DEFAULT SYSDATETIME(),
	batch_id			        INT, 
	source_file					NVARCHAR(200)

);
GO

-- ----------------------------------------------------------
-- 1.3  Create src_olist_order_items_dataset table 
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_order_items_dataset','U') IS NULL

CREATE TABLE raw_ecomm.src_olist_order_items_dataset(

	order_id                 NVARCHAR(50),  --- NOT UNIQUE
	order_item_id			 NVARCHAR(50),			--- THE ITEM NUMBER IN THE ORDER 
	product_id				 NVARCHAR(50), 
	seller_id				 NVARCHAR(50),
	shipping_limit_date      NVARCHAR(50), 
	price					 NVARCHAR(50), 
	freight_value			 NVARCHAR(50), --- tem freight value item (if an order has more than one item the freight value is splitted between items)

-- audit columns 
	load_ts					 DATETIME2 DEFAULT SYSDATETIME(),
	batch_id			     INT, 
	source_file				 NVARCHAR(200)

);
GO


-- ----------------------------------------------------------
-- 1.4  Create src_olist_order_payments_dataset 
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_order_payments_dataset','U') IS NULL 

CREATE TABLE raw_ecomm.src_olist_order_payments_dataset(

	order_id                     NVARCHAR(50), --- NOT UNIQUE
	payment_sequential			 NVARCHAR(50),
	payment_type				 NVARCHAR(50),
	payment_installments         NVARCHAR(50),
	payment_value                NVARCHAR(50),

-- audit columns 
	load_ts						DATETIME2 DEFAULT SYSDATETIME(),
	batch_id			        INT, 
	source_file					NVARCHAR(200)

);
GO

-- ----------------------------------------------------------
-- 1.5  Create src_olist_order_reviews_dataset
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_order_reviews_dataset','U') IS NULL 

CREATE TABLE raw_ecomm.src_olist_order_reviews_dataset(
	review_id					NVARCHAR(50),
	order_id					NVARCHAR(50),
	review_score				NVARCHAR(50),
	review_comment_title		NVARCHAR(100),  -- Comment title from the review left by the customer, in Portuguese sUCH AS : GOOD, BAD 
	review_comment_message		NVARCHAR(MAX),  -- Comment message from the review left by the customer, in Portuguese
	review_creation_date		NVARCHAR(50),   -- Shows the date in which the satisfaction survey was sent to the customer
	review_answer_timestamp		NVARCHAR(50),   -- Shows satisfaction survey answer timestamp.

-- audit columns 
	load_ts						DATETIME2 DEFAULT SYSDATETIME(),
	batch_id			        INT, 
	source_file					NVARCHAR(200)

);
GO

-- ----------------------------------------------------------
-- 1.6  Create src_olist_orders_dataset
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_orders_dataset','U') IS  NULL 
CREATE TABLE raw_ecomm.src_olist_orders_dataset(
	order_id						NVARCHAR(50),
	customer_id						NVARCHAR(50),
	order_status					NVARCHAR(50),
	order_purchase_timestamp		NVARCHAR(100),  
	order_approved_at	    		NVARCHAR(50),   -- Shows the payment approval timestamp.
	order_delivered_carrier_date	NVARCHAR(50),  
	order_delivered_customer_date	NVARCHAR(50),   
	order_estimated_delivery_date   NVARCHAR(50),

	-- audit columns
	load_ts							DATETIME2 DEFAULT SYSDATETIME(), 
	batch_id						INT, 
	source_file						NVARCHAR(200)

);
GO
-- ----------------------------------------------------------
-- 1.7  Create src_olist_products_dataset
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_products_dataset','U') IS NULL 
CREATE TABLE raw_ecomm.src_olist_products_dataset(
	product_id						NVARCHAR(50),
	product_category_name			NVARCHAR(50),
	product_name_lenght				NVARCHAR(50),
	product_description_lenght		NVARCHAR(100),  ----- TYPO FROM SOURCE _lenght
	product_photos_qty	    		NVARCHAR(50),   
	product_weight_g				NVARCHAR(50),  
	product_length_cm				NVARCHAR(50),   
	product_height_cm               NVARCHAR(50),
	product_width_cm				NVARCHAR(50),

	-- audit columns
	load_ts							DATETIME2 DEFAULT SYSDATETIME(), 
	batch_id						INT, 
	source_file						NVARCHAR(200)

);
GO


-- ----------------------------------------------------------
-- 1.8  Create src_olist_sellers_dataset
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_olist_sellers_dataset','U') IS NULL 

CREATE TABLE raw_ecomm.src_olist_sellers_dataset(

	seller_id					NVARCHAR(50), 
	seller_zip_code_prefix		NVARCHAR(50), 
	seller_city					NVARCHAR(50),
	seller_state				NVARCHAR(50),

-- audit columns 
	
	load_ts						DATETIME2 DEFAULT SYSDATETIME(), 
	batch_id					INT, 
	source_file					NVARCHAR(100)
);
GO

-- ----------------------------------------------------------
-- 1.9  Create src_product_category_name_translation
-- ----------------------------------------------------------

IF OBJECT_ID('raw_ecomm.src_product_category_name_translation','U') IS NULL 

CREATE TABLE raw_ecomm.src_product_category_name_translation(

	product_category_name		        NVARCHAR(50), 
	product_category_name_english		NVARCHAR(50), 
	
-- audit columns 
	
	load_ts						DATETIME2 DEFAULT SYSDATETIME(), 
	batch_id					INT, 
	source_file					NVARCHAR(100)
);
GO


-- verify they all exist

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA= 'raw_ecomm;
---------------------------------------
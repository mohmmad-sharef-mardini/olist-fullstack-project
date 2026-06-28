/*
================================================================
 File:        03_create_ctrl_pipeline_log.sql
 Project:     Olist E-Commerce Data Warehouse
 Layer:       Control / Infrastructure (ctrl schema)
 Purpose:     Create Ctrl Table to track the Pipeline and detect the failure and Monitoring and auditing
 Author:      Mohammad Sharef Mardini
 Created:     2026-06-22
 Notes:       Idempotent — safe to re-run without errors.
================================================================
*/

USE OlistDW;
GO
-- ----------------------------------------------------------
-- 3.1  Create ctrl.pipeline_log table
-- ----------------------------------------------------------

IF OBJECT_ID('ctrl.pipeline_log','U') IS NULL
CREATE TABLE ctrl.pipeline_log(

	batch_id				INT IDENTITY(1,1) PRIMARY KEY, 
	pipeline_name			NVARCHAR(50),	-- Which pipeline ran Ex: load_raw_customers
	stage					NVARCHAR(50), -- Which layer EX: STAGING or Warehouse
	status					NVARCHAR(20), -- RUNNING, PASSED, FAILED
	rows_processed			INT,  
	error_message			NVARCHAR(MAX),
	started_at				DATETIME2 DEFAULT SYSDATETIME(), 
	completed_at			DATETIME2
);
GO
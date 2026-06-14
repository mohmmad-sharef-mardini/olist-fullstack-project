/*
================================================================
 File:        00_create_database_schemas.sql
 Project:     Olist E-Commerce Data Warehouse
 Layer:       Setup / Initialization
 Purpose:     Create OlistDW database and 6 layered schemas
 Author:      Mohmmad Sharef Mardini
 Created:     2026-06-14
 Notes:       Idempotent — safe to re-run without errors.
================================================================
*/

-- ----------------------------------------------------------
-- 1.1  Create Database OlistDW
-- ----------------------------------------------------------
USE MASTER;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'OlistDW')
    CREATE DATABASE OlistDW;
GO

USE OlistDW;
GO

-- ----------------------------------------------------------
-- 1.2  Create Layered Schemas
--      Each schema isolates one pipeline layer for clarity,
--      security (schema-level grants), and easier debugging.
--
--      raw_ecomm   -> landing zone, untransformed source data
--      stg_ecomm   -> cleaned, typed, deduplicated
--      dw_ecomm    -> star schema (facts + dimensions)
--      mart_ecomm  -> aggregated, BI-ready tables
--      ctrl        -> pipeline control, watermark, DQ, logs
--      sandbox     -> safe area for testing on small samples
--
--      Note: EXEC is required because CREATE SCHEMA must be
--      the first statement in its batch.
-- ----------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'raw_ecomm')  EXEC('CREATE SCHEMA raw_ecomm');
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg_ecomm')  EXEC('CREATE SCHEMA stg_ecomm');
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dw_ecomm')   EXEC('CREATE SCHEMA dw_ecomm');
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'mart_ecomm') EXEC('CREATE SCHEMA mart_ecomm');
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'ctrl')       EXEC('CREATE SCHEMA ctrl');
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'sandbox')    EXEC('CREATE SCHEMA sandbox');
GO

-- ----------------------------------------------------------
-- 1.3  Verify schemas created
-- ----------------------------------------------------------
SELECT name
FROM sys.schemas
WHERE name IN ('raw_ecomm','stg_ecomm','dw_ecomm','mart_ecomm','ctrl','sandbox');
GO





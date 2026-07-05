===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze) - Bulk insert and truncate, create procedure, timestamp of loading
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:

Process:
    - TRUNCATE TABLE to remove existing records.
    - COPY FROM CSV into Bronze tables.
    - RAISE NOTICE for execution logging.
    - EXCEPTION block handles and propagates load failures.

Usage:
    CALL bronze.load_bronze();
===============================================================================
*/ 

CALL bronze.load_bronze();
DROP PROCEDURE IF EXISTS bronze.load_bronze();

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    --------------------------------------------------------------------
    -- CRM TABLES
    --------------------------------------------------------------------

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';

    --------------------------------------------------------------------
    -- CRM CUSTOMER
    --------------------------------------------------------------------

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

    RAISE NOTICE '>> Loading bronze.crm_cust_info';

    COPY bronze.crm_cust_info
    FROM 'C:/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time-start_time)),2);

    --------------------------------------------------------------------
    -- CRM PRODUCT
    --------------------------------------------------------------------

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;

    RAISE NOTICE '>> Loading bronze.crm_prd_info';

    COPY bronze.crm_prd_info
    FROM 'C:/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time-start_time)),2);

    --------------------------------------------------------------------
    -- CRM SALES
    --------------------------------------------------------------------

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;

    RAISE NOTICE '>> Loading bronze.crm_sales_details';

    COPY bronze.crm_sales_details
    FROM 'C:/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time-start_time)),2);

    --------------------------------------------------------------------
    -- ERP TABLES
    --------------------------------------------------------------------

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';

    --------------------------------------------------------------------
    -- ERP LOCATION
    --------------------------------------------------------------------

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;

    RAISE NOTICE '>> Loading bronze.erp_loc_a101';

    COPY bronze.erp_loc_a101
    FROM 'C:/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time-start_time)),2);

    --------------------------------------------------------------------
    -- ERP CUSTOMER
    --------------------------------------------------------------------

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;

    RAISE NOTICE '>> Loading bronze.erp_cust_az12';

    COPY bronze.erp_cust_az12
    FROM 'C:/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time-start_time)),2);

    --------------------------------------------------------------------
    -- ERP PRODUCT CATEGORY
    --------------------------------------------------------------------

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    RAISE NOTICE '>> Loading bronze.erp_px_cat_g1v2';

    COPY bronze.erp_px_cat_g1v2
    FROM 'C:/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time-start_time)),2);

    --------------------------------------------------------------------

    batch_end_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Bronze Layer Loaded Successfully';
    RAISE NOTICE 'Total Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (batch_end_time-batch_start_time)),2);
    RAISE NOTICE '================================================';

EXCEPTION
    WHEN OTHERS THEN

        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR OCCURRED DURING BRONZE LOAD';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE NOTICE '================================================';

        RAISE;
END;
$$;


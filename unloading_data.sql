show tables in snowflake_db.public;

-- create schema to store stage for storing output files 
create or replace schema snowflake_db.ext_stage_files;

-- create external stage to store output files 
create or replace stage snowflake_db.ext_stage_files.gen2_output
    url = 'azure://snowflakegen2.blob.core.windows.net/snowflakeazurefiles/output/'
    -- file_format = snowflake_db.file_formats.csv_file_format
    storage_integration = SNOW_AZURE_INT;



-- generate file and store them into stagelocation
copy into @snowflake_db.ext_stage_files.gen2_output/customer
    from snowflake_db.public.vendors
    overwrite = true
    max_file_size = 5120;


-- generate single file 
copy into @snowflake_db.ext_stage_files.gen2_output/customer
    from snowflake_db.public.vendors
    overwrite = true
    single = true;


-- deatiled output
copy into @snowflake_db.ext_stage_files.gen2_output/customer
    from snowflake_db.public.vendors
    overwrite = true
    detailed_output = true;

list @snowflake_db.ext_stage_files.gen2_output;
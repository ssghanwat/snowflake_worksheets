use database snowflake_db;


-- create storage integration obbject 
create or replace storage integration snow_azure_int
    type = external_stage
    storage_provider = 'azure'
    enabled = true
    azure_tenant_id = '2c7903f1-7ce0-4c7d-b045-883f20a795f7'
    storage_allowed_locations = ('azure://snowflakegen2.blob.core.windows.net/snowflakeazurefiles/');


-- describe storage integration object 
desc storage integration snow_azure_int


-- create database and schema
create database if not exists snowflake_db;
create schema if not exists snowflake_db.file_formats;
create schema if not exists snowflake_db.external_stages;


-- create file format object
create or replace file format snowflake_db.file_formats.csv_file_format
    type = csv 
    field_delimiter = ','
    skip_header = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    empty_field_as_null = true;


-- create stage object with integration object  and file_format
create or replace stage snowflake_db.external_stages.stg_azure_cont
    url = 'azure://snowflakegen2.blob.core.windows.net/snowflakeazurefiles'
    storage_integration = snow_azure_int
    file_format = snowflake_db.file_formats.csv_file_format;

list @stg_azure_cont;

desc database  snowflake_db;

select $1, $2, $3, $4, $5 from @snowflake_db.external_stages.stg_azure_cont/vendors.csv;

create or replace table snowflake_db.public.vendors(
    V_ID int,
    V_NAME varchar(20),
    V_ADD varchar(50),
    V_CONTACT varchar(50),
    V_CREDITDAYS varchar(50),
    V_JDATE varchar(50));

show tables in snowflake_db.public;


copy into snowflake_db.public.vendors
    from @snowflake_db.external_stages.stg_azure_cont/vendors.csv;

select * from snowflake_db.public.vendors;
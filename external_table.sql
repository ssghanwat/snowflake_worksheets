-- create eternal stages
create schema if not exists external_stage;

create  schema if not exists file_format;

create schema if not exists ext_tables;


-- create file format object
create or replace file format snowflake_db.file_format.csv_file_formats
    type = csv,
    field_delimiter = '|',
    skip_header =  1,
    empty_field_as_null = true;


-- create stage object with integration object and file format
-- using the storage integration object that was already created 
--ghjhkh

create or replace stage  snowflake_db.external_stage.s3_stage
    url = 'azure://'
    file_format = snowflake_db.file_format.csv_file_formats;

list @snowflake_db.external_stage.s3_stage;
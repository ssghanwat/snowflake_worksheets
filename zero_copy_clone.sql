-- cloninng table
create or replace table vendors_clone clone snowflake_db.public.vendors;

select * from snowflake_db.public.vendors;
select * from snowflake_db.public.vendors_clone;

-- cloning schema 
create or replace schema sile_formats_clone clone snowflake_db.file_formats;

show tables in snowflake_db.file_formats;
show tables in snowflake_db.sile_formats_clone;


-- cloning databases
create or replace database snowflake_db_clone clone snowflake_db;

show tables in snowflake_db_clone;


-- cloning from cloned object
create or replace table snowflake_db.public.vendors_clone_2 clone snowflake_db.public.vendors_clone;
select * from snowflake_db.public.vendors_clone_2;


SHOW TABLES ;
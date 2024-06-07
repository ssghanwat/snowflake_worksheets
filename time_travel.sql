-- where can we see the retention period 
show tables in schema snowflake_db.public;
show schemas in database;
show databases;

-- how to set this at the time of table creation
create or replace table snowflake_db.public.timetravel_ex(id number, name string);

show tables like 'timetravel_ex%';

create or replace table snowflake_db.public.timetravel_ex(id number, name string)
DATA_RETENTION_TIME_IN_DAYS = 10;

-- how to alter retention period
alter table snowflake_db.public.timetravel_ex
set data_retention_time_in_days = 7;


-- qywering history data 
-- updating some data first 
-- case 1 : retrieve history data by using AT OFFSET
select * from  SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer At (offset => -60*2)
where c_custkey = 60001;



-- Tiime Travel Cost 
select * from snowflake.ACCOUNT_USAGE.table_storage_metrics;

select * from snowflake.ACCOUNT_USAGE.table_storage_metrics
where table_name = 'snowflake_db.public.vendors';

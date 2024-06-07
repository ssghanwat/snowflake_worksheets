/*
create masking policy employee_mask as (val string) returns string ->
    case when current_role() in ('payroll') then val else '******' end;
*/

use snowflake_db;

-- create schema for policies
create or replace schema mypolicies;

-- try to clone for sample data we cant clone data from shared database
create table public.customer
clone snowflake_sample_data.tpch_sf1.customer;

-- create a sample data
create table public.customer
as select * from  snowflake_sample_data.tpch_sf1.customer;

-- view data
select * from public.customer;
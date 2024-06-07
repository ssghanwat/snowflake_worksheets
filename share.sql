create database share_db;

use share_db;

create or replace schema cust_tables;
create or replace schema cust_views;

-- create some tables in cust_tables schema
create table share_db.cust_tables.customer as
select * from snowflake_sample_data.tpch_sf1.customer;

create table share_db.cust_tables.orders as
select * from snowflake_sample_data.tpch_sf1.orders;

-- create view in views schema 
create or replace view cust_views.vw_customer
as 
    select cst.c_custkey, cst.c_name,cst.c_address, cst.c_phone
    from snowflake_sample_data.tpch_sf10.customer cst
    inner join snowflake_sample_data.tpch_sf10.nation ntn
    on cst.c_nationkey = ntn.n_nationkey
    where ntn.n_name = 'BRAZIL';

select * from cust_views.vw_customer;


-- create a secure view
create or replace secure view cust_views.sec_vw_customer
as
    select cst.c_custkey, cst.c_name, cst.c_address, cst.c_phone from
    cust_tables.customer cst;

-- create materialized view
create or replace materialized view cust_views.mat_vw_orders
as 
select * from cust_tables.customer;

select * from cust_views.mat_vw_orders;
select * from cust_views.sec_vw_customer;


-- create secured materialized view
create or replace secure materialized view cust_views.sec_mat_vw_orders
as
select * from cust_tables.customer;


-- create a share object 
-- we can create and manage share objects in two ways 
-- 1.By using sql queries 
-- 2.By using share tabs in UI

create or replace share cust_data_share;

-- grant access to share object
grant usage on database share_db to share cust_data_share;

grant usage on schema share_db.cust_tables to share cust_data_share;
grant select on table share_db.cust_tables.customer to share cust_data_share;
grant select on table share_db.cust_tables.orders to share cust_data_share;

grant usage on schema share_db.cust_views to share cust_data_share;
grant select on view share_db.cust_views.vw_customer to share cust_data_share;
grant select on view share_db.cust_views.sec_vw_customer to share cust_data_share;
grant select on view share_db.cust_views.mat_vw_orders to share cust_data_share;
grant select on view share_db.cust_views.sec_mat_vw_orders to share cust_data_share;


-- how to see share objects
show shares;

-- to see grants on share objects
show grants to share cust_data_share;

-- add consumer account to share the data 
alter share cust_data_share add account = KC15227;

-- how to share complete schema
grant select on all tables in schema share_db.cust_tables to share cust_data_share;

-- how to share complete database 
grant select on all tables in database share_db to share cust_data_share;


-- ========================
-- consumer side setup
-- ========================

show shares;

-- desc share <share_name>

-- create database to consume share data
create database if not exists cust_db_shared from share <share-name>;

select * from cust_db_shared.cust_tables.customer;

-- =====================================================================================
-- data sharing to non-snowflake users
--======================================================================================
-- create reader account
create managed account customer_analyst
admin_name = cust_analyst,
admin_password = 'Abcd@123'
type = reader;

-- how to see reader accounts
show managed accounts;

-- https://welmhpr-customer_analyst.snowflakecomputing.com/console/login#/
-- add reader account to share object 
alter share cust_data_share add account = TI38843;

alter share cust_data_share add account = TI38843
    share_restrictions = false;

-- =================================================================================================
-- reader side database setup
-- ===================================================================================================
show shares;

desc share share_name;

-- create database to consume share data
create database cust_db_shared from  share share_name;

-- query the share database 
select * from .......;

-- create virtual warehouse 
create warehouse if not exists
    warehouse_size = 'X-SMALL'
    auto_suspend = 180
    auto_resume = TRUE;

-- after creating warehouse we can query the database and get data from tables


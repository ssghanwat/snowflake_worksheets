-- create secure view syntax
-- create or replace secure view view_name as select statement

-- how to determine view is a secure view or not 
/*
SELECT table_catlog , table_schema, table_name, is_secure
    from snowflake_db.schema.views
    where table_name = 'view_name';
*/

-- create materialized view syntax
-- create or replace materialized view view_name as select statement

-- when to create materialized view
-- 1.The query results from th view dont change often
-- 2.the results of the view are often used
-- 3.The query consumes  a lot of resources means query takes longer time for proccessing like aggregating data

-- When to use regular view
-- 1.The results of the view often change
-- 2.The results of view are not often used
-- 3.The query is simple
-- 4.The view contains mutiple tables

-- Advanatages of materialized view
--1. Improves the performance 
-- 2.No need of extra maintenance
-- 3.Data  accessed  through materialized view is always current, regardless of amount of the DML has been performed on the base table


-- Limitations of materialized views
-- 1. can query only one table
-- 2.Does not support joins, including self joins
-- 3.Does not support all aggregatee and windowing function
-- 4.When the base table is altered or dropped , the materialized view is suspended
-- 5.materialized view cannot query
    --Another materialized view
    --A normal view
    --a UDF(user defined function)


use public_db;

-- ceate schema for views
create schema if not exists myviews;

-- create  customer view
create or replace view myviews.vw_customer
as
    select cst.c_custkey, 
                cst.c_name,
                cst.c_address,
                cst.c_phone,
    from snowflake_sample_data.tpch_sf100.customer cst
    inner join snowflake_sample_data.tpch_sf100.nation ntn
    on cst.c_nationkey = ntn.n_nationkey
    where ntn.n_name = 'BRAZIL';

select * from myviews.vw_customer;

-- turn off used cache and suspend
alter session set use_cached_result = False;

select * from myviews.vw_customer;
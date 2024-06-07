use snowflake_sample_data;

-- run with XSMALL or small warehouse
-- run below queries to observe query profile

-- query is fetching results from storage layer (remote Disk)
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;       --1m56s


-- fetching METADATA info  is very fast look at query profile 
select count(*) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;   --39ms
select min(c_custkey) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;  --50ms
select max(c_custkey) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;  --54ms


-- run the same query and observe query  performance
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;    --65ms 


-- try to fetch same data by changing queries little bit and observe query profile 
select c_custkey, c_name, c_acctbal, c_address from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer; 
select c_custkey, c_address from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer; 
select c_address, c_custkey from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer; 


-- select subset of data with filter
select c_custkey, c_name, c_acctbal, c_address from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer
where c_nationkey in (1,2);


-- turn off results cache, suspend the virtual warehouse run same queries and see query profile 
alter session set use_cached_result = false;

-- ===============================================================================
-- rerun the all above query after turning off cache and suspending the warehouse
-- ===============================================================================

-- query is fetching results from storage layer (remote Disk)
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;       --1m56s


-- fetching METADATA info  is very fast look at query profile 
select count(*) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;   --39ms
select min(c_custkey) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;  --50ms
select max(c_custkey) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;  --54ms


-- run the same query and observe query  performance
select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer;    --65ms 


-- try to fetch same data by changing queries little bit and observe query profile 
select c_custkey, c_name, c_acctbal, c_address from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer; 
select c_custkey, c_address from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer; 
select c_address, c_custkey from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer; 


-- select subset of data with filter
select c_custkey, c_name, c_acctbal, c_address from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.customer
where c_nationkey in (1,2);
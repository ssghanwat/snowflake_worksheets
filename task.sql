----------------------
-- creating task
---------------------
use database snowflake_db;

create schema mytasks;

-- create sample table for inserting data  using task
create table snowflake_db.public.track_load_time
(
    id int autoincrement start = 1 increment = 1,
    name varchar(50) default 'sandeep',
    load_time timestamp
);


-- create as task to insert data every minute 
create or replace task mytasks.task_track_time
    warehouse = compute_wh
    schedule = '1 minute'
as
    insert into snowflake_db.public.track_load_time(load_time)
        values(current_timestamp);

select * from snowflake_db.public.track_load_time;

-- list tasks
show tasks;

desc task mytasks.task_track_time;

-- starting and suspending tasks
alter task mytasks.task_track_time resume;
-- alter task mytasks.task_track_time suspend;

-- now query 
select * from snowflake_db.public.track_load_time;


-- using cron command to load data everry minute
create or replace task mytasks.track_load_time2
    warehouse = compute_wh
    schedule = 'using cron * * * * * utc'
    as
        insert into snowflake_db.public.track_load_time(name , load_time)
            values("ghanwat", current_timestamp);

alter task  mytasks.track_load_time2 resume;

-- view the data
select * from snowflake_db.public.track_load_time
order by id asc;

--some examples of scheduling by chron

-- every day at 7 am 
schedule = 'using cron 0 7 * * * utc ';

-- every day at 7 am  and 7 pm
schedule = 'using cron 0 7 7 * * * utc ';

-- every month last day at 7 am
schedule = 'using cron 0 7 l * * utc';

-- every monday ate 6.30 am
schedule = 'using cron 30 6 * * 1 utc';

-- first day of month only from january to march
schedule = 'using cron 0 0 1 1-3 * utc';

-- creating DAG of tasks

create or replace table snowflake_db.public.cust_admin
(custid int autoincrement start = 1 increment = 1,
custname string default  'sandeep',
dept_name string default 'sales',
load_time timestamp);

-- root task
create or replace task mytasks.task_cust_admin
    warehouse = compute_wh
    schedule = 'using cron * * * * * utc'
as
    insert into snowflake_db.public.cust_admin(load_time)
        values(current_timestamp);

select * from snowflake_db.public.cust_admin;

-- create task for sales
create or replace task mytasks.task_cust_sales
AFTER MYTASKS.TASK_CUST_ADMIN
as 
create or replace table snowflake_db.public.cust_sales as
select * from snowflake_db.public.cust_admin
where dept_name = 'sales';


-- create task for hr department  --not mentioning warehouse it will use snowflake compute resources
create or replace task mytasks.task_cust_hr
    after mytasks.task_cust_admin
as
    create or replace table snowflake_db.public.cust_hr
    as
        select * from snowflake_db.public.cust_admin
            where dept_name = 'hr';

-- create task fro marketing same without compute resources
create or replace task mytasks.task_cust_marketing
as
    create or replace table snowflake_db.public.cust_marketing
        as
            select * from snowflake_db.public.cust_admin
            where dept_name = 'marketing';

-- add dependencies 
alter task mytasks.task_cust_marketing add after mytasks.task_cust_sales;
alter task mytasks.task_cust_marketing add after mytasks.task_cust_hr;

show tasks;


-- start tasks --child first then parent
alter task mytasks.task_cust_marketing resume;
alter task mytasks.task_cust_sales resume;
alter task mytasks.task_cust_hr resume;
alter task mytasks.task_cust_admin resume;

show tasks;

-- view data 
select * from snowflake_db.public.cust_admin;
select * from snowflake_db.public.cust_sales;
select * from snowflake_db.public.cust_hr;
select * from snowflake_db.public.cust_marketing;

alter task mytasks.task_cust_admin suspend;
alter task mytasks.task_cust_admin resume;

-- alter the root tasks
alter task mytasks.task_cust_admin
modify
as 
insert into snowflake_db.public.cust_admin(custname,dept_name, load_time)
values('naru','marketing', current_timestamp);


-- view data 
select * from snowflake_db.public.cust_admin;
select * from snowflake_db.public.cust_sales;
select * from snowflake_db.public.cust_hr;
select * from snowflake_db.public.cust_marketing;


-- to check task history
select * from table (information_schema.task_history())
order by scheduled_time desc;

-- to see rsults of specific task in last 6 hours
select * from table (information_schema.task_history(
scheduled_time_range_start => dateadd('hour', -6, current_timestamp()),
result_limit => 10,
task_name => 'task_track_time'));

alter task mytasks.task_track_time suspend;
alter task mytasks.track_load_time2 suspend;

s a n d e e p  
 
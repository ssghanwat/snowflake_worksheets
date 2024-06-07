-- user 1 : Account Admins
create or replace user Donald PASSWORD = 'abc123'
DEFAULT_ROLE =  ACCOUNTADMIN
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE ACCOUNTADMIN TO USER DONALD;


drop  user Charles;

-- user 2 : Security admin 
create or replace  user Charles PASSWORD = 'abc123'
DEFAULT_ROLE = securityadmin
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE SECURITYADMIN TO USER CHARLES;


-- user 3 : sysadmin
create or replace user janet password = 'abc123'
DEFAULT_ROLE = SYSADMIN
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE SYSADMIN TO USER JANET;



-- login as charles who is security admin

-- create sales roles and users for SALES
create role sales_admin;
create role sales_users;
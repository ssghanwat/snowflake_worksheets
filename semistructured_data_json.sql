create database if not exists  snowflake_db;

list @snowflake_db.external_stages.stg_azure_cont;

-- drop stage snowflake_db.extn_stages.stage_json;
-- create required schemas
create or replace schema snowflake_db.extn_stages;
create or replace schema snowflake_db.stage_tbls;
create or replace schema snowflake_db.intg_tbls;


-- create file formats
create or replace file format snowflake_db.extn_stages.file_format_json
    type = json;


-- create stage object 
create or replace stage snowflake_db.extn_stages.stage_json
    url = 'azure://snowflakegen2.blob.core.windows.net/snowflakeazurefiles'
    STORAGE_INTEGRATION = snow_azure_int;

-- list files in stage
list @snowflake_db.extn_stages.stage_json;


-- create stage table to store raw data
create or replace table snowflake_db.stage_tbls.pets_data_json_raw
    (raw_file variant);


-- copy raw data into stage table
copy into snowflake_db.stage_tbls.pets_data_json_raw
    from @snowflake_db.extn_stages.stage_json
    file_format = snowflake_db.extn_stages.file_format_json
    files = ('pets1.json');

select * from snowflake_db.stage_tbls.pets_data_json_raw;


-- selecting single column from raw_file column
select raw_file:Name::string as Name from snowflake_db.stage_tbls.pets_data_json_raw;


-- extracting array type column
select raw_file:Name::string as Name ,
    raw_file:Pets[0]::string as Pet
    from snowflake_db.stage_tbls.pets_data_json_raw;

-- get size of array
select max(array_size(raw_file:Pets)) as pets_array_size
    from snowflake_db.stage_tbls.pets_data_json_raw;


select raw_file:Name::string as Name ,
    raw_file:Pets[0]::string as Pet
    from snowflake_db.stage_tbls.pets_data_json_raw
union all
select raw_file:Name::string as Name ,
    raw_file:Pets[1]::string as Pet
    from snowflake_db.stage_tbls.pets_data_json_raw
union all
select raw_file:Name::string as Name ,
    raw_file:Pets[2]::string as Pet
    from snowflake_db.stage_tbls.pets_data_json_raw
    where PET is not null;


-- extracting data from nested json
select raw_file:Name::string as Name,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State
        from snowflake_db.stage_tbls.pets_data_json_raw;


-- parsing entire json
select raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       raw_file:Pets[0]::string as Pets,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
            from snowflake_db.stage_tbls.pets_data_json_raw
union all
select raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       raw_file:Pets[1]::string as Pets,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
            from snowflake_db.stage_tbls.pets_data_json_raw
union all
select raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       raw_file:Pets[2]::string as Pets,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
            from snowflake_db.stage_tbls.pets_data_json_raw;


-- createing or loading data into a other table
create or replace table snowflake_db.intg_tbls.pets_data
as 
select raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       raw_file:Pets[0]::string as Pets,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
            from snowflake_db.stage_tbls.pets_data_json_raw
union all
select raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       raw_file:Pets[1]::string as Pets,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
            from snowflake_db.stage_tbls.pets_data_json_raw
union all
select raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       raw_file:Pets[2]::string as Pets,
    raw_file:Address."House Number"::string as house_number,
    raw_file:Address.City::string as City,
    raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
            from snowflake_db.stage_tbls.pets_data_json_raw;


select * from snowflake_db.intg_tbls.pets_data;

-- truncate and reload using flatten 

truncate table snowflake_db.intg_tbls.pets_data;

INSERT INTO snowflake_db.INTG_TBLS.PETS_DATA
select  
       raw_file:Name::string as Name,
       raw_file:Gender::string as Gender,
       raw_file:DOB::date as DOB,
       f1.value::string as Pet,
       raw_file:Address."House Number"::string as House_No,
        raw_file:Address.City::string as City,
        raw_file:Address.State::string as State,
        raw_file:Phone.Work::number as Work_Phone,
        raw_file:Phone.Mobile::number as Mobile_Phone
FROM snowflake_db.STAGE_TBLS.PETS_DATA_JSON_RAW, 
table(flatten(raw_file:Pets)) f1;


-- validate data 
select * from snowflake_db.intg_tbls.pets_data;

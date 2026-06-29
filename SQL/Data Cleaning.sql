create database Sales_Analytics;
use Sales_Analytics;
describe superstore;
select count(*) from superstore;


/* ===========================
   DATA CLEANING
=========================== */

# first let create a copy of the dataset to prevent any data loss or data misinterpretation
create table superstore_staging like superstore;
describe superstore_staging;
insert superstore_staging
select * from superstore;
select * from superstore_staging limit 5;
## Renaming columns to follow a consistent naming convention.
alter table superstore_staging
change column  `ROW ID` `Row_Id` int,#converting to int from big int to reduce space 
change column  `Order ID` `Order_Id` text,
change column `Order Date` `Order_Date`  text,
change column `Ship date` `Ship_Date`  text,
change column `Ship Mode` `Ship_Mode` text,
change column `Customer ID` `Customer_Id` text,
change column `Customer Name` `Customer_Name` text,
change column `Postal Code` `Postal_Code` int,
change column `Product ID` `Product_Id` text,
change column `Sub-Category` `Sub_Category` text,
change column `Product Name` `Product_Name` text,
change column  `Quantity` `Quantity` int;

## Converting date columns from text to DATE datatype.
UPDATE superstore_staging
SET
    Order_date = STR_TO_DATE(Order_date, '%m/%d/%Y'),
    Ship_date = STR_TO_DATE(Ship_date, '%m/%d/%Y');
    
ALTER TABLE superstore_staging
MODIFY COLUMN Order_date DATE,
MODIFY COLUMN Ship_date DATE;

select * from superstore_staging limit 5;
select count(*) from superstore;

select count(*) from superstore_staging;
## Checking null values present in the data
-- (here we are checking on all columns so that we can either fill that with a value if we are able to find a value using table 
-- or drop the row if most important value like order_id , product_id, product_name and many more are missing)
select
sum(case when row_id is null then 1 else 0 end) as row_id_issues,
sum(case when order_id is null or trim(order_id)='' or lower(trim(order_id))='na' or lower(trim(order_id))='n/a' then 1 else 0 end) as order_id_issues,
sum(case when order_date is null then 1 else 0 end) as order_date_issues,
sum(case when ship_date is null then 1 else 0 end) as ship_date_issues,
sum(case when ship_mode is null or trim(ship_mode)='' or lower(trim(ship_mode))='na' or lower(trim(ship_mode))='n/a' then 1 else 0 end) as ship_mode_issues,
sum(case when customer_id is null or trim(customer_id)='' or lower(trim(customer_id))='na' or lower(trim(customer_id))='n/a' then 1 else 0 end) as customer_id_issues,
sum(case when customer_name is null or trim(customer_name)='' or lower(trim(customer_name))='na' or lower(trim(customer_name))='n/a' then 1 else 0 end) as customer_name_issues,
sum(case when segment is null or trim(segment)='' or lower(trim(segment))='na' or lower(trim(segment))='n/a' then 1 else 0 end) as segment_issues,
sum(case when country is null or trim(country)='' or lower(trim(country))='na' or lower(trim(country))='n/a' then 1 else 0 end) as country_issues,
sum(case when city is null or trim(city)='' or lower(trim(city))='na' or lower(trim(city))='n/a' then 1 else 0 end) as city_issues,
sum(case when state is null or trim(state)='' or lower(trim(state))='na' or lower(trim(state))='n/a' then 1 else 0 end) as state_issues,
sum(case when postal_code is null then 1 else 0 end) as postal_code_issues,
sum(case when region is null or trim(region)='' or lower(trim(region))='na' or lower(trim(region))='n/a' then 1 else 0 end) as region_issues,
sum(case when product_id is null or trim(product_id)='' or lower(trim(product_id))='na' or lower(trim(product_id))='n/a' then 1 else 0 end) as product_id_issues,
sum(case when category is null or trim(category)='' or lower(trim(category))='na' or lower(trim(category))='n/a' then 1 else 0 end) as category_issues,
sum(case when sub_category is null or trim(sub_category)='' or lower(trim(sub_category))='na' or lower(trim(sub_category))='n/a' then 1 else 0 end) as sub_category_issues,
sum(case when product_name is null or trim(product_name)='' or lower(trim(product_name))='na' or lower(trim(product_name))='n/a' then 1 else 0 end) as product_name_issues,
sum(case when sales is null then 1 else 0 end) as sales_issues,
sum(case when quantity is null then 1 else 0 end) as quantity_issues,
sum(case when discount is null then 1 else 0 end) as discount_issues,
sum(case when profit is null then 1 else 0 end) as profit_issues
from superstore_staging;
## checking for same word different spelling where possible or important
 
select distinct Segment
from superstore_staging;

select distinct country
from superstore_staging;

select distinct state
from superstore_staging;

select distinct Sub_Category
from superstore_staging;

## checking for duplicates

SELECT
    Order_Id, Order_date,Ship_date,Ship_Mode,Customer_Id,Customer_Name,Segment,Country,City,State,Postal_Code,
    Region,Product_Id,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit,COUNT(*) AS duplicate_count
FROM superstore_staging
GROUP BY
    Order_Id,Order_date,Ship_date,Ship_Mode,Customer_Id,Customer_Name,Segment,Country,City,State,Postal_Code,Region,
    Product_Id,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit
HAVING COUNT(*) > 1;
## there is a duplicate

WITH Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Order_Id,Order_date,Ship_date,Ship_Mode,Customer_Id,Customer_Name,Segment,Country,City,State,Postal_Code,Region,
				Product_Id,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit
               ORDER BY Row_Id
           ) AS rn
    FROM superstore_staging
)
select * from duplicates where rn>1; ## row 3407 have rn as 2 lets cross check them
WITH Duplicates_rows AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Order_Id,Order_date,Ship_date,Ship_Mode,Customer_Id,Customer_Name,Segment,Country,City,State,Postal_Code,Region,
				Product_Id,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit
               ORDER BY Row_Id
           ) AS rn
    FROM superstore_staging
)
select * from duplicates_rows
where Order_Id=(select order_id from superstore_staging where row_id=3407) and product_id=(select product_id from superstore_staging where row_id=3407); 
# row 3407 is duplicate of row 3406 let's remove 3407

delete from superstore_staging where row_id=3407;
# verfying the deletion
select * from superstore_staging where row_id=3407;

## Duplicates are removed
select
order_id,order_date,ship_date,ship_mode,customer_id,customer_name,segment,country,city,
state,postal_code,region,product_id,category,sub_category,product_name,sales,quantity,discount,profit,
count(*) as duplicate_count
from superstore_staging
group by
order_id,order_date,ship_date,ship_mode,customer_id,customer_name,segment,country,city,state,
postal_code,region,product_id,category,sub_category,product_name,sales,quantity,discount,profit
having count(*)>1;
## checking about the trailing space
SELECT *
FROM superstore_staging
WHERE Customer_Name <> TRIM(Customer_Name);

select *
from superstore_staging
where ship_mode <> trim(ship_mode)
   or customer_id <> trim(customer_id)
   or customer_name <> trim(customer_name)
   or segment <> trim(segment)
   or country <> trim(country)
   or city <> trim(city)
   or state <> trim(state)
   or region <> trim(region)
   or category <> trim(category)
   or sub_category <> trim(sub_category)
   or product_id <> trim(product_id)
   or product_name <> trim(product_name);
# some rows have trailing space let's find which one is doing problems
select
sum(ship_mode <> trim(ship_mode)) as ship_mode_spaces,
sum(customer_id <> trim(customer_id)) as customer_id_spaces,
sum(customer_name <> trim(customer_name)) as customer_name_spaces,
sum(segment <> trim(segment)) as segment_spaces,
sum(country <> trim(country)) as country_spaces,
sum(city <> trim(city)) as city_spaces,
sum(state <> trim(state)) as state_spaces,
sum(region <> trim(region)) as region_spaces,
sum(category <> trim(category)) as category_spaces,
sum(sub_category <> trim(sub_category)) as sub_category_spaces,
sum(product_id <> trim(product_id)) as product_id_spaces,
sum(product_name <> trim(product_name)) as product_name_spaces
from superstore_staging; ## product name have spacing


select
concat('|', product_name, '|') as original,
concat('|', trim(product_name), '|') as trimmed
from superstore_staging
where product_name <> trim(product_name); ## trailing space does exist

update superstore_staging
set product_name = trim(product_name);

select *
from superstore_staging
where product_name <> trim(product_name);

## validating business rules and numerical constraints

select * 
from superstore_staging 
where order_date>ship_date; 

select * from superstore_staging 
where sales<0;

select * from superstore_staging
where quantity<=0;

select * from superstore_staging
where discount<0 or discount>1;

select row_id, count(*)
from superstore_staging
group by row_id
having count(*)>1;

select product_id,
count(distinct product_name)
from superstore_staging
group by product_id
having count(distinct product_name)>1; 
## some product id have multiple name  so let's check they are exact same or they are selling these in different name in different region

select product_id, product_name
from superstore_staging
where product_id = 'FUR-BO-10002213';

select count(*) as total_data_quality_issue
from (
    select product_id
    from superstore_staging
    group by product_id
    having count(distinct product_name) > 1
) as t;  ## in entire 1862 productid there are only 32 productid which have multiple productname it is due to data inconsistency

select
customer_id,
count(distinct customer_name) as customer_names
from superstore_staging
group by customer_id
having count(distinct customer_name) > 1;
select
customer_name,
count(distinct customer_id)
from superstore_staging
group by customer_name
having count(distinct customer_id)>1;
 
select * from superstore_staging
where postal_code<=0;

select count(*) as final_rows
from superstore_staging;
-- Data Validation:
-- Found some product_ids mapped to multiple product_names.
-- Since the source dataset does not provide the correct mapping,
-- these records were retained to preserve data integrity.





   
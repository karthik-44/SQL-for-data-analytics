# SQL-for-data-analytics

Practice SQL using the text book SQL for data analytics.
# Chapter 02  
select * from salespeople;


 ### Lesson 2 
 ### Excercise 06 
**The sales manager would like a couple of different lists of salespeople. 
First, create a list of the online usernames of the first 10 female salespeople hired, 
ordered from the first hired to the latest hired.
**
select username from salespeople
where gender='Female'
order by hire_date asc
limit 10;

 ## Activity 03 
**
Open your favorite SQL client and connect to the sqlda database. Examine the schema for the customers table
from the schema dropdown.**
select * from customers;

**Write a query that pulls all emails for ZoomZoom customers in the state of Florida in alphabetical order.**
select email from customers
where state='FL'
order by email;

**Write a query that pulls all the first names, last names and email 
details for ZoomZoom customers in New York City in the state of New York. 
They should be ordered alphabetically by the last name followed by the first name.**
select first_name, last_name, email from customers
where (state='NY' and city='New York City')
order by last_name,first_name;


**Write a query that returns all customers with a phone number
ordered by the date the customer was added to the database.**
select first_name, last_name, phone from customers
where phone is not null
order by date_added asc;

 ### Excercise 07 
**The marketing team at ZoomZoom would like to create a table called countries 
to analyze the data of different countries. It should have four columns: an integer key column, 
a unique name column, a founding year column, and a capital column.
**
create table countries(
	key int primary key,
	name text unique ,
	founding_year int,
	capital text
);
select * from countries;

 ### Excercise 08 
**Due to the higher cost of rare metals needed to manufacture an electric vehicle,
the new 2019 Model Chi will need to undergo a price hike of 10%. 
Update the products table to increase the price of this product.**

 select * from products;

update products
set base_msrp = (base_msrp + 0.10*base_msrp)
where (model = 'Model Chi' and year = 2019);


 ### Excercise 09 
 no longer need the state_populations table.
create table state_populations(
    state varchar(2) primary key,
	population numeric
)

select * from state_populations;

drop table state_populations;

 ## Activity 04  

**Create a new table called customers_nyc that pulls all rows 
from the customers table where the customer lives in New York City in the state of New York.**
create table customers_nyc as(
    select * from customers
	where (city = 'New York City' and state = 'NY')
)

**Delete from the new table all customers in postal code 10014. 
Due to local laws, they will not be eligible for marketing.**
 select * from customers_nyc;
delete from customers_nyc
where postal_code = '10014';

**Add a new text column called event.
Set the value of the event to thank-you party.**
alter table customers_nyc
add column event text;

update customers_nyc
set event = 'thank-you party'

**You've told the manager that you've completed these steps. 
He tells the marketing operations team, who then uses the data to launch a marketing campaign. 
The marketing manager thanks you and then asks you to delete the customers_nyc table.**
drop table customers_nyc;

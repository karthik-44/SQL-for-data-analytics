# SQL-for-data-analytics

Practice SQL using the text book SQL for data analytics.
# Chapter 02  
```sql
select * from salespeople;
```
 ### Lesson 2 
 ### Excercise 06  
**The sales manager would like a couple of different lists of salespeople. 
First, create a list of the online usernames of the first 10 female salespeople hired, 
ordered from the first hired to the latest hired.**

```sql
select username from salespeople
where gender='Female'
order by hire_date asc
limit 10;
```
 ## Activity 03 
**Open your favorite SQL client and connect to the sqlda database. Examine the schema for the customers table
from the schema dropdown.**
```sql
select * from customers;
```

**Write a query that pulls all emails for ZoomZoom customers in the state of Florida in alphabetical order.**
```sql
select email from customers
where state='FL'
order by email;
```

**Write a query that pulls all the first names, last names and email 
details for ZoomZoom customers in New York City in the state of New York. 
They should be ordered alphabetically by the last name followed by the first name.**
```sql
select first_name, last_name, email from customers
where (state='NY' and city='New York City')
order by last_name,first_name;
```

**Write a query that returns all customers with a phone number
ordered by the date the customer was added to the database.**
```sql
select first_name, last_name, phone from customers
where phone is not null
order by date_added asc;
```

 ### Excercise 07 
**The marketing team at ZoomZoom would like to create a table called countries 
to analyze the data of different countries. It should have four columns: an integer key column, 
a unique name column, a founding year column, and a capital column.**
```sql
create table countries(
	key int primary key,
	name text unique ,
	founding_year int,
	capital text
);
select * from countries;
```

 ### Excercise 08 
**Due to the higher cost of rare metals needed to manufacture an electric vehicle,
the new 2019 Model Chi will need to undergo a price hike of 10%. 
Update the products table to increase the price of this product.**

```sql
select * from products;

update products
set base_msrp = (base_msrp + 0.10*base_msrp)
where (model = 'Model Chi' and year = 2019);

```
 ### Excercise 09 
 no longer need the state_populations table.

```sql
create table state_populations(
    state varchar(2) primary key,
	population numeric
)

select * from state_populations;

drop table state_populations;

```
 ## Activity 04  

**Create a new table called customers_nyc that pulls all rows 
from the customers table where the customer lives in New York City in the state of New York.**

```sql
create table customers_nyc as(
    select * from customers
	where (city = 'New York City' and state = 'NY')
)
```
**Delete from the new table all customers in postal code 10014. 
Due to local laws, they will not be eligible for marketing.**
```sql
select * from customers_nyc;
delete from customers_nyc
where postal_code = '10014';
```
**Add a new text column called event.
Set the value of the event to thank-you party.**

```sql
alter table customers_nyc
add column event text;

update customers_nyc
set event = 'thank-you party'
```
**You've told the manager that you've completed these steps. 
He tells the marketing operations team, who then uses the data to launch a marketing campaign. 
The marketing manager thanks you and then asks you to delete the customers_nyc table.**
```sql
drop table customers_nyc;
```

# Chapter 03  
### Excercise 10 
**list of all customers who bought a car.
all customer IDs, first names, last names, and valid phone numbers of customers who purchased a car.**
```sql
select c.customer_id, c.first_name, c.last_name, c.phone
from customers as c inner join sales as s
on c.customer_id = s.customer_id
inner join products as p
on s.product_id = p.product_id
where p.product_type = 'automobile' and c.phone is not null
```
 ### Excercise 11 

**The marketing team would like to throw a party for some of ZoomZoom's wealthiest customers 
in Los Angeles, CA. To help facilitate the party, they would like you to make a guest list 
with ZoomZoom customers who live in Los Angeles, CA, 
as well as salespeople who work at the ZoomZoom dealership in Los Angeles, CA. 
The guest list should include the first name, the last name, and whether the guest is a customer or an employee.**

```sql
(select c.first_name, c.last_name, 'customer' as guest
from customers c
where state = 'CA' and city = 'Los Angeles')
union
(
select s.first_name, s.last_name, 'employee' as guest
from salespeople s inner join dealerships d
on s.dealership_id = d.dealership_id
where state = 'CA' and city = 'Los Angeles')
```

 ### Excercise 12 
**The head of sales has an idea to try and create specialized regional sales teams 
that will be able to sell scooters to customers in specific regions, as opposed 
to generic sales teams. To make his idea a reality, he would like a list of all 
customers mapped to regions. For customers from the states of MA, NH, VT, ME CT, or RI, 
he would like them labeled as New England. 
For customers from the states of GA, FL, MS, AL, LA, KY, VA, NC, SC, TN, VI, WV, or AR, 
he would like the customers labeled as Southeast. 
Customers from any other state should be labeled as Other:**

```sql
select c.customer_id, case 
						when c.state in ('MA', 'NH', 'VT', 'ME', 'CT', 'RI') then 'New England'
						when c.state in ('GA', 'FL', 'MS', 'AL', 'LA', 'KY', 'VA', 'NC', 'SC', 'TN', 'VI', 'WV', 'AR') then 'Southeast'
						else 'Other'
					  end as region
from customers as c
order by 1;
```

 ## Activity 05  

**The data science team wants to build a new model to help predict which customers are the best prospects for remarketing.**

```sql
select c.*, p.*, coalesce(s.dealership_id, -1), 
case 
	when p.base_msrp - s.sales_amount < 500 then 1
	else 0 
end as high_savings
from customers c inner join sales s
on c.customer_id = s.customer_id
inner join products p
on p.product_id = s.product_id
LEFT JOIN dealerships d ON s.dealership_id = d.dealership_id;
```

# Chapter 04  
### Excercise 13 
**You now want to calculate the lowest price, the highest price, 
the average price, and the standard deviation of the price for all the products the company has ever sold.**
```sql
select min(base_msrp), max(base_msrp), avg(base_msrp), stddev(base_msrp)
from products;
```
 ### Excercise 14 
**The marketing manager wants to know the minimum, maximum, average, and standard deviation of the price for each product type that ZoomZoom sells, for a marketing campaign.**
```sql
select product_type, min(base_msrp), max(base_msrp), avg(base_msrp), stddev(base_msrp)
from products
group by product_type
order by 1;
```
 ### Excercise 15 
**The sales manager of ZoomZoom wants to know the customer count for 
the states that have at least 1,000 customers who have purchased any product from ZoomZoom.**
```sql
select state, count(*)
from customers
group by state
having count(*) > 1000
order by state;
```
 ## Activity 06 
**The CEO, COO, and CFO of ZoomZoom would like to gain some insights on what might be driving sales.**
 
 
**Calculate the total number of unit sales the company has done.**
```sql
select count(*) from sales;
```

**Calculate the total sales amount in dollars for each state.**
```sql
select c.state, sum(sales_amount) 
from sales s inner join customers c
on s.customer_id = c.customer_id
group by state
order by state;
```
**Identify the top five best dealerships in terms of the most units sold (ignore internet sales).**

```sql
select dealership_id, count(*)
from sales
where channel='dealership'
group by dealership_id
order by count(*) desc
limit 5;
```
**Calculate the average sales amount for each channel, as seen in the sales table, 
and look at the average sales amount first by channel sales, then by product_id, and then by both together.**
```sql
select channel, product_id, avg(sales_amount)
from sales
group by grouping sets(
	(channel),
	(product_id),
	(channel, product_id)

)
order by 1,2;
```
# Chapter 05  

  

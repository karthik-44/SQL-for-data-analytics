# SQL-for-data-analytics

Practice SQL using the text book SQL for data analytics. There are several excercises, activities along the chapters of the textbook.  
Install the postgres database software, pgadmin software on your local machine. Once installed, configure the schemas and users as needed and follow the text book to get some handson practice on SQL. One get exposure from a range of SQL commands from basic DML/CRUD statements to advanced window functions and many more.  

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
 ### Excercise 16  
**The company would like a running total of how many users have filled in their street address over time. Write a query to produce these results.**
```sql
select customer_id, street_address, date_added::DATE,
count(case
	  	when street_address is not null then customer_id
	    else null
	  end) over ( order by  date_added::DATE) as total_customers_filled_address
from customers
order by date_added;
```
 ### Excercise 17  

**ZoomZoom would like to promote salespeople at their regional dealerships to management 
 and would like to consider tenure in their decision. 
 Write a query that will rank the order of users according to their hire date for each dealership:**
```sql
select dealership_id, salesperson_id, first_name, last_name, hire_date, RANK() over (partition by dealership_id order by hire_date)
from salespeople
where termination_date is null;
```


 **EXTRA ROLLING AVERAGE** 
```sql
select * from sales;

with 
daily_sales as (
	select sales_transaction_date::DATE, sum(sales_amount) as total_sales
	from sales
	group by sales_transaction_date
	order by sales_transaction_date
),

moving_average_calculation_7 as (
	select sales_transaction_date::DATE, total_sales, 
	avg(total_sales) over (order by sales_transaction_date rows between 7 preceding and current row) as sma_7,
	row_number() over (order by sales_transaction_date) as row_number
	from daily_sales 
	order by 1
)

SELECT sales_transaction_date, CASE 
								 WHEN row_number>=7 THEN sma_7 
								 ELSE NULL 
							   END AS sma_7

FROM moving_average_calculation_7;
```

 ### Excercise 18  

 **Write a query that produces the total sales in dollars for a given day 
 and the target the salespeople have to beat for that day, starting from January 1, 2019:**
```sql
with 
daily_sales as (
	select sales_transaction_date::DATE, sum(sales_amount) as total_daily_sales
	from sales
	group by 1
	order by 1
)
,
target_30 as (
	select sales_transaction_date, total_daily_sales,
	max(total_daily_sales) over (order by sales_transaction_date rows between 30 preceding and 1 preceding) as target
	from daily_sales
	order by 1
)

select sales_transaction_date, total_daily_sales, target
from target_30
where sales_transaction_date::DATE > '2018-12-31';
```

 ## Activity 07  
 **Sales team want to see how the company has performed overall, as well as how individual dealerships have performed within the company.
Calculate the total sales amount by day for all of the days in the year 2018 (that is, before the date January 1, 2019).**
```sql
select sales_transaction_date::DATE, sum(sales_amount) as total_daily_sales
from sales
where sales_transaction_date >= '2018-01-01' and sales_transaction_date < '2019-01-01'
group by 1
order by 1
```

 **Calculate the rolling 30-day average for the daily number of sales deals.**
```sql
with 
daily_deals as(
	select sales_transaction_date::DATE, count(*) as daily_num_sales
	from sales
	group by 1
	order by 1
)
,
deals_avg_30day as (
	select sales_transaction_date, daily_num_sales, 
	avg(daily_num_sales) over (order by sales_transaction_date rows between 30 preceding and current row) as sma_30,
	row_number() over (order by sales_transaction_date) as row_num
	from daily_deals
)

select sales_transaction_date, daily_num_sales, case
													when row_num >=30 then sma_30
													else null
												end as moving_avg_30
from deals_avg_30day
where sales_transaction_date >= '2018-01-01' and  sales_transaction_date < '2019-01-01';
```
 **Calculate what decile each dealership would be in compared to other dealerships based on their total sales amount.**
```sql
with all_dealerships as (
	select dealership_id, sum(sales_amount) as sales_amount_d
	from sales
	where sales_transaction_date >= '2018-01-01' and  sales_transaction_date < '2019-01-01' and channel = 'dealership'
	group by 1
	order by 1
)

select dealership_id, sales_amount_d,  ntile(10) over (order by sales_amount_d) as decile
from all_dealerships;
```

# Chapter 06  
**Accessing database from python interface:** 

```python
import psycopg2

conn = psycopg2.connect(
    host = 'localhost',
    dbname = 'sqlda',
    port = 5432,
    user = 'postgres',
    password = 'postgres'
)

cur = conn.cursor()

cur.execute("select * from customers limit 10;")


result = cur.fetchall()

cur.close()
conn.close()
```
**SQL Alchemy engine object has advantages such as :**

- Connection pool allows for multiple connections simulataneously.
- Lazy initialization (connection is established based on the request). 
- This minimizes the connection time and reduces the load on the database.
- It autocommits to the database.

```python
import pandas as pd
from sqlalchemy import create_engine
%matplotlib inline
```

```python
conn_string =  ("postgresql+psycopg2://{username}:{pswd}@{host}:{port}/{database}")
print(conn_string)

engine = create_engine(conn_string.format(
    username = 'postgres',
    pswd = 'postgres',
    host = 'localhost',
    port = 5432,
    database = 'sqlda'
                        )
                          )
```
```python
engine.execute("SELECT * FROM customers LIMIT 10;").fetchall()

df_customers = pd.read_sql_table('customers',engine)

```
### Exercise 21: 
**Reading Data and Visualizing Data in Python**  

```python
query = """select city, count() as number_of_customers, count(nullif(gender,'M')) as female_count,
           count(nullif(gender, 'F')) as male_count
           from customers
           group by city
           order by number_of_customers desc
           limit 10;
"""

top10_cities = pd.read_sql_query(query, engine)

top10_cities.plot.bar(x='city',y=['male_count','female_count'], title='Customers by Gender Across Top 10 Cities')
```
![alt text](./chapter06/images/customer_distribution.png)  


**Writing Data to the Database Using Python**
```python
top10_cities.to_sql('top10_cities', engine, index=False, if_exists='replace')
```

## Activity 8: 
**Using an External Dataset to Discover Sales Trends**

```python
public_transport = pd.read_csv('../public_transportation_statistics_by_zip_code.csv', dtype={'zip_code':str})
public_transport.head()
```


| zip_code | public_transportation_pct | public_transportation_population |
|----------|---------------------------|--------------------------------|
| 01379    | 3.3                       | 13                             |
| 01440    | 0.4                       | 34                             |
| 01505    | 0.9                       | 23                             |
| 01524    | 0.5                       | 20                             |
| 01529    | 1.8                       | 32                             |



**Improving the speed for the copy of the data**
```python
import csv
from io import StringIO
def psql_insert_copy(table, conn, keys, data_iter):
    # gets a DBAPI connection that can provide a cursor
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:
        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)
        columns = ', '.join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = '{}.{}'.format(table.schema, table.name)
        else:
            table_name = table.name
        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)

public_transport.to_sql('public_transportation_by_zip', engine, index=False, if_exists='replace', method=psql_insert_copy)
```

```python
#after you have installed ipython-sql
%load_ext sql
```

```python
%sql postgresql://postgres:postgres@localhost:5432/sqlda
```
```python
%%sql
select max(public_transportation_pct) AS max_pct,
                     min(public_transportation_pct) AS min_pct
                     from public_transportation_by_zip;
```

| max_pct | min_pct       |
|---------|--------------|
| 100.0   | -666666666.0 |


We need to exclude all zip codes where public_transportation_pct is less than 0 so that you exclude the missing data (denoted by -666666666).

**Calculate the average sales amounts for customers that live in high public transportation regions (over 10%) as well as low public transportation usage (less than, or equal to, 10%).**


```python
%%sql
select (public_transportation_pct > 10) as is_high_public_transport,
count(s.customer_id) * 1.0 / count(distinct c.customer_id) as sales_per_customer
from customers c inner join public_transportation_by_zip t
on c.postal_code = t.zip_code
left join sales s on s.customer_id = c.customer_id
WHERE public_transportation_pct >= 0
group by is_high_public_transport
```

is_high_public_transport	sales_per_customer
False	0.71569054583929793988
True	0.83159379407616361072

**Read the data into pandas and plot a histogram of the distribution (hint: you can use my_data.plot.hist(y='public_transportation_pct') to plot a histogram if you read the data into a my_data pandas DataFrame).**


```python
data = pd.read_sql_query("""select * FROM public_transportation_by_zip 
                         where public_transportation_pct > 0 AND public_transportation_pct < 50""", engine)
data.plot.hist(y='public_transportation_pct')
```
![alt text](./chapter06/images/public_transport.png)  


**Using pandas, test using the to_sql function with and without the method=psql_insert_copy parameter. How do the speeds compare? (Hint: In a Jupyter notebook, you can add %time in front of your command to see how long it takes.)**

```python
%time public_transport.to_sql('public_transportation_by_zip', \
                              engine, index=False, if_exists='replace', method=psql_insert_copy)
```
> Wall time: 162 ms

```python
%time public_transport.to_sql('public_transportation_by_zip', \
                              engine, index=False, if_exists='replace')

```
> Wall time: 1.14 s

Clearly we can see the difference in the execution times.  

**Group customers based on their zip code public transportation usage, rounded to the nearest 10%, and look at the average number of transactions per customer. Export this data to Excel and create a scatterplot to better understand the relationship between public transportation usage and sales.**

```python
data = pd.read_sql_query(""" 
    select 10 * round(public_transportation_pct/10) as public_transport,
    count(s.customer_id) * 1.0 / count(distinct c.customer_id) as sales_per_customer
    from customers c inner join public_transportation_by_zip t 
    on t.zip_code = c.postal_code
    left join sales s 
    on s.customer_id = c.customer_id 
    where public_transportation_pct >= 0
    group by 1""", engine)

data.to_csv('./sales_vs_public_transport_pct.csv', index=False)
```
**Scatter Plot**  

![alt text](./chapter06/images/scatter.png)  


**Based on this analysis, what recommendations would you have for the executive team at ZoomZoom when considering expansion opportunities?**

We can see that there is a positive relationship between "geographies with public transportation" and "the demand for electric vehicles". This makes sense, because electric vehicles could be an alternative option to public for transport to get around cities. So, we could recommend that ZoomZoom management should consider expanding in regions with high public transportation usage and in urban areas.

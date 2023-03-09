-- Excercise 16 -- 
/* The company would like a running total of how many users have filled in their street address over time. Write a query to produce these results. */

select customer_id, street_address, date_added::DATE,
count(case
	  	when street_address is not null then customer_id
	    else null
	  end) over ( order by  date_added::DATE) as total_customers_filled_address
from customers
order by date_added;

-- Excercise 17 -- 

-- ZoomZoom would like to promote salespeople at their regional dealerships to management 
-- and would like to consider tenure in their decision. 
-- Write a query that will rank the order of users according to their hire date for each dealership:

select dealership_id, salesperson_id, first_name, last_name, hire_date, RANK() over (partition by dealership_id order by hire_date)
from salespeople
where termination_date is null;


-- EXTRA ROLLING AVERAGE-- 

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


-- Excercise 18 -- 

-- Write a query that produces the total sales in dollars for a given day 
-- and the target the salespeople have to beat for that day, starting from January 1, 2019:

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


-- Activity 07 -- 
-- Sales team want to see how the company has performed overall, as well as how individual dealerships have performed within the company.

-- Calculate the total sales amount by day for all of the days in the year 2018 (that is, before the date January 1, 2019).

select sales_transaction_date::DATE, sum(sales_amount) as total_daily_sales
from sales
where sales_transaction_date >= '2018-01-01' and sales_transaction_date < '2019-01-01'
group by 1
order by 1


-- Calculate the rolling 30-day average for the daily number of sales deals.

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

-- Calculate what decile each dealership would be in compared to other dealerships based on their total sales amount.

with all_dealerships as (
	select dealership_id, sum(sales_amount) as sales_amount_d
	from sales
	where sales_transaction_date >= '2018-01-01' and  sales_transaction_date < '2019-01-01' and channel = 'dealership'
	group by 1
	order by 1
)

select dealership_id, sales_amount_d,  ntile(10) over (order by sales_amount_d) as decile

from all_dealerships











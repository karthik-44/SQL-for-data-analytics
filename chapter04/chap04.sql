-- Excercise 13 --
/*
You now want to calculate the lowest price, the highest price, 
the average price, and the standard deviation of the price for all the products the company has ever sold.
*/

select min(base_msrp), max(base_msrp), avg(base_msrp), stddev(base_msrp)
from products;

-- Excercise 14 --
/* The marketing manager wants to know the minimum, maximum, average, 
and standard deviation of the price for each product type that ZoomZoom sells, for a marketing campaign. */

select product_type, min(base_msrp), max(base_msrp), avg(base_msrp), stddev(base_msrp)
from products
group by product_type
order by 1;

-- Excercise 15 --
/*
The sales manager of ZoomZoom wants to know the customer count for 
the states that have at least 1,000 customers who have purchased any product from ZoomZoom.
*/

select state, count(*)
from customers
group by state
having count(*) > 1000
order by state;

-- Activity 06 --
/*The CEO, COO, and CFO of ZoomZoom would like to gain some insights on what might be driving sales.*/
 
 
/*Calculate the total number of unit sales the company has done.*/
select count(*) from sales;

/*Calculate the total sales amount in dollars for each state.*/

select c.state, sum(sales_amount) 
from sales s inner join customers c
on s.customer_id = c.customer_id
group by state
order by state;

/*Identify the top five best dealerships in terms of the most units sold (ignore internet sales).*/

select dealership_id, count(*)
from sales
where channel='dealership'
group by dealership_id
order by count(*) desc
limit 5;

/*Calculate the average sales amount for each channel, as seen in the sales table, 
and look at the average sales amount first by channel sales, then by product_id, and then by both together.*/

select channel, product_id, avg(sales_amount)
from sales
group by grouping sets(
	(channel),
	(product_id),
	(channel, product_id)

)
order by 1,2


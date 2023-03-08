-- Excercise 10 --
/*list of all customers who bought a car.
all customer IDs, first names, last names, and valid phone numbers of customers who purchased a car.*/

select c.customer_id, c.first_name, c.last_name, c.phone
from customers as c inner join sales as s
on c.customer_id = s.customer_id
inner join products as p
on s.product_id = p.product_id
where p.product_type = 'automobile' and c.phone is not null

-- Excercise 11 --

/*
the marketing team would like to throw a party for some of ZoomZoom's wealthiest customers 
in Los Angeles, CA. To help facilitate the party, they would like you to make a guest list 
with ZoomZoom customers who live in Los Angeles, CA, 
as well as salespeople who work at the ZoomZoom dealership in Los Angeles, CA. 
The guest list should include the first name, the last name, and whether the guest is a customer or an employee.
*/

(select c.first_name, c.last_name, 'customer' as guest
from customers c
where state = 'CA' and city = 'Los Angeles')
union
(
select s.first_name, s.last_name, 'employee' as guest
from salespeople s inner join dealerships d
on s.dealership_id = d.dealership_id
where state = 'CA' and city = 'Los Angeles')

-- Excercise 12 --
/*The head of sales has an idea to try and create specialized regional sales teams 
that will be able to sell scooters to customers in specific regions, as opposed 
to generic sales teams. To make his idea a reality, he would like a list of all 
customers mapped to regions. For customers from the states of MA, NH, VT, ME CT, or RI, 
he would like them labeled as New England. 
For customers from the states of GA, FL, MS, AL, LA, KY, VA, NC, SC, TN, VI, WV, or AR, 
he would like the customers labeled as Southeast. 
Customers from any other state should be labeled as Other:
*/

select c.customer_id, case 
						when c.state in ('MA', 'NH', 'VT', 'ME', 'CT', 'RI') then 'New England'
						when c.state in ('GA', 'FL', 'MS', 'AL', 'LA', 'KY', 'VA', 'NC', 'SC', 'TN', 'VI', 'WV', 'AR') then 'Southeast'
						else 'Other'
					  end as region
from customers as c
order by 1;


-- Activity 05 -- 

/*The data science team wants to build a new model to help predict which customers are the best prospects for remarketing. 
*/


select c.*, p.*, coalesce(s.dealership_id, -1), 
case 
	when p.base_msrp - s.sales_amount < 500 then 1
	else 0 
end as high_savings
from customers c inner join sales s
on c.customer_id = s.customer_id
inner join products p
on p.product_id = s.product_id
--LEFT JOIN dealerships d ON s.dealership_id = d.dealership_id;









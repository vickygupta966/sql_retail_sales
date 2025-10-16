Create table retail_sales (
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(15),
quantity int,
price_per_unit float,
cogs float,
total_sale float
);

select*from retail_sales;

select count(*) from retail_sales;
select count( distinct customer_id) from retail_sales;
select count(distinct category) from retail_sales;



select*from retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null

delete from retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select* from retail_sales
where sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where category = 'Clothing'
and
to_char(sale_date,'yyyy-mm') = '2022-11'
and
quantity >= 4

-- Write a SQL query to calculate the total sales (total_sale) for each category.:

select category,
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age),2) as avg_age
from retail_sales
where 
category = 'Beauty'

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale > 1000

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select
category,
gender,
count(*) as total_trans
from retail_sales
group by 
category,
gender
order by 1

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT year,month,
avg_sale
from (
select extract(year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1

-- **Write a SQL query to find the top 5 customers based on the highest total sales **:

select
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1 
limit 5

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

 select
 category,
 count(distinct customer_id) as cnt_unique_cs
 from retail_sales
 group by category

 -- Top 3 categories by average order value (AOV per category).

select category,
round(avg(total_sale)::numeric,2) as aov
from retail_sales
group by category
order by aov DESC
limit 3;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale
as
(
select *,
case
when extract(hour from sale_time)<12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else'evening'
end as shift
from retail_sales
)
select shift,
count(*) as total_orders
from hourly_sale
group by shift

-- Show transactions where sale_time is between 18:00 and 23:59 (evening sales).

select * from retail_sales
where sale_time between '18:00'::time and '23:59'::time
order by sale_time;

-- Find the day with the highest total sales (date + revenue).

select sale_date, sum(total_sale) as revenue
from retail_sales
group by sale_date
order by revenue DESC
limit 1;

-- Customers who spent more than the 95th percentile of customer lifetime spend.

with cust as (
select customer_id, sum(coalesce(total_sale,0)) as total_revenue
from retail_sales
group by customer_id
)
select * from cust
where total_revenue > (
  select percentile_disc(0.95) within group (order by total_revenue) from cust
)
order by total_revenue desc;

-- For each category, show median total_sale.

SELECT category,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY total_sale) AS median_total_sale
FROM retail_sales
GROUP BY category
ORDER BY category;

-- end of project


   
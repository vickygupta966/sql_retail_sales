# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_s1`


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_s1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_s1;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select* from retail_sales
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_sales
where category = 'Clothing'
and
to_char(sale_date,'yyyy-mm') = '2022-11'
and
quantity >= 4

```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select round(avg(age),2) as avg_age
from retail_sales
where 
category = 'Beauty'

```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales
where total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select
category,
gender,
count(*) as total_trans
from retail_sales
group by 
category,
gender
order by 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1 
limit 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
 select
 category,
 count(distinct customer_id) as cnt_unique_cs
 from retail_sales
 group by category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

11. ** Top 3 categories by average order value (AOV per category).**:
```sql
select category,
round(avg(total_sale)::numeric,2) as aov
from retail_sales
group by category
order by aov DESC
limit 3;
```

12. ** Find the day with the highest total sales (date + revenue).**:
```sql
select sale_date, sum(total_sale) as revenue
from retail_sales
group by sale_date
order by revenue DESC
limit 1;
```

13. **  Customers who spent more than the 95th percentile of customer lifetime spend.**:
```sql
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
```

14. **For each category, show median total_sale.**:
```sql
select category,
percentile_cont(0.5) within group (order by total_sale) as median_total_sale
from retail_sales
group by category
order by category;
```
 
    
    
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. 

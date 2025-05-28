-- Retail Sales Analysis

-- Create TABLE
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales;

-- count total number of records in a dataset
SELECT
	count(*)
FROM retail_sales;

-- 

SELECT *
FROM retail_sales
WHERE 
	sale_date IS NULL
	OR 
	sale_time IS NULL 
	OR
	customer_id IS NULL
	OR 
    gender IS NULL 
	OR 
	age IS NULL 
	OR
	category IS NULL 
	OR 
    quantity IS NULL
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Data Exploration
-- How many sales we have?
SELECT count(*) as total_sales from retail_sales;

-- How many unique customers we have?
SELECT count(DISTINCT customer_id) as total_customers from retail_sales;

--How many distinct categories we have?
SELECT DISTINCT category FROM retail_sales;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND
	quantity>=4;

--  Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT sum(total_sale) as Total_sales, category 
FROM retail_sales
Group BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT round(avg(age),2) as average from retail_sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
Where total_sale>1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category, gender, count(*) as total_transactions
FROM
	retail_sales
GROUP BY 
	category,
	gender;

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, sum(total_sale) as Total_sales
from retail_sales
group by customer_id
order by Total_sales desc
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,count(distinct customer_id)
from retail_sales
group by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,month,average_sale 
from(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		avg(total_sale) as average_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	group by year,month
) as t1
WHERE rank=1;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
as
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
) 
SELECT shift, count(*) as total_orders
from hourly_sale
group by shift;
-- KPIs --
--total sales--
SELECT SUM(sales) AS total_sales
FROM fact_sales 

--total profit--
SELECT SUM(profit) AS total_profit
FROM fact_sales 

--Total Orders--
SELECT COUNT(DISTINCT order_id)
FROM fact_sales

--Total Customers--
SELECT COUNT(DISTINCT customer_key) AS total_customers
FROM fact_sales;
--Total Quantity Sold--
SELECT SUM(quantity) As total_quantity
FROM fact_sales

--Average Order Value--
SELECT sum(sales) / COUNT(DISTINCT order_id) as AOV
FROM fact_sales

--Profit Margin %--
SELECT ROUND(sum(profit) / sum(sales)* 100  ,2) as Profit_Margin
FROM fact_sales

--Average Discount--
SELECT AVG(discount) * 100 
FROM fact_sales

--Average Shipping Cost--
SELECT AVG(shipping_cost) AS Average_Shipping_Cost
FROM fact_sales


/*===========[ Business Analysis Queries ]==================

1) Sales Performance Analysis
A) Sales by Category */
WITH category_sales AS(
    SELECT
        category,
        sum(sales) as category_total_sales,
        sum(profit) as category_profit_sales
    FROM fact_sales fs
    JOIN product_dim AS pd ON fs.product_key = pd.product_key
    GROUP BY Category
),
category_total_sales AS(
        SELECT 
        category,
        category_total_sales,
        category_profit_sales,
        SUM(category_total_sales) OVER() total_sales,
        SUM(category_profit_sales) OVER() total_profit
    FROM category_sales
)
SELECT 
    category,
    category_total_sales,
    total_sales,
    ROUND((category_total_sales / total_sales) * 100,2) as sales_percentage,
    category_profit_sales,
    total_profit,
    ROUND((category_profit_sales / total_profit) * 100,2) as profit_percentage
FROM category_total_sales
order BY profit_percentage  DESC
--2-Top 10 Sales by Sub-Category    --

WITH sub_category_totals AS(
    SELECT 
        sub_category,
        sum(sales) as sub_category_sales
    FROM fact_sales fs
    JOIN product_dim AS pd ON fs.product_key = pd.product_key
    GROUP BY sub_category
),
sub_category_total AS(
SELECT 
    sub_category,
    sub_category_sales,
    SUM(sub_category_sales) OVER() total_sales
FROM sub_category_totals
)
SELECT 
    sub_category,
    sub_category_sales,
    total_sales,
    ROUND((sub_category_sales / total_sales) * 100,2) as sales_contribution
FROM sub_category_total
ORDER BY sales_contribution DESC
LIMIT 10 ;
--3 -Top 10 Products by Sales--
WITH product_sales as(
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    sum(sales) total_sales
FROM 
    fact_sales fs
JOIN product_dim pd ON fs.product_key = pd.product_key
GROUP BY 
    product_id,
    product_name,
    category,
    sub_category
),
product_ranking AS (SELECT 
    product_id,
    product_name,
    category,
    sub_category,
    total_sales,
    RANK() OVER(ORDER BY total_sales DESC) product_rank
FROM product_sales
)
SELECT
    product_name,
    total_sales,
    product_rank
    
FROM product_ranking
WHERE product_rank <= 10

-- 4 -Top 10 Products by Profit--
WITH product_profit as(
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    sum(profit) total_profit
FROM 
    fact_sales fs
JOIN product_dim pd ON fs.product_key = pd.product_key
GROUP BY 
    product_id,
    product_name,
    category,
    sub_category
),
product_ranking AS (SELECT 
    product_id,
    product_name,
    category,
    sub_category,
    total_profit,
    RANK() OVER(ORDER BY total_profit DESC) product_rank
FROM product_profit
)
SELECT
    product_name,
    total_profit,
    product_rank
    
FROM product_ranking
WHERE product_rank <= 10

--2) Customer Analysis--
--Top 10 Customers by Sales--
WITH customer_sales as (
SELECT 
    customer_id, 
    customer_name,
    sum(sales) AS customer_total_sales
FROM 
    fact_sales AS fs
JOIN dim_customer AS dc
ON fs.customer_key = dc.customer_key
GROUP BY customer_name,customer_id
),
customer_sales_total as(
SELECT 
    customer_id, 
    customer_name,
    customer_total_sales,
    sum(customer_total_sales) over() as total_sales
FROM
    customer_sales
)
SELECT 
    customer_id, 
    customer_name,
    customer_total_sales,
    total_sales,
    ROUND((customer_total_sales / total_sales) * 100,2) as customer_sales_contribution
FROM
    customer_sales_total 
ORDER BY customer_sales_contribution DESC
LIMIT 10;


--Sales & Profit by Customer Segment--
WITH segment_totals AS (
SELECT 
    segment,
    sum(profit) AS segment_total_profit,
    sum(sales) AS segment_total_sales
FROM 
    fact_sales fs
JOIN dim_customer AS dc
ON fs.customer_key = dc.customer_key
GROUP BY segment
),
total_segement AS(SELECT 
    segment,
    segment_total_profit,
    SUM(segment_total_profit) OVER() as total_profit,
    segment_total_sales,
    SUM(segment_total_sales) over() as total_sales
FROM segment_totals
)
SELECT 
    segment,
    segment_total_profit,
    total_profit,
    ROUND((segment_total_profit / total_profit) *100,2) as segment_profit_contribution,
    segment_total_sales,
    total_sales,
    ROUND((segment_total_sales / total_sales) *100,2) as segment_sales_contribution
FROM total_segement

--Average Order Value by Segment--
SELECT 
    segment , 
    SUM(sales) / COUNT(DISTINCT order_id) AS Average_Order_Value
FROM fact_sales fs
JOIN dim_customer dc
ON dc.customer_key = fs.customer_key
GROUP BY segment
ORDER BY Average_Order_Value DESC;

/*
3) Geographic Analysis
--Top 15 Sales by Country*/
WITH country_sales AS (
    SELECT 
        country,
        sum(sales) AS total_sales
    FROM 
        fact_sales fs
    JOIN 
        dim_location AS dl
    ON fs.location_key = dl.location_key
    GROUP BY country  
),
country_ranking as(
    SELECT 
        country,
        total_sales,
        RANK() OVER(ORDER BY total_sales DESC) country_rank
    FROM country_sales
)
SELECT
    country,
    total_sales,
    country_rank
FROM 
    country_ranking 
WHERE 
    country_rank <= 15
--Top 15 Sales By Region --
WITH region_sales AS (
    SELECT 
        region,
        sum(sales) AS total_sales
    FROM 
        fact_sales fs
    JOIN 
        dim_location AS dl
    ON fs.location_key = dl.location_key
    GROUP BY region  
),
region_ranking as(
    SELECT 
        region,
        total_sales,
        RANK() OVER(ORDER BY total_sales DESC) region_rank
    FROM region_sales
)
SELECT
    region,
    total_sales,
    region_rank
FROM 
    region_ranking 
WHERE 
    region_rank <= 15
/*
3)===Time Analysis===
*/
--Monthly Sales Trend--
SELECT month , sum(sales) AS total_sales
FROM fact_sales fs
JOIN dim_date AS dd
ON fs.order_date_key = dd.date_key
GROUP BY month 
ORDER BY month 

--Yearly Sales Trend--
SELECT year , sum(sales) AS total_sales
FROM fact_sales fs
JOIN dim_date AS dd
ON fs.order_date_key = dd.date_key
GROUP BY year 
ORDER BY total_sales DESC 

/*
====================[ BUSINESS QUESTIONS ]===================*/
--1)-Which customers generate high sales but negative profit?--

WITH customer_sales AS (
    SELECT
        dc.customer_id,
        dc.customer_name,
        SUM(fs.sales) AS total_sales,
        SUM(fs.profit) AS total_profit
    FROM fact_sales fs
    JOIN dim_customer dc
        ON fs.customer_key = dc.customer_key
    GROUP BY
        dc.customer_id,
        dc.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_sales,
    total_profit
FROM customer_sales
WHERE
    total_profit < 0
    AND total_sales > (
        SELECT AVG(total_sales)
        FROM customer_sales
    )
ORDER BY total_profit ASC;
     

--2)-Which products should be discontinued?--

WITH product_sales AS(
    SELECT 
        pd.product_key,
        pd.product_id,
        pd.product_name,
        SUM(sales) as total_sales,
        SUM(profit) as total_profit,
        sum(quantity) as total_quantity
    FROM fact_sales fs
    JOIN product_dim pd ON fs.product_key = pd.product_key
    GROUP BY
        pd.product_key,
        pd.product_id,
        pd.product_name
)
SELECT
    ps.product_key,
    ps.product_id,
    ps.product_name,
    ps.total_sales,
    ps.total_profit,
    ps.total_quantity
FROM
    product_sales ps
WHERE  ps.total_profit < 0 
AND ps.total_sales < (SELECT AVG(total_sales) FROM product_sales)
ORDER BY total_profit ASC

--(2-2)-Do discontinued candidates also have low sales volume?--
WITH product_sales AS(
    SELECT 
        pd.product_key,
        product_id,
        product_name,
        SUM(sales) as total_sales,
        SUM(profit) as total_profit,
        sum(quantity) as total_quantity
    FROM fact_sales fs
    JOIN product_dim pd ON fs.product_key = pd.product_key
    GROUP BY
        pd.product_key,
        product_id,
        product_name
),
discontinued_products AS (SELECT
    ps.product_key,
    product_id,
    product_name,
    total_sales,
    total_profit,
    total_quantity
FROM
    product_sales ps
WHERE  ps.total_profit < 0 
AND ps.total_sales < (SELECT AVG(total_sales) FROM product_sales)
),
discontinued_products_categories As(SELECT 
    product_key,
    product_id,
    product_name,
    total_sales,
    total_profit,
    total_quantity,
    CASE 
        WHEN total_quantity < (SELECT avg(total_quantity) FROM product_sales)
        THEN 'Low Volume'
        ELSE 'High Volume'
    END AS quantity_category
FROM discontinued_products
)
SELECT 
    quantity_category,
    COUNT(quantity_category) category_count
FROM discontinued_products_categories
GROUP BY quantity_category

--3)-Does offering higher discounts actually increase sales, or does it just reduce profit?--
SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit)/ SUM(sales))*100,2) as Profit_Margin,
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount > 0 AND discount <= 0.10 THEN 'Low Discount'
        WHEN discount >0.10 AND discount <= 0.20 THEN 'Mid Discount'
        WHEN discount > 0.20 AND discount <=0.40 THEN 'high Discount'
        ELSE 'Very High Discount'
    END AS Discount_catrgory
    FROM fact_sales 
    GROUP BY CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount > 0 AND discount <=0.10 THEN 'Low Discount'
        WHEN discount >0.10 AND discount <= 0.20 THEN 'Mid Discount'
        WHEN discount > 0.20 AND discount <= 0.40 THEN 'high Discount'
        ELSE 'Very High Discount'
    END 
    ORDER BY Profit_Margin ASC


--4)-Which category contributes the most to total sales (%)?--
WITH category_sales AS(
        SELECT 
        category,
        sum(sales) as total_sales_by_category
    FROM 
        fact_sales fs
    JOIN product_dim pd ON fs.product_key = pd.product_key
    GROUP BY category
)
SELECT 
    category,
    total_sales_by_category,
    SUM(total_sales_by_category) OVER() as total_sales,
    ROUND((total_sales_by_category /SUM(total_sales_by_category) OVER() )*100,2) as category_contribution
FROM category_sales
order by category_contribution DESC


--5)-Rank products by sales within each category--
WITH product_sales As(
    SELECT 
        product_name,
        category,
        sub_category,
        sum(sales) as total_sales
    FROM fact_sales fs
    JOIN product_dim pd 
    ON fs.product_key = pd.product_key
    GROUP BY product_name , category ,sub_category
),
product_ranking AS (SELECT 
    product_name,
    total_sales,
    Rank() over(
    partition by category 
    order by total_sales DESC
    ) As product_rank
FROM 
    product_sales
)
SELECT 
    product_name,
    total_sales,
    product_rank
FROM product_ranking
WHERE product_rank <= 10 
--6)-Products with above-average sales and negative profit--
WITH product_sales As(
    SELECT 
        pd.product_key,
        product_id,
        product_name,
        category,
        sub_category,
        sum(sales) as total_sales,
        sum(profit) as total_profit
    FROM fact_sales fs
    JOIN product_dim pd 
    ON fs.product_key = pd.product_key
    GROUP BY product_name , category , sub_category,product_id,pd.product_key
),
product_above_sales_under_profit AS (SELECT 
    product_name,
    total_sales,
    total_profit
FROM product_sales
WHERE total_sales > (SELECT avg(total_sales) FROM product_sales) AND
total_profit < 0
)
SELECT 
    product_name,
    total_sales,
    total_profit
FROM product_above_sales_under_profit
ORDER BY total_profit ASC
LIMIT 20;
--7)-Identify the top 5 most profitable products in each category--
WITH product_profit AS(
    SELECT
    product_name,
    category,
    sum(profit) as total_profit
FROM fact_sales fs
JOIN product_dim pd
ON fs.product_key = pd.product_key
GROUP BY
    product_name,
    category
)
,
product_ranking AS(
SELECT 
    product_name,
    category,
    total_profit,
    Rank() OVER(partition by category order by total_profit DESC) as product_rank
FROM product_profit
)

SELECT  
    product_name,
    category,
    total_profit,
    product_rank
FROM product_ranking
WHERE product_rank <= 5

--8)-Find the top 3 customers by total sales in each market--
WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        market,
        sum(sales) as total_sales
    FROM
        fact_sales fs
    JOIN dim_customer dc ON fs.customer_key = dc.customer_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
    GROUP BY 
        customer_id,
        customer_name,
        market
),
customer_ranking AS(
    SELECT
        customer_id,
        customer_name,
        market,
        total_sales,
        Rank() OVER(PARTITION BY market order by total_sales DESC) as customer_rank
    FROM customer_sales
)
SELECT 
    customer_id,
    customer_name,
    market,
    total_sales,
    customer_rank
FROM 
    customer_ranking
WHERE customer_rank <= 3;

--9)-Identify the least profitable sub-categories in each region--
WITH sub_category_profit As(
    SELECT
        sub_category,
        region,
        sum(profit) as total_profit
    FROM fact_sales fs
    JOIN product_dim pd ON fs.product_key = pd.product_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
GROUP BY 
    sub_category,
    region
),
sub_categories_ranking AS(
    SELECT
        sub_category,
        region,
        total_profit,
        RANK() OVER(PARTITION BY region order by total_profit ASC) AS sub_category_rank
    FROM sub_category_profit
)
SELECT 
    region,
    sub_category,
    total_profit,
    sub_category_rank
FROM sub_categories_ranking


--10)-Compare yearly sales growth for each market--
WITH yearly_sales AS(
    SELECT
        market,
        year,
        sum(sales) as total_sales
    FROM fact_sales fs
    JOIN dim_date dd ON fs.order_date_key = dd.date_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
    GROUP BY
        market,
        year
),
previous_sales AS(
SELECT
    market,
    year,
    total_sales,
    LAG(total_sales,1) OVER(PARTITION BY market order by year ASC) as previous_year_sale
FROM yearly_sales
)
SELECT 
    market,
    year,
    total_sales,
    previous_year_sale,
    ROUND((((total_sales - previous_year_sale) /previous_year_sale ) * 100),2) as "YoY_growth%"
FROM previous_sales

--11)-Calculate the running total of sales over time for each market--
WITH market_year_sales AS (
    SELECT
        market,
        year,
        sum(sales) as total_sales
    FROM fact_sales fs
    JOIN dim_date dd ON fs.order_date_key = dd.date_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
    GROUP BY market , year
)
SELECT  
    market,
    year,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY market order by year) as total_running
FROM market_year_sales

--12)-Calculate the moving average of monthly sales for each market--
WITH market_month_sales AS(
    SELECT
        market,
        year,
        month,
        month_name,
        sum(sales) as total_sales
    FROM fact_sales fs
    JOIN dim_date dd ON fs.order_date_key = dd.date_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
    GROUP BY market , year , month , month_name
) 
SELECT
    market,
    year,
    month,
    total_sales,
    ROUND(AVG(total_sales) OVER(
    PARTITION BY market
    order by year , month
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) as moving_average
FROM market_month_sales

--13)-Find the top-selling product in each market--
WITH product_sales AS(
    SELECT
        market,
        product_id,
        product_name,
        category,
        sub_category,
        sum(sales) as total_sales
    FROM fact_sales fs
    JOIN product_dim pd ON fs.product_key = pd.product_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
    GROUP BY 
        market,
        product_id,
        product_name,
        category,
        sub_category
),
product_ranking AS (SELECT 
    market,
    product_name,
    total_sales,
    RANK() OVER(PARTITION BY market order by total_sales DESC) as product_rank
FROM product_sales
)

SELECT 
    market,
    product_name,
    total_sales,
    product_rank
FROM product_ranking
WHERE product_rank = 1

--14)-Identify customers whose total profit is negative (loss-making customers)--
WITH customer_profit AS (
SELECT 
    customer_id,
    customer_name,
    sum(profit) as total_profit
FROM 
    fact_sales fs
JOIN dim_customer dc ON fs.customer_key = dc.customer_key
GROUP BY 
    customer_id , customer_name
)
SELECT
    customer_id,
    customer_name,
    total_profit
FROM customer_profit
WHERE total_profit < 0
order by total_profit ASC
LIMIT 20;


--15)-Find orders where the shipping cost is greater than 20% of the sales amount--
WITH order_totals AS 
(
    SELECT
        order_id,
        sum(sales) total_sales,
        sum(shipping_cost) total_shipping_cost
    FROM fact_sales
    GROUP BY order_id
)
SELECT 
    order_id,
    total_sales,
    total_shipping_cost,
    ROUND((total_shipping_cost / total_sales) * 100,2) as shipping_percentage
FROM order_totals
WHERE total_shipping_cost > (0.20 * total_sales)
order by total_shipping_cost DESC
LIMIT 25;

SELECT count(DISTINCT customer_id) FROM dim_customer
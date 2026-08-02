CREATE TABLE dim_customer
(
    customer_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT
)

INSERT INTO dim_customer (customer_id, customer_name,segment)
    SELECT DISTINCT 
        customer_id,
        customer_name,
        segment
    FROM 
        staging_sales

-- check if there is duplicate id in Dim_customer        
SELECT customer_id , count(*)
FROM dim_customer
GROUP BY customer_id
HAVING  count(*) > 1;
--Ensure thar customer_id determines one customer_name
SELECT customer_id,
    COUNT(DISTINCT customer_name) as customer_name
FROM staging_sales
GROUP BY customer_id
HAVING 
    COUNT(DISTINCT customer_name) > 1 
--ckeck the number of rows
SELECT count(*) FROM dim_customer;
-- 4873 row



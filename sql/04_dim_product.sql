CREATE TABLE product_dim(   
    product_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id TEXT NOT NULL,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    sub_category TEXT NOT NULL
);

INSERT INTO product_dim (product_id, product_name,category,sub_category)
    SELECT DISTINCT 
    product_id,
    product_name,
    category,
    sub_category
    from staging_sales;
    
SELECT * FROM product_dim
/*
SELECT
    product_id,
    product_name,
    COUNT(*)
FROM product_dim
GROUP BY product_id , product_name
HAVING COUNT(*) > 1;

SELECT * FROM product_dim
WHERE product_id = 'OFF-SU-10002032'

SELECT
    product_id,
    product_name,
    COUNT(*)
FROM staging_sales
WHERE product_id = 'OFF-BI-10004632'
GROUP BY product_id, product_name;

SELECT
    COUNT(DISTINCT product_id) AS distinct_product_ids,
    COUNT(DISTINCT product_name) AS distinct_product_names
FROM staging_sales

SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM staging_sales
WHERE product_id = 'OFF-SU-10002032';

SELECT product_id ,product_name,count(*) FROM staging_sales
WHERE product_id = 'OFF-SU-10002032'
GROUP BY product_id ,product_name

SELECT product_name , count(*)
FROM product_dim
GROUP BY product_name
HAVING count(*) > 1

SELECT product_name,
    COUNT (DISTINCT category) as category,
    COUNT (DISTINCT sub_category) as sub_category
from product_dim
GROUP BY product_name
HAVING COUNT (DISTINCT category)  > 1 OR
COUNT (DISTINCT sub_category) > 1
*/

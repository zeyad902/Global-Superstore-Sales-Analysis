CREATE TABLE fact_sales
(
    product_key INT REFERENCES product_dim(product_key) NOT NULL,

    customer_key INT REFERENCES dim_customer(customer_key) NOT NULL,

    location_key INT REFERENCES dim_location(location_key) NOT NULL,

    order_date_key INT REFERENCES dim_date(date_key) NOT NULL,

    ship_date_key INT REFERENCES dim_date(date_key) NOT NULL,

    order_id TEXT,

    ship_mode TEXT,

    sales NUMERIC(10,2)
        CHECK(sales >= 0),

    profit NUMERIC(10,2),

    quantity INT
        CHECK(quantity > 0),

    order_priority TEXT,

    discount NUMERIC(4,2)
        CHECK(discount BETWEEN 0 AND 1),

    shipping_cost NUMERIC(10,2)
        CHECK(shipping_cost >= 0)
);

WITH fact_data AS(
    SELECT
    pd.product_key,
    cd.customer_key,
    ld.location_key,
    od.date_key AS order_date_key,
    sd.date_key AS ship_date_key,
    s.order_id,
    s.ship_mode,
    s.sales,
    s.profit,
    s.quantity,
    s.order_priority,
    s.discount,
    s.shipping_cost
    FROM staging_sales AS s
    INNER JOIN product_dim AS pd ON s.product_id = pd.product_id
    AND s.product_name = pd.product_name
    AND s.category = pd.category
    AND s.sub_category = pd.sub_category
    INNER JOIN dim_customer AS cd ON s.customer_id = cd.customer_id
    INNER JOIN dim_location AS ld ON s.city = ld.city
    AND s.state = ld.state
    AND s.country = ld.country
    AND s.market  = ld.market
    INNER JOIN dim_date AS od ON s.order_date = od.full_date
    INNER JOIN dim_date AS sd ON s.ship_date = sd.full_date
)
INSERT INTO fact_sales
(
    product_key,
    customer_key,
    location_key,
    order_date_key,
    ship_date_key,
    order_id,
    ship_mode,
    sales,
    profit,
    quantity,
    order_priority,
    discount,
    shipping_cost
)
SELECT
    product_key,
    customer_key,
    location_key,
    order_date_key,
    ship_date_key,
    order_id,
    ship_mode,
    sales,
    profit,
    quantity,
    order_priority,
    discount,
    shipping_cost
FROM fact_data;


--add ship days column--
ALTER TABLE fact_sales 
ADD COLUMN ship_days INT;

WITH dates AS
(SELECT
    fs.order_date_key,
    fs.ship_date_key,
    (ship.full_date - ord.full_date) as ship_days
    FROM fact_sales as fs
    JOIN dim_date as ord ON fs.order_date_key = ord.date_key
    JOIN dim_date as ship ON fs.ship_date_key = ship.date_key
)

UPDATE fact_sales fs
SET ship_days = ds.ship_days
FROM dates ds
where fs.ship_date_key = ds.ship_date_key 
AND
    fs.order_date_key = ds.order_date_key

SELECT * FROM fact_sales
order by order_id
 LIMIT 5;

 SELECT
    MIN(ship_days),
    MAX(ship_days)
FROM fact_sales;

SELECT
    ship_days,
    COUNT(*) AS total_orders
FROM fact_sales
GROUP BY ship_days
ORDER BY ship_days;
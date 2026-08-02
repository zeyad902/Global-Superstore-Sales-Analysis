CREATE TABLE dim_date(
    date_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_date date,
    year INT,
    month INT,
    month_name TEXT,
    day INT ,
    day_name TEXT,
    quarter INT
)
INSERT INTO dim_date(full_date,year,month,month_name,day,day_name ,quarter)
SELECT full_date,
       EXTRACT(YEAR FROM full_date),
       EXTRACT(MONTH FROM full_date),
       TO_CHAR(full_date, 'Month'),
       EXTRACT(DAY FROM full_date),
       TO_CHAR(full_date, 'Day'),
       EXTRACT(QUARTER FROM full_date)
FROM (
    SELECT order_date as full_date
    FROM staging_sales

    UNION 

    SELECT ship_date as full_date
    FROM staging_sales
)


ALTER TABLE dim_date
ADD COLUMN year_month_key int,
ADD COLUMN year_month TEXT

UPDATE dim_date
    SET 
        year_month_key = CONCAT(
            year,
            LPAD(month::TEXT,2,'0')
        )::INT
UPDATE dim_date 
    SET 
        year_month = TO_CHAR(full_date , 'Mon YYYY')

SELECT full_date,year_month_key,year_month FROM dim_date
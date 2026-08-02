CREATE TABLE dim_location(
    location_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city text,
    state text,
    country text,
    market text,
    market_region text,
    region text
);
INSERT INTO dim_location(city ,state ,country,market ,market_region ,region)
SELECT DISTINCT 
city ,state ,country,market ,market_region ,region
FROM staging_sales
/*
No Duplicate in Table
SELECT
    city,
    state,
    country,
    region,
    market,
    market_region,
    COUNT(*)
FROM dim_location
GROUP BY
    city,
    state,
    country,
    region,
    market,
    market_region
HAVING COUNT(*) > 1;

--is these columns can be use as business key ? No--
SELECT city,state,country,market,
    count(DISTINCT market_region) as market_region, 
    count(DISTINCT region) as region
FROM 
    staging_sales
GROUP BY 
    city , state ,country,market
HAVING 
    count(DISTINCT market_region) > 1 OR
    count(DISTINCT region) > 1 
*/
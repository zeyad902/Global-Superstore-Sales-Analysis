copy staging_sales
FROM 'D:\college\Data Analysis\PROJECTS\Retail-Sales-Analytics\sql\03_load_staging.sql'
WITH (
    FORMAT CSV,
    HEADER,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '"',
    ENCODING 'UTF8'
);
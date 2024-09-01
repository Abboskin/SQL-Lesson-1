SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name;


--Using the SQL Server OFFSET FETCH example

SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name 
OFFSET 10 ROWS;
--?????????? 10 ????? 

SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name 
OFFSET 10 ROWS 
FETCH NEXT 10 ROWS ONLY;
--?????????? 10 ? ?????????? ?????? ????????? 10 (11-20)

--Using the OFFSET FETCH clause to get the top N rows
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price DESC,
    product_name 
OFFSET 0 ROWS 
FETCH FIRST 10 ROWS ONLY;
--?????????? 10 ????? ??????? 

--SQL Server WHERE examples

--Using the WHERE clause with a simple equality operator
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    category_id = 1
ORDER BY
    list_price DESC;

--Using the WHERE clause with the AND operator

SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    category_id = 1 AND model_year = 2018
ORDER BY
    list_price DESC;

--Using WHERE to filter rows using a comparison operator
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price > 300 AND model_year = 2018
ORDER BY
    list_price DESC;

--Using the WHERE clause to filter rows that meet any of two conditions
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price > 3000 OR model_year = 2018
ORDER BY
    list_price DESC;

--Using the WHERE clause to filter rows with the value between two values

SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price BETWEEN 1899.00 AND 1999.99
ORDER BY
    list_price DESC;

--Using the WHERE clause to filter rows that have a value in a list of values

SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price IN (299.99, 369.99, 489.99)
ORDER BY
    list_price DESC;

--Finding rows whose values contain a string

SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    product_name LIKE '%Cruiser%'
ORDER BY
    list_price;
---------------------------------------------------------
--SQL Server OR Operator

--Basic SQL Server OR operator example 

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price < 200
OR list_price > 6000
ORDER BY
    list_price;

--Using multiple OR operators

SELECT
    product_name,
    brand_id
FROM
    production.products
WHERE
    brand_id = 1
OR brand_id = 2
OR brand_id = 4
ORDER BY
    brand_id DESC;

--Можно писать по отдельности либо засунуть в скобки с IN

SELECT
    product_name,
    brand_id
FROM
    production.products
WHERE
    brand_id IN (1, 2, 3)
ORDER BY
    brand_id DESC;

--Combining the OR operator with the AND operator

SELECT 
    product_name, 
    brand_id, 
    list_price
FROM 
    production.products
WHERE 
    brand_id = 1
      OR brand_id = 2
      AND list_price > 500
ORDER BY 
    brand_id DESC, 
    list_price;

--Сначала идёт AND

SELECT
    product_name,
    brand_id,
    list_price
FROM
    production.products
WHERE
    (brand_id = 1 OR brand_id = 2)
     AND list_price > 500
ORDER BY
    brand_id;

--Чтобы работало на оба ставим скобки 
-----------------------------------------------
--SQL Server NULL

SELECT
    customer_id,
    first_name,
    last_name,
    phone
FROM
    sales.customers
WHERE
    phone = NULL
ORDER BY
    first_name,
    last_name;
--EMPTY RESULT SET

SELECT
    customer_id,
    first_name,
    last_name,
    phone
FROM
    sales.customers
WHERE
    phone IS NULL
ORDER BY
    first_name,
    last_name;

--С NULL можно поставить только IS NULL, IS NOT NULL

SELECT
    customer_id,
    first_name,
    last_name,
    phone
FROM
    sales.customers
WHERE
    phone IS NOT NULL
ORDER BY
    first_name,
    last_name;
-----------------------------------------------------------
--SQL Server AND operator

--Basic SQL Server AND operator example

SELECT 
  * 
FROM 
  production.products 
WHERE 
  category_id = 1 
  AND list_price > 400 
ORDER BY 
  list_price DESC;

--Using multiple SQL Server AND operators

SELECT 
  * 
FROM 
  production.products 
WHERE 
  category_id = 1 
  AND list_price > 400 
  AND brand_id = 1 
ORDER BY 
  list_price DESC;

--Using the AND operator with other logical operators

SELECT
    *
FROM
    production.products
WHERE
    brand_id = 1
OR brand_id = 2
AND list_price > 1000
ORDER BY
    brand_id DESC;

--Сначала идёт AND потом OR по этому выйдет brand_id 2 c list_price>1000 и любой brand_id 1

SELECT
    *
FROM
    production.products
WHERE
    (brand_id = 1 OR brand_id = 2)
AND list_price > 1000
ORDER BY
    brand_id;

--Чтобы сработало и на brend_id 1 и на brend_id 2
--------------------------------------------------------------
--Distinct 

--Using the SELECT DISTINCT with one column
SELECT 
  city 
FROM 
  sales.customers 
ORDER BY 
  city;
--Один несколько раз 
SELECT 
  DISTINCT city 
FROM 
  sales.customers 
ORDER BY 
  city;
--Каждый по одному разу 

--Using SELECT DISTINCT with multiple columns

SELECT 
  city, 
  state 
FROM 
  sales.customers 
ORDER BY 
  city, 
  state;

SELECT 
  DISTINCT city, state 
FROM 
  sales.customers

--Using SELECT DISTINCT with NULL

SELECT 
  DISTINCT phone 
FROM 
  sales.customers 
ORDER BY 
  phone;

--Будет только один NULL

--DISTINCT vs. GROUP BY

SELECT 
  city, 
  state, 
  zip_code 
FROM 
  sales.customers 
GROUP BY 
  city, 
  state, 
  zip_code 
ORDER BY 
  city, 
  state, 
  zip_code

--То же самое что...
SELECT 
  DISTINCT city, state, zip_code 
FROM 
  sales.customers;

-------------------------------------------------------------------
--SQL Server IN Operator

-- Basic SQL Server IN operator example

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;

--Чтобы не писать несколько раз заменяем = на IN и ставим скобки 

--Using SQL Server IN operator with a subquery example

SELECT
    product_id
FROM
    production.stocks
WHERE
    store_id = 1 AND quantity >= 30;
--Находим нужную информацию

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id IN (
        SELECT
            product_id
        FROM
            production.stocks
        WHERE
            store_id = 1 AND quantity >= 30
    )
ORDER BY
    product_name;
--Использование sabquery для нахождения всей информации
---------------------------------------------------------------
--SQL Server BETWEEN Operator

--Using SQL Server BETWEEN with numbers example
SELECT
    product_id,
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price BETWEEN 149.99 AND 199.99
ORDER BY
    list_price;

SELECT
    product_id,
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price NOT BETWEEN 149.99 AND 199.99
ORDER BY
    list_price;

--BETWEEN / NOT BETWEEN

--Using SQL Server BETWEEN with dates example

SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM
    sales.orders
WHERE
    order_date BETWEEN '20170115' AND '20170117'
ORDER BY
    order_date;

--С датами BETWEEN записывается в формате 'YYYYMMDD'

-------------------------------------------------------------
--SQL Server LIKE Operator

--The percent wildcard (%): any string of zero or more characters.
--The underscore (_) wildcard: any single character.
--The [list of characters] wildcard: any single character within the specified set.
--The [character-character]: any single character within the specified range.
--The [^]: any character that is not within a list or a range

--Using the LIKE operator with the % wildcard examples

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE 'z%'
ORDER BY
    first_name;
-------------------------------------
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '%er'
ORDER BY
    first_name;
-------------------------------------
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE 't%s'
ORDER BY
    first_name;

--Using the LIKE operator with the _ (underscore) wildcard example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '_u%'
ORDER BY
    first_name; 

--Using the LIKE operator with the [list of characters] wildcard example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[YZ]%'
ORDER BY
    last_name;

--'[YZ]%' - Yang, Young, Zamora, Zimmerman

--Using the LIKE operator with the [character-character] wildcard example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[A-C]%'
ORDER BY
    first_name;

--Last_name A%,B%,C%

--Using the LIKE operator with the [^Character List or Range] wildcard example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[^A-X]%'
ORDER BY
    last_name;

--Last_name is not A-X (only Y and Z) ^=NOT%

--Using the NOT LIKE operator example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    first_name NOT LIKE 'A%'
ORDER BY
    first_name;

--Using the LIKE operator with ESCAPE example

CREATE TABLE sales.feedbacks (
  feedback_id INT IDENTITY(1, 1) PRIMARY KEY, 
  comment VARCHAR(255) NOT NULL
);

INSERT INTO sales.feedbacks(comment)
VALUES('Can you give me 30% discount?'),
      ('May I get me 30USD off?'),
      ('Is this having 20% discount today?');

SELECT * FROM sales.feedbacks;

SELECT 
   feedback_id,
   comment
FROM 
   sales.feedbacks
WHERE 
   comment LIKE '%30%';
--30USD and 30%

SELECT 
   feedback_id, 
   comment
FROM 
   sales.feedbacks
WHERE 
   comment LIKE '%30!%%' ESCAPE '!';
--Only 30% (ESCAPE)

---------------------------------------------------------------
--SQL Server Alias

--SQL Server column alias
--column_name | expression  AS column_alias

SELECT
    first_name + ' ' + last_name AS full_name
FROM
    sales.customers
ORDER BY
    first_name;
------------------------------------------------
SELECT
    first_name + ' ' + last_name AS 'Full Name'
FROM
    sales.customers
ORDER BY
    first_name;
--Мы ставим ковычки если есть пробел (sapce)

SELECT
    category_name 'Product Category'
FROM
    production.categories;

SELECT
    category_name 'Product Category'
FROM
    production.categories
ORDER BY
    category_name;  


SELECT
    category_name 'Product Category'
FROM
    production.categories
ORDER BY
    'Product Category';
--С order by можем использовать и то и другое

--SQL Server table alias

--table_name AS table_alias
--table_name table_alias

SELECT
    sales.customers.customer_id,
    first_name,
    last_name,
    order_id
FROM
    sales.customers
INNER JOIN sales.orders ON sales.orders.customer_id = sales.customers.customer_id;

SELECT
    c.customer_id,
    first_name,
    last_name,
    order_id
FROM
    sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id;












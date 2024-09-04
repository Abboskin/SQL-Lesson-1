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








--Lesson 4

declare @firstname varchar(100) = 'John,Tom,Bek'
declare @lastname varchar(100) = 'Doe,Cruise,Ibragimov'
declare @n int = 1

select t1.value firstname,
  t2.value lastname
from
(select value,
  row_number() over(order by (select 1)) rn
from string_split(@firstname, ',')
) t1
inner join 
(select value,
  row_number() over(order by (select 1)) rn
from string_split(@lastname, ',')
) t2
  on t1.rn = t2.rn
where t1.rn = @n
--SQL Server HAVING Clause
SELECT
    customer_id,
    YEAR (order_date),
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;


SELECT
    order_id,
    SUM (
        quantity * list_price * (1 - discount)
    ) net_value
FROM
    sales.order_items
GROUP BY
    order_id
HAVING
    SUM (
        quantity * list_price * (1 - discount)
    ) > 20000
ORDER BY
    net_value;


SELECT
    category_id,
    MAX (list_price) max_list_price,
    MIN (list_price) min_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    MAX (list_price) > 4000 OR MIN (list_price) < 500;


SELECT
    category_id,
    AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    AVG (list_price) BETWEEN 500 AND 1000;




--UNION and UNION ALL examples

SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION
SELECT
    first_name,
    last_name
FROM
    sales.customers;


SELECT
    COUNT (*)
FROM
    sales.staffs;
-- 10       

SELECT
    COUNT (*)
FROM
    sales.customers;
-- 1454


SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers;

--UNION and ORDER BY example
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    first_name,
    last_name;


--SQL Server EXCEPT
SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items;

SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items
ORDER BY 
	product_id;

--SQL Server INTERSECT
SELECT
    city
FROM
    sales.customers
INTERSECT
SELECT
    city
FROM
    sales.stores
ORDER BY
    city;





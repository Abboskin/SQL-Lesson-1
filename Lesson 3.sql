--SELF JOINs
--Using self join to query hierarchical data
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
INNER JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;
-----------------------------------------------------------------
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
LEFT JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;
-------------------------------------------------------------------
--Using self join to compare rows within a table
SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id > c2.customer_id
AND c1.city = c2.city
ORDER BY
    city,
    customer_1,
    customer_2;
---------------------------------------------------------------
SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id <> c2.customer_id
AND c1.city = c2.city
ORDER BY
    city,
    customer_1,
    customer_2;
----------------------------------------------------------------------
SELECT 
   customer_id, first_name + ' ' + last_name c, 
   city
FROM 
   sales.customers
WHERE
   city = 'Albany'
ORDER BY 
   c;
--------------------------------------------------------------------
SELECT
    c1.city,
	c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id <> c2.customer_id
AND c1.city = c2.city
WHERE c1.city = 'Albany'
ORDER BY
	c1.city,
    customer_1,
    customer_2;
--------------------------------------------------------------------


--SQL Server GROUP BY Clause
--lesson
CREATE TABLE employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT,
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employee (id, name, city, age, department, salary) VALUES
(1, 'John', 'New York', 25, 'IT', 500),
(2, 'Jane', 'Toronto', 30, 'Sales', 450),
(3, 'Arnold', 'Toronto', 35, 'Sales', 1000),
(4, 'Tom', 'Tashkent', 30, 'HR', 300),
(5, 'Gloria', 'New York', 35, 'IT', 350),
(6, 'Bruce', 'Tashkent', 40, 'HR', 1500),
(7, 'Jack', 'Toronto', 40, 'Sales', 1900);


select
  case 
    when salary < 500 then 'under 500'
    when salary < 1000 then 'between 500 and 1000'
    when salary >= 1000 then 'above 1000'
    else 'test'
  end salary_range,
  avg(age)

from employee
group by case 
    when salary < 500 then 'under 500'
    when salary < 1000 then 'between 500 and 1000'
    when salary >= 1000 then 'above 1000'
    else 'test'
  end

---------------------------------------------
--SQL Server GROUP BY clause and aggregate functions
SELECT
    customer_id,
    YEAR (order_date) order_year,
    COUNT (order_id) order_placed
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id; 
----------------------------------------
SELECT
    customer_id,
    YEAR (order_date) order_year,
    order_status
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;
-----------------------------------------
--Using GROUP BY clause with the COUNT() function example
SELECT
    city,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    city
ORDER BY
    city;
-----------------------------------------------------
SELECT
    city,
    state,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    state,
    city
ORDER BY
    city,
    state;
--------------------------------------------------
--Using GROUP BY clause with the MIN and MAX functions example
SELECT
    brand_name,
    MIN (list_price) min_price,
    MAX (list_price) max_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;
-----------------------------------------------------------
--Using GROUP BY clause with the AVG() function example
SELECT
    brand_name,
    AVG (list_price) avg_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;
------------------------------------------------------------
--Using GROUP BY clause with the SUM function example
SELECT
    order_id,
    SUM (
        quantity * list_price * (1 - discount)
    ) net_value
FROM
    sales.order_items
GROUP BY
    order_id;
--------------------------------------------------------
--SQL Server HAVING Clause
--SQL Server HAVING with the COUNT function example
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
-----------------------------------------
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
--------------------------------------------------
--SQL Server HAVING clause with MAX and MIN functions example
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
------------------------------------------------------
--SQL Server HAVING clause with AVG() function example
SELECT
    category_id,
    AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    AVG (list_price) BETWEEN 500 AND 1000;



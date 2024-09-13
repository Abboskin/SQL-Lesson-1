--SQL Server Subquery
--Introduction to SQL Server subquery

SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC;


SELECT
    customer_id
FROM
    sales.customers
WHERE
    city = 'New York'--Inner query

--Nesting subquery
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT
            AVG (list_price)
        FROM
            production.products
        WHERE
            brand_id IN (
                SELECT
                    brand_id
                FROM
                    production.brands
                WHERE
                    brand_name = 'Strider'
                OR brand_name = 'Trek'
            )
    )
ORDER BY
    list_price;

--SQL Server subquery types
--You can use a subquery in many places:

--In place of an expression
--With IN or NOT IN
--With ANY or ALL
--With EXISTS or NOT EXISTS
--In UPDATE, DELETE, orINSERT statement
--In the FROM clause

--SQL Server subquery is used in place of an expression
SELECT
    order_id,
    order_date,
    (
        SELECT
            MAX (list_price)
        FROM
            sales.order_items i
        WHERE
            i.order_id = o.order_id
    ) AS max_list_price
FROM
    sales.orders o
order by order_date desc;

--SQL Server subquery is used with IN operator

SELECT
    product_id,
    product_name
FROM
    production.products
WHERE
    category_id IN (
        SELECT
            category_id
        FROM
            production.categories
        WHERE
            category_name = 'Mountain Bikes'
        OR category_name = 'Road Bikes'
    );

--SQL Server subquery is used with ANY operator

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ANY (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )

--SQL Server subquery is used with ALL operator

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ALL (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )

--SQL Server subquery is used with EXISTS or NOT EXISTS

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sales.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
ORDER BY
    first_name,
    last_name;

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    sales.customers c
WHERE
    NOT EXISTS (
        SELECT
            customer_id
        FROM
            sales.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
ORDER BY
    first_name,
    last_name;

--SQL Server subquery in the FROM clause

SELECT 
   staff_id, 
   COUNT(order_id) order_count
FROM 
   sales.orders
GROUP BY 
   staff_id;

SELECT 
   AVG(order_count) average_order_count_by_staff
FROM
(
    SELECT 
	staff_id, 
        COUNT(order_id) order_count
    FROM 
	sales.orders
    GROUP BY 
	staff_id
) t;

--Introduction to the SQL Server correlated subquery

SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;

--SQL Server EXISTS operator examples
--A) Using EXISTS with a subquery returns NULL example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    EXISTS (SELECT NULL)
ORDER BY
    first_name,
    last_name;

--B) Using EXISTS with a correlated subquery example

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;

--C) EXISTS vs. IN example

SELECT
    *
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'San Jose'
    )
ORDER BY
    customer_id,
    order_date;

SELECT
    *
FROM
    sales.orders o
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sales.customers c
        WHERE
            o.customer_id = c.customer_id
        AND city = 'San Jose'
    )
ORDER BY
    o.customer_id,
    order_date;

--SQL Server ANY operator example

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;

--SQL Server ALL operator examples

SELECT
    AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    brand_id
ORDER BY
    avg_list_price;

--1) scalar_expression > ALL ( subquery )
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;

--2) scalar_expression < ALL ( subquery )
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price < all (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price DESC;

--Introduction to the SQL Server CROSS APPLY clause

SELECT
  c.category_name,
  r.product_name,
  r.list_price
FROM
  production.categories c
  CROSS APPLY (
    SELECT
      TOP 2 *
    FROM
      production.products p
    WHERE
      p.category_id = c.category_id
    ORDER BY
      list_price DESC,
      product_name
  ) r
ORDER BY
  c.category_name,
  r.list_price DESC;

--2) Using the CROSS APPLY clause to join a table with a table-valued function
CREATE FUNCTION GetTopProductsByCategory (@category_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP 2 *
    FROM production.products p
    WHERE p.category_id = @category_id 
    ORDER BY list_price DESC, product_name
);
SELECT
  c.category_name,
  r.product_name,
  r.list_price
FROM
  production.categories c
  CROSS APPLY GetTopProductsByCategory(c.category_id) r
ORDER BY
  c.category_name,
  r.list_price DESC;

SELECT
  c.category_name,
  r.product_name,
  r.list_price
FROM
  production.categories c
  CROSS APPLY GetTopProductsByCategory(c.category_id) r
ORDER BY
  c.category_name,
  r.list_price DESC;

--3) Using the CROSS APPLY clause to process JSON data
CREATE TABLE product_json(
    id INT IDENTITY PRIMARY KEY,
    info NVARCHAR(MAX)
);

INSERT INTO product_json(info)
VALUES 
    ('{"Name": "Laptop", "Price": 999, "Category": "Electronics"}'),
    ('{"Name": "Headphones", "Price": 99, "Category": "Electronics"}'),
    ('{"Name": "Book", "Price": 15, "Category": "Books"}');

SELECT
  p.id,
  j.*
FROM
  product_json p
  CROSS APPLY OPENJSON (p.info) WITH
  (
    Name NVARCHAR(100),
    Price DECIMAL(10, 2),
    Category NVARCHAR(100)
  ) AS j;

--4) Using the CROSS APPLY clause to remove the nested REPLACE() function

CREATE TABLE companies(
   id INT IDENTITY PRIMARY KEY,
   name VARCHAR(255) NOT NULL
);

INSERT INTO
  companies (name)
VALUES
  ('ABC Corporation'),
  ('XYZ Inc.'),
  ('JK Pte Ltd');

SELECT TRIM(REPLACE(REPLACE(REPLACE(name,'Corporation',''), 'Inc.',''),'Pte Ltd','')) company_name
FROM companies;

SELECT TRIM(r3.name) company_name
FROM companies c
CROSS APPLY (SELECT REPLACE(c.name,'Corporation', '') name) AS r1 
CROSS APPLY (SELECT REPLACE(r1.name,'Inc.', '') name) AS r2
CROSS APPLY (SELECT REPLACE(r2.name,'Pte Ltd', '') name) AS r3;

--Introduction to the SQL Server OUTER APPLY clause

--1) Using the SQL Server OUTER APPLY clause to join a table with a correlated subquery

SELECT
  p.product_name,
  r.quantity,
  r.discount
FROM
  production.products p OUTER apply (
    SELECT
      top 1 i.*
    FROM
      sales.order_items i
      INNER JOIN sales.orders o ON o.order_id = i.order_id
    WHERE
      product_id = p.product_id
    ORDER BY
      order_date DESC
  ) r
WHERE
  p.brand_id = 1
ORDER BY
  r.quantity;

--2) Using the OUTER APPLY clause to join a table with a table-valued function

CREATE FUNCTION GetLatestQuantityDiscount (@product_id INT) 
RETURNS TABLE 
AS RETURN (
  SELECT
    TOP 1 i.*
  FROM
    sales.order_items i
    INNER JOIN sales.orders o ON o.order_id = i.order_id
  WHERE
    product_id = @product_id
  ORDER BY
    order_date DESC
);

SELECT
  p.product_name,
  r.quantity,
  r.discount
FROM
  production.products p 
OUTER APPLY GetLatestQuantityDiscount(p.product_id) r
WHERE
  p.brand_id = 1
ORDER BY
  r.quantity;

----SQL Server CTE

--A) Simple SQL Server CTE example
WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)

SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;

--B) Using a common table expression to make report averages based on counts

WITH cte_sales AS (
    SELECT 
        staff_id, 
        COUNT(*) order_count  
    FROM
        sales.orders
    WHERE 
        YEAR(order_date) = 2018
    GROUP BY
        staff_id

)
SELECT
    AVG(order_count) average_orders_by_staff
FROM 
    cte_sales;

--C) Using multiple SQL Server CTE in a single query example
WITH cte_category_counts (
    category_id, 
    category_name, 
    product_count
)
AS (
    SELECT 
        c.category_id, 
        c.category_name, 
        COUNT(p.product_id)
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
    GROUP BY 
        c.category_id, 
        c.category_name
),
cte_category_sales(category_id, sales) AS (
    SELECT    
        p.category_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount))
    FROM    
        sales.order_items i
        INNER JOIN production.products p 
            ON p.product_id = i.product_id
        INNER JOIN sales.orders o 
            ON o.order_id = i.order_id
    WHERE order_status = 4 -- completed
    GROUP BY 
        p.category_id
) 

SELECT 
    c.category_id, 
    c.category_name, 
    c.product_count, 
    s.sales
FROM
    cte_category_counts c
    INNER JOIN cte_category_sales s 
        ON s.category_id = c.category_id
ORDER BY 
    c.category_name;

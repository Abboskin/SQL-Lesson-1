--Section 14. Constraints
--SQL Server PRIMARY KEY

CREATE TABLE sales.activities (
    activity_id INT PRIMARY KEY IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
);

CREATE TABLE sales.participants(
    activity_id int,
    customer_id int,
    PRIMARY KEY(activity_id, customer_id)
);

CREATE TABLE sales.events(
    event_id INT NOT NULL,
    event_name VARCHAR(255),
    start_date DATE NOT NULL,
    duration DEC(5,2)
);

ALTER TABLE sales.events 
ADD PRIMARY KEY(event_id);

--SQL Server FOREIGN KEY
CREATE TABLE procurement.vendor_groups (
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (100) NOT NULL
);

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
);

DROP TABLE vendors;

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
);

INSERT INTO procurement.vendor_groups(group_name)
VALUES('Third-Party Vendors'),
      ('Interco Vendors'),
      ('One-time Vendors');

INSERT INTO procurement.vendors(vendor_name, group_id)
VALUES('ABC Corp',1);

INSERT INTO procurement.vendors(vendor_name, group_id)
VALUES('XYZ Corp',4);

SELECT * FROM procurement.vendor_groups
SELECT * FROM procurement.vendors

--SQL Server CHECK Constraint

CREATE SCHEMA test;
GO

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CONSTRAINT positive_price CHECK(unit_price > 0)
);

INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', 0);
INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Bike', 599);

INSERT INTO test.products(product_name, unit_price)
VALUES ('Another Awesome Bike', NULL);

DROP TABLE test.products
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0),
    discounted_price DEC(10,2) CHECK(discounted_price > 0),
    CHECK(discounted_price < unit_price)
);

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CHECK(discounted_price > unit_price)
);

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0 AND discounted_price > unit_price)
);

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CONSTRAINT valid_prices CHECK(discounted_price > unit_price)
);

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) NOT NULL
);

ALTER TABLE test.products
ADD CONSTRAINT positive_price CHECK(unit_price > 0);

ALTER TABLE test.products
ADD discounted_price DEC(10,2)
CHECK(discounted_price > 0);

ALTER TABLE test.products
ADD CONSTRAINT valid_price 
CHECK(unit_price > discounted_price);

EXEC sp_help 'test.products';

ALTER TABLE test.products
DROP CONSTRAINT positive_price;
ALTER TABLE test.products
NOCHECK CONSTRAINT valid_price;

--SQL Server NOT NULL Constraint

CREATE SCHEMA hr;
GO

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

UPDATE hr.persons
SET phone = '(408) 123 4567'
WHERE phone IS NULL;
ALTER TABLE hr.persons
ALTER COLUMN phone VARCHAR(20) NOT NULL;

ALTER TABLE hr.peRsons
ALTER COLUMN phone VARCHAR(20) NULL;

------------------------------------------------
--Section 15. Expressions
--SQL Server CASE
SELECT    
    order_status, 
    COUNT(order_id) order_count
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    order_status;

SELECT    
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status, 
    COUNT(order_id) order_count
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    order_status;

SELECT    
    SUM(CASE
            WHEN order_status = 1
            THEN 1
            ELSE 0
        END) AS 'Pending', 
    SUM(CASE
            WHEN order_status = 2
            THEN 1
            ELSE 0
        END) AS 'Processing', 
    SUM(CASE
            WHEN order_status = 3
            THEN 1
            ELSE 0
        END) AS 'Rejected', 
    SUM(CASE
            WHEN order_status = 4
            THEN 1
            ELSE 0
        END) AS 'Completed', 
    COUNT(*) AS Total
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018;


SELECT    
    o.order_id, 
    SUM(quantity * list_price) order_value,
    CASE
        WHEN SUM(quantity * list_price) <= 500 
            THEN 'Very Low'
        WHEN SUM(quantity * list_price) > 500 AND 
            SUM(quantity * list_price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * list_price) > 1000 AND 
            SUM(quantity * list_price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * list_price) > 5000 AND 
            SUM(quantity * list_price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * list_price) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    sales.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    o.order_id;

--SQL Server COALESCE

SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;

SELECT 
    COALESCE(NULL, NULL, 100, 200) result;

SELECT 
    first_name, 
    last_name, 
    phone, 
    email
FROM 
    sales.customers
ORDER BY 
    first_name, 
    last_name;

SELECT 
    first_name, 
    last_name, 
    COALESCE(phone,'N/A') phone, 
    email
FROM 
    sales.customers
ORDER BY 
    first_name, 
    last_name;

CREATE TABLE salaries (
    staff_id INT PRIMARY KEY,
    hourly_rate decimal,
    weekly_rate decimal,
    monthly_rate decimal,
    CHECK(
        hourly_rate IS NOT NULL OR 
        weekly_rate IS NOT NULL OR 
        monthly_rate IS NOT NULL)
);

INSERT INTO 
    salaries(
        staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
VALUES
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500);

SELECT
    staff_id, 
    hourly_rate, 
    weekly_rate, 
    monthly_rate
FROM
    salaries
ORDER BY
    staff_id;

SELECT
    staff_id,
    COALESCE(
        hourly_rate*22*8, 
        weekly_rate*4, 
        monthly_rate
    ) monthly_salary
FROM
    salaries;

--SQL Server NULLIF

SELECT 
    NULLIF(10, 10) result;

SELECT 
    NULLIF(20, 10) result;

SELECT 
    NULLIF('Hello', 'Hello') result;

SELECT 
    NULLIF('Hello', 'Hi') result;

CREATE TABLE sales.leads
(
    lead_id    INT	PRIMARY KEY IDENTITY, 
    first_name VARCHAR(100) NOT NULL, 
    last_name  VARCHAR(100) NOT NULL, 
    phone      VARCHAR(20), 
    email      VARCHAR(255) NOT NULL
);

INSERT INTO sales.leads
(
    first_name, 
    last_name, 
    phone, 
    email
)
VALUES
(
    'John', 
    'Doe', 
    '(408)-987-2345', 
    'john.doe@example.com'
),
(
    'Jane', 
    'Doe', 
    '', 
    'jane.doe@example.com'
),
(
    'David', 
    'Doe', 
    NULL, 
    'david.doe@example.com'
);

SELECT 
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM 
    sales.leads
ORDER BY
    lead_id;

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM    
    sales.leads
WHERE 
    phone IS NULL;

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM    
    sales.leads
WHERE 
    NULLIF(phone,'') IS NULL;

DECLARE @a int = 10, @b int = 20;
SELECT
    CASE
        WHEN @a = @b THEN null
        ELSE 
            @a
    END AS result;

-------------------------------------------------------
--Section 16. Useful Tips
--Find Duplicates From a Table in SQL Server
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
    id INT IDENTITY(1, 1), 
    a  INT, 
    b  INT, 
    PRIMARY KEY(id)
);

INSERT INTO
    t1(a,b)
VALUES
    (1,1),
    (1,2),
    (1,3),
    (2,1),
    (1,2),
    (1,3),
    (2,1),
    (2,2);

SELECT 
    a, 
    b, 
    COUNT(*) occurrences
FROM t1
GROUP BY
    a, 
    b
HAVING 
    COUNT(*) > 1;

WITH cte AS (
    SELECT
        a, 
        b, 
        COUNT(*) occurrences
    FROM t1
    GROUP BY 
        a, 
        b
    HAVING 
        COUNT(*) > 1
)
SELECT 
    t1.id, 
    t1.a, 
    t1.b
FROM t1
    INNER JOIN cte ON 
        cte.a = t1.a AND 
        cte.b = t1.b
ORDER BY 
    t1.a, 
    t1.b;

--SELECT 
--    col, 
--    COUNT(col)
--FROM 
--    table_name
--GROUP BY 
--    col
--HAVING 
--    COUNT(col) > 1;

WITH cte AS (
    SELECT 
        a, 
        b, 
        ROW_NUMBER() OVER (
            PARTITION BY a,b
            ORDER BY a,b) rownum
    FROM 
        t1
) 
SELECT 
  * 
FROM 
    cte 
WHERE 
    rownum > 1;

--Delete Duplicates From a Table in SQL Server
DROP TABLE IF EXISTS sales.contacts;

CREATE TABLE sales.contacts(
    contact_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL,
);

INSERT INTO sales.contacts
    (first_name,last_name,email) 
VALUES
    ('Syed','Abbas','syed.abbas@example.com'),
    ('Catherine','Abel','catherine.abel@example.com'),
    ('Kim','Abercrombie','kim.abercrombie@example.com'),
    ('Kim','Abercrombie','kim.abercrombie@example.com'),
    ('Kim','Abercrombie','kim.abercrombie@example.com'),
    ('Hazem','Abolrous','hazem.abolrous@example.com'),
    ('Hazem','Abolrous','hazem.abolrous@example.com'),
    ('Humberto','Acevedo','humberto.acevedo@example.com'),
    ('Humberto','Acevedo','humberto.acevedo@example.com'),
    ('Pilar','Ackerman','pilar.ackerman@example.com');

SELECT 
   contact_id, 
   first_name, 
   last_name, 
   email
FROM 
   sales.contacts;

WITH cte AS (
    SELECT 
        contact_id, 
        first_name, 
        last_name, 
        email, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                first_name, 
                last_name, 
                email
            ORDER BY 
                first_name, 
                last_name, 
                email
        ) row_num
     FROM 
        sales.contacts
)
DELETE FROM cte
WHERE row_num > 1;

SELECT contact_id, 
       first_name, 
       last_name, 
       email
FROM sales.contacts
ORDER BY first_name, 
         last_name, 
         email;


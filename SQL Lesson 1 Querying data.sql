--Basic SQL Select Statement 

SELECT
    first_name,
    last_name,
    email
FROM
    sales.customers;

--Using the SQL Server SELECT to retrieve all columns of a table

SELECT * FROM sales.customers;

--Filtering rows using the WHERE clause

SELECT
    *
FROM
    sales.customers
WHERE
    state = 'CA';

--Sorting rows using the ORDER BY clause

SELECT
    *
FROM
    sales.customers
WHERE
    state = 'CA'
ORDER BY
    first_name;

--Grouping rows into groups

SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
ORDER BY
    city;

--Filtering groups using the HAVING clause

SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
HAVING
    COUNT (*) > 10
ORDER BY
    city;



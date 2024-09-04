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



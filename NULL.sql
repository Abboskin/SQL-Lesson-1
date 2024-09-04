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



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



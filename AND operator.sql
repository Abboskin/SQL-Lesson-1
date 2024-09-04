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
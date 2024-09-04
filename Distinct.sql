--Distinct 

--Using the SELECT DISTINCT with one column
SELECT 
  city 
FROM 
  sales.customers 
ORDER BY 
  city;
--Один несколько раз 
SELECT 
  DISTINCT city 
FROM 
  sales.customers 
ORDER BY 
  city;
--Каждый по одному разу 

--Using SELECT DISTINCT with multiple columns

SELECT 
  city, 
  state 
FROM 
  sales.customers 
ORDER BY 
  city, 
  state;

SELECT 
  DISTINCT city, state 
FROM 
  sales.customers

--Using SELECT DISTINCT with NULL

SELECT 
  DISTINCT phone 
FROM 
  sales.customers 
ORDER BY 
  phone;

--Будет только один NULL

--DISTINCT vs. GROUP BY

SELECT 
  city, 
  state, 
  zip_code 
FROM 
  sales.customers 
GROUP BY 
  city, 
  state, 
  zip_code 
ORDER BY 
  city, 
  state, 
  zip_code

--То же самое что...
SELECT 
  DISTINCT city, state, zip_code 
FROM 
  sales.customers;


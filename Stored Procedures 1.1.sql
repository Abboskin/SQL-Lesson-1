--A Basic Guide to SQL Server Stored Procedures

--Creating a simple stored procedure
SELECT 
	product_name, 
	list_price
FROM 
	production.products
ORDER BY 
	product_name;

CREATE PROCEDURE uspProductList
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM 
        production.products
    ORDER BY 
        product_name;
END

EXEC uspProductList;
--------------------------------------------------
ALTER PROCEDURE uspProductList
   AS
   BEGIN
       SELECT 
           product_name, 
           list_price
       FROM 
           production.products
       ORDER BY 
           list_price 
   END;


------Deleting a stored procedure---------
DROP PROCEDURE uspProductList;

--SQL Server Stored Procedure Parameters
--Creating a stored procedure with one parameter

SELECT
    product_name,
    list_price
FROM 
    production.products
ORDER BY
    list_price;

CREATE PROCEDURE uspFindProducts
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    ORDER BY
        list_price;
END;

exec uspFindProducts 100

ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price
    ORDER BY
        list_price;
END;

--Creating a stored procedure with multiple parameters
ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL
    ,@max_list_price AS DECIMAL
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price
    ORDER BY
        list_price;
END;

EXECUTE uspFindProducts 900, 1000;

--Using named parameters

EXECUTE uspFindProducts 
    @min_list_price = 900, 
    @max_list_price = 1000;

--Creating text parameters

ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL
    ,@max_list_price AS DECIMAL
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;

EXECUTE uspFindProducts 
    @min_list_price = 900, 
    @max_list_price = 1000,
    @name = 'Trek';

--Creating optional parameters
ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL = 0
    ,@max_list_price AS DECIMAL = 999999
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;
EXECUTE uspFindProducts 
    @name = 'Trek';

EXECUTE uspFindProducts 
    @min_list_price = 6000,
    @name = 'Trek';

--Using NULL as the default value
ALTER PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL = 0
    ,@max_list_price AS DECIMAL = NULL
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        (@max_list_price IS NULL OR list_price <= @max_list_price) AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;

EXECUTE uspFindProducts 
    @min_list_price = 500,
    @name = 'Haro';


-----------------------------------------------------------------------------
--Variables

--We typically use variables in the following cases:
--As a loop counter to count the number of times a loop is performed.
--To hold a value to be tested by a control-of-flow statement such as WHILE.
--To store the value returned by a stored procedure or a function

--Declaring a variable

--DECLARE @model_year AS SMALLINT;
--DECLARE @model_year SMALLINT, 
--        @product_name VARCHAR(MAX);

DECLARE @model_year SMALLINT;
SET @model_year = 2018;
SELECT
    product_name,
    model_year,
    list_price 
FROM 
    production.products
WHERE 
    model_year = @model_year
ORDER BY
    product_name;

--Storing query result in a variable
DECLARE @product_count INT;
SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        production.products 
);
--SELECT @product_count;
PRINT @product_count;
--PRINT 'The number of products is ' + CAST(@product_count AS VARCHAR(MAX));

SET NOCOUNT ON;    

--Selecting a record into variables
DECLARE 
    @product_name VARCHAR(MAX),
    @list_price DECIMAL(10,2);

SELECT 
    @product_name = product_name,
    @list_price = list_price
FROM
    production.products
WHERE
    product_id = 100;

SELECT 
    @product_name AS product_name, 
    @list_price AS list_price;

--Accumulating values into a variable
CREATE  PROC uspGetProductList(
    @model_year SMALLINT
) AS 
BEGIN
    DECLARE @product_list VARCHAR(MAX);

    SET @product_list = '';

    SELECT
        @product_list = @product_list + product_name 
                        + CHAR(10)
    FROM 
        production.products
    WHERE
        model_year = @model_year
    ORDER BY 
        product_name;

    PRINT @product_list;
END;

EXEC uspGetProductList 2018
------------------------------------------------------------------------
--Stored Procedure Output Parameters
--parameter_name data_type OUTPUT

CREATE PROCEDURE uspFindProductByModel (
    @model_year SMALLINT,
    @product_count INT OUTPUT
) AS
BEGIN
    SELECT 
        product_name,
        list_price
    FROM
        production.products
    WHERE
        model_year = @model_year;

    SELECT @product_count = @@ROWCOUNT;
END;

--Calling stored procedures with output parameters
DECLARE @count INT;

EXEC uspFindProductByModel
    @model_year = 2018,
    @product_count = @count OUTPUT;

SELECT @count AS 'Number of products found';
EXEC uspFindProductByModel 2018, @count OUTPUT;











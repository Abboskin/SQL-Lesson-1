--SQL Server Views
SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

CREATE VIEW sales.product_info
AS
SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

SELECT * FROM sales.product_info;

SELECT 
    *
FROM (
    SELECT
        product_name, 
        brand_name, 
        list_price
    FROM
        production.products p
    INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id)

--SQL Server CREATE VIEW

CREATE VIEW sales.daily_sales
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.list_price AS sales
FROM
    sales.orders AS o
INNER JOIN sales.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN production.products AS p
    ON p.product_id = i.product_id;

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY
    y, m, d, product_name;

CREATE OR ALTER VIEW sales.daily_sales (
    year,
    month,
    day,
    customer_name,
    product_id,
    product_name,
    sales
)
AS
SELECT
    year(order_date),
    month(order_date),
    day(order_date),
    concat(
        first_name,
        ' ',
        last_name
    ),
    p.product_id,
    product_name,
    quantity * i.list_price
FROM
    sales.orders AS o
    INNER JOIN
        sales.order_items AS i
    ON o.order_id = i.order_id
    INNER JOIN
        production.products AS p
    ON p.product_id = i.product_id
    INNER JOIN sales.customers AS c
    ON c.customer_id = o.customer_id;

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY 
    year, 
    month, 
    day, 
    customer_name;

CREATE VIEW sales.staff_sales (
        first_name, 
        last_name,
        year, 
        amount
)
AS 
    SELECT 
        first_name,
        last_name,
        YEAR(order_date),
        SUM(list_price * quantity) amount
    FROM
        sales.order_items i
    INNER JOIN sales.orders o
        ON i.order_id = o.order_id
    INNER JOIN sales.staffs s
        ON s.staff_id = o.staff_id
    GROUP BY 
        first_name, 
        last_name, 
        YEAR(order_date);

SELECT  
    * 
FROM 
    sales.staff_sales
ORDER BY 
	first_name,
	last_name,
	year;

--SQL Server DROP VIEW
CREATE VIEW sales.product_catalog
AS
SELECT 
    product_name, 
    category_name, 
	brand_name,
    list_price
FROM 
    production.products p
INNER JOIN production.categories c 
    ON c.category_id = p.category_id
INNER JOIN production.brands b
	ON b.brand_id = p.brand_id;

DROP VIEW IF EXISTS 
    sales.staff_sales, 
    sales.product_catalogs;

--SQL Server Rename View
--To rename the name of a view you follow these steps:
--First, in Object Explorer, expand the Databases, 
--choose the database name which contains the view that you want to rename and expand the Views folder.
--Second, right-click the view that you want to rename and select Rename.

EXEC sp_rename 
    @objname = 'sales.product_catalog',
    @newname = 'product_list';

--SQL Server List Views

SELECT 
	OBJECT_SCHEMA_NAME(o.object_id) schema_name,
	o.name
FROM
	sys.objects as o
WHERE
	o.type = 'V';

CREATE PROC usp_list_views(
	@schema_name AS VARCHAR(MAX)  = NULL,
	@view_name AS VARCHAR(MAX) = NULL
)
AS
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name view_name
FROM 
	sys.views as v
WHERE 
	(@schema_name IS NULL OR 
	OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') AND
	(@view_name IS NULL OR
	v.name LIKE '%' + @view_name + '%');

EXEC usp_list_views @view_name = 'sales'

SELECT
    definition,
    uses_ansi_nulls,
    uses_quoted_identifier,
    is_schema_bound
FROM
    sys.sql_modules
WHERE
    object_id
    = object_id(
            'sales.daily_sales'
        );

EXEC sp_helptext 'sales.product_catalog' ;

SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'sales.staff_sales'
        )
    ) view_info;

--SQL Server Indexed View
CREATE VIEW production.product_master
WITH SCHEMABINDING
AS 
SELECT
    product_id,
    product_name,
    model_year,
    list_price,
    brand_name,
    category_name
FROM
    production.products p
INNER JOIN production.brands b 
    ON b.brand_id = p.brand_id
INNER JOIN production.categories c 
    ON c.category_id = p.category_id;

SET STATISTICS IO ON
GO

SELECT 
    * 
FROM
    production.product_master
ORDER BY
    product_name;
GO 
SET STATISTICS IO ON
GO

SELECT 
    * 
FROM
    production.product_master
ORDER BY
    product_name;
GO 

CREATE UNIQUE CLUSTERED INDEX 
    ucidx_product_id 
ON production.product_master(product_id);

CREATE NONCLUSTERED INDEX 
    ucidx_product_name
ON production.product_master(product_name);

SELECT * 
FROM production.product_master 
   WITH (NOEXPAND)
ORDER BY product_name;




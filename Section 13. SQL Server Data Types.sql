--Section 13. SQL Server Data Types
--SQL Server INT

--BIGINT	-263 (-9,223,372,036,854,775,808) to 263-1 (9,223,372,036,854,775,807)	8 Bytes
--INT	-231 (-2,147,483,648) to 231-1 (2,147,483,647)	4 Bytes
--SMALLINT	-215 (-32,768) to 215-1 (32,767)	2 Bytes
--TINYINT	0 to 255	1 Byte
CREATE SCHEMA test

CREATE TABLE test.sql_server_integers (
	bigint_col bigint,
	int_col INT,
	smallint_col SMALLINT,
	tinyint_col tinyint
);

INSERT INTO test.sql_server_integers (
	bigint_col,
	int_col,
	smallint_col,
	tinyint_col
)
VALUES
	(
		9223372036854775807,
		2147483647,
		32767,
		255
	);

SELECT
	bigint_col,
	int_col,
	smallint_col,
	tinyint_col
FROM
	test.sql_server_integers;

SELECT 2147483647 / 3 AS r1, 
	   2147483649 / 3 AS r2;

--SQL Server Decimal
CREATE TABLE test.sql_server_decimal (
    dec_col DECIMAL (4, 2),
    num_col NUMERIC (4, 2)
);
INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES
    (10.05, 20.05);

SELECT
    dec_col,
    num_col
FROM
    test.sql_server_decimal;

INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES
    (99.999, 12.345);

--SQL Server BIT
CREATE TABLE test.sql_server_bit (
    bit_col BIT
);
INSERT INTO test.sql_server_bit (bit_col)
OUTPUT inserted.bit_col
VALUES(1);

INSERT INTO test.sql_server_bit (bit_col)
OUTPUT inserted.bit_col
VALUES(0);

INSERT INTO test.sql_server_bit (bit_col)
OUTPUT inserted.bit_col
VALUES
    ('True');
INSERT INTO test.sql_server_bit (bit_col)
OUTPUT inserted.bit_col
VALUES
    ('False');
INSERT INTO test.sql_server_bit (bit_col)
OUTPUT inserted.bit_col
VALUES
    (0.5); 

--SQL Server CHAR Data Type
CREATE TABLE test.sql_server_char (
    val CHAR(3)
);

INSERT INTO test.sql_server_char (val)
VALUES
    ('ABC');
INSERT INTO test.sql_server_char (val)
VALUES
    ('XYZ1');
INSERT INTO test.sql_server_char (val)
VALUES
    ('A');
SELECT
    val,
    LEN(val) len,
    DATALENGTH(val) data_length
FROM
    sql_server_char;

--SQL Server NCHAR
CREATE TABLE test.sql_server_nchar (
    val NCHAR(1) NOT NULL
);
INSERT INTO test.sql_server_nchar (val)
VALUES
    (N'あ');
INSERT INTO test.sql_server_nchar (val)
VALUES
    (N'いえ'); 
SELECT
    val,
    len(val) length,
    DATALENGTH(val) data_length
FROM
    test.sql_server_nchar;

--SQL Server VARCHAR
CREATE TABLE test.sql_server_varchar (
    val VARCHAR NOT NULL
);
ALTER TABLE test.sql_server_varchar 
ALTER COLUMN val VARCHAR (10) NOT NULL;
INSERT INTO test.sql_server_varchar (val)
VALUES
    ('SQL Server');
INSERT INTO test.sql_server_varchar (val)
VALUES
    ('SQL Server VARCHAR');

SELECT
    val,
    LEN(val) len,
    DATALENGTH(val) data_length
FROM
    test.sql_server_varchar;

--SQL Server NVARCHAR
CREATE TABLE test.sql_server_nvarchar (
    val NVARCHAR NOT NULL
);

ALTER TABLE test.sql_server_Nvarchar 
ALTER COLUMN val NVARCHAR (10) NOT NULL;

INSERT INTO test.sql_server_varchar (val)
VALUES
    (N'こんにちは');

INSERT INTO test.sql_server_nvarchar (val)
VALUES
    (N'ありがとうございました');

SELECT
    val,
    LEN(val) len,
    DATALENGTH(val) data_length
FROM
    test.sql_server_Nvarchar;

--SQL Server DATETIME2
--YYYY-MM-DD hh:mm:ss[.fractional seconds]
CREATE SCHEMA production
CREATE TABLE production.product_colors (
    color_id INT PRIMARY KEY IDENTITY,
    color_name VARCHAR (50) NOT NULL,
    created_at DATETIME2
);
INSERT INTO production.product_colors (color_name, created_at)
VALUES
    ('Red', GETDATE()); 
INSERT INTO production.product_colors (color_name, created_at)
VALUES
    ('Green', '2018-06-23 07:30:20');

ALTER TABLE production.product_colors 
ADD CONSTRAINT df_current_time 
DEFAULT CURRENT_TIMESTAMP FOR created_at;
INSERT INTO production.product_colors (color_name)
VALUES
    ('Blue');
SELECT * FROM production.product_colors

--SQL Server DATE
SELECT    
	order_id, 
	customer_id, 
	order_status, 
	order_date
FROM    
	sales.orders
WHERE order_date < '2016-01-05'
ORDER BY 
	order_date DESC;

CREATE TABLE sales.list_prices (
    product_id INT NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    amount DEC (10, 2) NOT NULL,
    PRIMARY KEY (
        product_id,
        valid_from,
        valid_to
    ),
    FOREIGN KEY (product_id) 
      REFERENCES production.products (product_id)
);
INSERT INTO sales.list_prices (
    product_id,
    valid_from,
    valid_to,
    amount
)
VALUES
    (
        1,
        '2019-01-01',
        '2019-12-31',
        400
    );
SELECT * FROM sales.list_prices

--SQL Server TIME
DROP TABLE IF EXISTS sales.visits
CREATE TABLE sales.visits (
    visit_id INT PRIMARY KEY IDENTITY,
    customer_name VARCHAR (50) NOT NULL,
    phone VARCHAR (25),
    store_id INT NOT NULL,
    visit_on DATE NOT NULL,
    start_at TIME (0) NOT NULL,
    end_at TIME (0) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);

INSERT INTO sales.visits (
    customer_name,
    phone,
    store_id,
    visit_on,
    start_at,
    end_at
)
VALUES
    (
        'John Doe',
        '(408)-993-3853',
        1,
        '2018-06-23',
        '09:10:00',
        '09:30:00'
    );

SELECT * FROM sales.visits

--SQL Server DATETIMEOFFSET
DECLARE @dt DATETIMEOFFSET(7)
CREATE TABLE messages(
    id         INT PRIMARY KEY IDENTITY, 
    message    VARCHAR(255) NOT NULL, 
    created_at DATETIMEOFFSET NOT NULL
);

INSERT INTO messages(message,created_at)
VALUES('DATETIMEOFFSET demo',
        CAST('2019-02-28 01:45:00.0000000 -08:00' AS DATETIMEOFFSET));

SELECT 
    id, 
    message, 
	created_at 
        AS 'Pacific Standard Time',
    created_at AT TIME ZONE 'SE Asia Standard Time' 
        AS 'SE Asia Standard Time'
FROM 
    messages;

--SQL Server GUID
SELECT 
    NEWID() AS GUID;

DECLARE 
    @id UNIQUEIDENTIFIER;

SET @id = NEWID();

SELECT 
    @id AS GUID;

CREATE SCHEMA marketing;
GO

CREATE TABLE marketing.customers(
    customer_id UNIQUEIDENTIFIER DEFAULT NEWID(),
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL
);
GO

INSERT INTO 
    marketing.customers(first_name, last_name, email)
VALUES
    ('John','Doe','john.doe@example.com'),
    ('Jane','Doe','jane.doe@example.com');

SELECT 
    customer_id, 
    first_name, 
    last_name, 
    email
FROM 
    marketing.customers;


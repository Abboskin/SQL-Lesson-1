--SQL Server Stored Procedures
--SQL Server CURSOR

--What is a database cursor
--A database cursor is an object that enables traversal over the rows of a result set.
--It allows you to process individual row returned by a query.

DECLARE 
    @product_name VARCHAR(MAX), 
    @list_price   DECIMAL;

DECLARE cursor_product CURSOR
FOR SELECT 
        product_name, 
        list_price
    FROM 
        production.products;

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @product_name, 
    @list_price;

WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @product_name + CAST(@list_price AS varchar);
        FETCH NEXT FROM cursor_product INTO 
            @product_name, 
            @list_price;
    END;

CLOSE cursor_product;

DEALLOCATE cursor_product;

--------------------------------------------------------------
--Section 4. Handling Exceptions
--SQL Server TRY CATCH
CREATE PROC usp_divide(
    @a decimal,
    @b decimal,
    @c decimal output
) AS
BEGIN
    BEGIN TRY
        SET @c = @a / @b;
    END TRY
    BEGIN CATCH
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH
END;
GO
DECLARE @r decimal;
EXEC usp_divide 10, 2, @r output;
PRINT @r;

DECLARE @r2 decimal;
EXEC usp_divide 10, 0, @r2 output;
PRINT @r2;

--SQL Serer TRY CATCH with transactions
CREATE TABLE sales.persons
(
    person_id  INT
    PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL
);

CREATE TABLE sales.deals
(
    deal_id   INT
    PRIMARY KEY IDENTITY, 
    person_id INT NOT NULL, 
    deal_note NVARCHAR(100), 
    FOREIGN KEY(person_id) REFERENCES sales.persons(
    person_id)
);

insert into 
    sales.persons(first_name, last_name)
values
    ('John','Doe'),
    ('Jane','Doe');

insert into 
    sales.deals(person_id, deal_note)
values
    (1,'Deal for John Doe');

CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO

CREATE PROC usp_delete_person(
    @person_id INT
) AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM sales.persons 
        WHERE person_id = @person_id;
        COMMIT TRANSACTION;  
    END TRY
    BEGIN CATCH
        EXEC usp_report_error;
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  
    END CATCH
END;
GO
EXEC usp_delete_person 2;
EXEC usp_delete_person 1;

---------------------------------------------------------------
--SQL Server RAISERROR
EXEC sp_addmessage 
    @msgnum = 50005, 
    @severity = 1, 
    @msgtext = 'A custom error message';


SELECT    
    *
FROM    
    sys.messages
WHERE 
    message_id = 50005;

RAISERROR ( 50005,1,1)

EXEC sp_dropmessage 
    @msgnum = 50005;  

RAISERROR ( 'Whoops, an error occurred.',1,1)

--SQL Server RAISERROR examples
--A) Using SQL Server RAISERROR with TRY CATCH block example
DECLARE 
    @ErrorMessage  NVARCHAR(4000), 
    @ErrorSeverity INT, 
    @ErrorState    INT;

BEGIN TRY
    RAISERROR('Error occurred in the TRY block.', 17, 1);
END TRY
BEGIN CATCH
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(), 
        @ErrorSeverity = ERROR_SEVERITY(), 
        @ErrorState = ERROR_STATE();

    -- return the error inside the CATCH block
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;

--B) Using SQL Server RAISERROR statement with a dynamic message text example
DECLARE @MessageText NVARCHAR(100);
SET @MessageText = N'Cannot delete the sales order %s';

RAISERROR(
    @MessageText, -- Message text
    16, -- severity
    1, -- state
    N'2001' -- first argument to the message text
);

---------------------------------------------------------------------
--SQL Server THROW
THROW 50005, N'An error occurred', 1;

--B) Using THROW statement to rethrow an exception
CREATE TABLE t1(
    id int primary key
);
GO
BEGIN TRY
    INSERT INTO t1(id) VALUES(1);
    --  cause error
    INSERT INTO t1(id) VALUES(1);
END TRY
BEGIN CATCH
    PRINT('Raise the caught error again');
    THROW;
END CATCH

--C) Using THROW statement to rethrow an exception
EXEC sys.sp_addmessage 
    @msgnum = 50010, 
    @severity = 16, 
    @msgtext =
    N'The order number %s cannot be deleted because it does not exist.', 
    @lang = 'us_english';   
GO

DECLARE @MessageText NVARCHAR(2048);
SET @MessageText =  FORMATMESSAGE(50010, N'1001');   

THROW 50010, @MessageText, 1; 

------------------------------------------------------------------------------
--SQL Server Dynamic SQL
EXEC sp_executesql N'SELECT * FROM production.products';

--Using dynamic SQL to query from any table example
DECLARE 
    @table NVARCHAR(128),
    @sql NVARCHAR(MAX);

SET @table = N'production.products';

SET @sql = N'SELECT * FROM ' + @table;

EXEC sp_executesql @sql;
SELECT * FROM production.products;

--SQL Server dynamic SQL and stored procedures
CREATE PROC usp_query (
    @table NVARCHAR(128)
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'SELECT * FROM ' + @table;
    EXEC sp_executesql @sql;   
END;

EXEC usp_query 'production.brands';

CREATE OR ALTER PROC usp_query_topn(
    @table NVARCHAR(128),
    @topN INT,
    @byColumn NVARCHAR(128)
)
AS
BEGIN
    DECLARE 
        @sql NVARCHAR(MAX),
        @topNStr NVARCHAR(MAX);

    SET @topNStr  = CAST(@topN as nvarchar(max));
    SET @sql = N'SELECT TOP ' +  @topNStr  + 
                ' * FROM ' + @table + 
                    ' ORDER BY ' + @byColumn + ' DESC';
    EXEC sp_executesql @sql;
    
END;

EXEC usp_query_topn 
        'production.products',
        10, 
        'list_price';

EXEC usp_query_topn 
        'production.stocks',
        10, 
        'quantity';

--SQL Server Dynamic SQL and SQL Injection
CREATE TABLE sales.tests(id INT); 
EXEC usp_query 'production.brands';
EXEC usp_query 'production.brands;DROP TABLE sales.tests';

CREATE OR ALTER PROC usp_query
(
    @schema NVARCHAR(128), 
    @table  NVARCHAR(128)
)
AS
    BEGIN
        DECLARE 
            @sql NVARCHAR(MAX);
        -- construct SQL
        SET @sql = N'SELECT * FROM ' 
            + QUOTENAME(@schema) 
            + '.' 
            + QUOTENAME(@table);
        -- execute the SQL
        EXEC sp_executesql @sql;
    END;

EXEC usp_query 'production','brands';
EXEC usp_query 
        'production',
        'brands;DROP TABLE sales.tests';

--More on sp_executesql stored procedure
EXEC sp_executesql
N'SELECT *
    FROM 
        production.products 
    WHERE 
        list_price> @listPrice AND
        category_id = @categoryId
    ORDER BY
        list_price DESC', 
N'@listPrice DECIMAL(10,2),
@categoryId INT'
,@listPrice = 100
,@categoryId = 1;


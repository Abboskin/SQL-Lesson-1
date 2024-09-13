--Lesson 6

--SQL Server Recursive CTE

--During the lesson
WITH cte_numbers(n) 
AS (
    SELECT 
        1 
	UNION ALL
    SELECT    
        n + 1 
    FROM    
        cte_numbers
    WHERE n < 10
)
SELECT 
    *
FROM 
    cte_numbers;

--A) Simple SQL Server recursive CTE example

WITH cte_numbers(n, weekday) 
AS (
    SELECT 
        0, 
        DATENAME(DW, 0)
    UNION ALL
    SELECT    
        n + 1, 
        DATENAME(DW, n + 1)
    FROM    
        cte_numbers
    WHERE n < 6
)
SELECT 
    weekday
FROM 
    cte_numbers;

--B) Using a SQL Server recursive CTE to query hierarchical data

WITH cte_org AS (
    SELECT       
        staff_id, 
        first_name,
        manager_id
        
    FROM       
        sales.staffs
    WHERE manager_id IS NULL
    UNION ALL
    SELECT 
        e.staff_id, 
        e.first_name,
        e.manager_id
    FROM 
        sales.staffs e
        INNER JOIN cte_org o 
            ON o.staff_id = e.manager_id
)
SELECT * FROM cte_org;


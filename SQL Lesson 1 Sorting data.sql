--Когда выбираем SELECT строки идут беспорядочно
--ORDER BY помогает нам сделать этот порядок 
--ASC идет по дефолту и означает от малого к большему а DESC наоборот

--Sort a result set by one column in ascending order

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    first_name;

--Порядок будет начинаться с first_name по алфавиту (Aaron)

--Sort a result set by one column in descending order

SELECT
	first_name,
	last_name
FROM
	sales.customers
ORDER BY
	first_name DESC;

--Порядок начнется с конца алфавита (Zulema)

--Sort a result set by multiple columns

SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city,
    first_name;

--Сначала будет порядок по city(Albany) а потом по first_name(Douglass)

--Sort a result set by multiple columns and different orders

SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city DESC,
    first_name ASC;

--City(Yuba City), first_name(Demarcus, Jenna...)

--Sort a result set by a column that is not in the select list

SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    state;

--State не находится в SELECT

--Sort a result set by an expression

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    LEN(first_name) DESC;

--Len DESC по длинне слова (Guilermina(10)...Ai(2))

--Sort by ordinal positions of columns

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    1,
    2;
--Порядок по SELECT 1-first_name, 2-last_name

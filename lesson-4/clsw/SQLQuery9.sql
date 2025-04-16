CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop Pro', 'Electronics', 999.99, 2),
(2, 'Wireless Mouse', 'Accessories', 29.99, 3),
(3, 'Smartphone X', 'Electronics', 699.99, 5),
(4, 'Desk Chair', 'Furniture', 149.99, 30),
(5, 'LED Monitor', 'Electronics', 199.99, 1),
(6, 'USB Cable', 'Accessories', 9.99, 7),
(7, 'Coffee Table', 'Furniture', 249.99, 10),
(8, 'Headphones', 'Accessories', 59.99, 0),
(9, 'Tablet S', 'Electronics', 399.99, 4),
(10, 'Bookshelf', 'Furniture', 89.99, 0);


--Agregate functions
select count(*) from products

update Products
set ProductName=null
where productid=1;

select count(productname) from products

--2. SUM
--3. AVG
--4. MIN
--5. MAX
--6. STRING AGG()
select
	category,
	string_agg(ProductName, '--')
from products
group by category

--question
create table agents
(
	name varchar(50),
	office varchar(50),
	isheadoffice varchar(3)
);

insert into agents
values
	('Rich', 'UK', 'yes'),
	('Rich', 'US', 'no'),
	('Rich', 'NZ', 'no'),
	('Brandy', 'US', 'yes'),
	('Brandy', 'UK', 'no'),
	('Brandy', 'AUS', 'no'),
	('Karen', 'NZ', 'yes'),
	('Karen', 'UK', 'no'),
	('Karen', 'RUS', 'no'),
	('Mary', 'US', 'yes'),
	('Mary', 'UK', 'no'),
	('Mary', 'CAN', 'no'),
	('Charles', 'US', 'yes'),
	('Charles', 'UZB', 'no'),
	('Charles', 'AUS', 'no');
select*from agents


select name --,*
from agents 
where (office='US' and isheadoffice='yes') OR (office='UK' and isheadoffice = 'no')
group by name 
having count(distinct office) = 2;

create table parent
(
	pname varchar(50),
	cname varchar(50),
	gender char(1)
);

insert into parent
values
	('Karen', 'John', 'M'),
	('Karen', 'Steve', 'M'),
	('Karen', 'Ann', 'F'),
	('Rich', 'Cody', 'M'),
	('Rich', 'Stacy', 'F'),
	('Rich', 'Mike', 'M'),
	('Tom', 'John', 'M'),
	('Tom', 'Ross', 'M'),
	('Tom', 'Rob', 'M'),
	('Roger', 'Brandy', 'F'),
	('Roger', 'Jennifer', 'F'),
	('Roger', 'Sara', 'F')
select * from parent

select pname from parent
group by pname
having count(distinct gender)=2;


--number func
--1.SQRT
select sqrt(13313)
select sqrt(0)
select price from products
select *, sqrt(price) as 'sqrt of price' from products

--2.ABS
select abs(100)

--3.Round

select *, round(sqrt(price), 0) as Rounded_sqrt from products

--4. CEILING - yuqoriga yaxlitlash
select ceiling(2.00000011111)

--5. FLOOR - quyiga yaxlitlash

select floor(0)

--6. POWER

select power(2, 23) --(base, power)

--7. EXP --> simply e=2.71

select exp(1) 

--8. LOG = LN
select log(2)

--9. LOG10 
select log10(10)

--10. SIGN
select sign(-1), sign(0), sign(10);

--11. RAND-(0, 1)

select ceiling(100*rand())

--String functions

--1. LEN
select *, len(productname) as length_ from products

--2.LEFT & RIGHT

select productname,
	len(productname),
	left(productname, 3) as left_cut,
	right(productname, 3) as right_cut,
	substring(productname, 3, 4)
from products;
--3. REVERSE

select productname, reverse(substring(productname, 2, 2)) from products;
select reverse('Laptop')

--4. CHARINDEX

select productname, charindex('o', productname) as INDEX1 from products;

select 'demo coffee', charindex('o', 'demo coffee'), charindex('o', 'demo coffee', 5);

--5. REPLACE

select replace('SQL SERVER 2018', 'SQL', 'PYTHON');

SELECT PRODUCTNAME FROM PRODUCTS

SELECT REPLACE(PRODUCTNAME, 'O', '$') FROM PRODUCTS;

--6. TRIM, LTRIM, RTRIM.

SELECT 'SOMETHING',
	LTRIM(    'SOMETHING'     ) AS LTRIM1,
	RTRIM(    'SOMETHING'     ) AS RTRIMG2,
	TRIM(    'SOMETHING'     ) AS TRIM3;

--7. UPPER/ LOWER

select productname,
	LOWER(productname) as UPPER_C,
	UPPER(productname) as lower_c
from products

--8. CONCAT

select 'Hello ' + 'Oktam'
union all
select concat('hello ', null, 'world')
select 'hello '+ null + 'world';

--9. STRING_AGG()

--10. SPACE
select 'Hello' + space(1) + 'Brother'

--11. REPLICATE

select 'apple' * 10
--Conversion failed when converting the varchar value 'apple' to data type int.

select replicate('Banana, ', 5);

--12. STRING_SPLIT
select value, ordinal+2 from string_split('apple,banana,lemon', ',', 1);



--date and/or time func

--1. GETDATE(), CURRENT_TIMESTAMP
select getdate();
SELECT CURRENT_TIMESTAMP;

--2. YEAR/MONTH/DAY

SELECT getdate() as date, month(getdate()) as month, year(getdate()) as year, day(getdate()) as day;

select day('2025-04-15 16:27:02.197');

--3. Ikki sana orasidagi vaqt
select datediff(day,'2023-04-15','2025-04-15');
select datediff(year,'2023-04-15','2025-04-15');
select datediff(month,'2023-04-15','2025-04-15');

--4. Sanani ustiga malum bir vaqt qoshish

select dateadd(day, 1, '2025-04-15');
select getdate(), eomonth(getdate()); --eomonth=end of month


--CATS
--select cast(<value>, <datatype>)
select cast('a' as int)
select '5' * 5
select try_cast('a' as int), try_cast('54' as int);



--window func






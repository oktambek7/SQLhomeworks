--DDL: Data Definition Language.

/* COMMON DATA TYPES */

-- integer 
/* 
1. tinyint=(0,255)
2. int=(2B, 2B)
3. smallint=(-32,.., 32,..)
4. bigint=(-2^63, 2^63-1)
*/


create table test
(
	id tinyint
);

insert into test
values
	(1), (2), (3);

select * from test

drop table if exists test

create table test
(
	id smallint
);
insert into test
values
	(-32000);

	/* STRING */

/* CHAR(50), NCHAR(50), VARCHAR(50), NVACRHAR(50) */
/* TEXT, NTEXT */
/* NVARCHAR(MAX) */

DROP TABLE IF EXISTS BLOG;
CREATE TABLE BLOG
(
	ID INT, 
	TITLE VARCHAR(255),
	BODY VARCHAR (MAX)
);
--The size (8001) given to the column 'BODY' exceeds the maximum allowed for any data type (8000).


/* DATE AND TIME */

/*
DATE = YYYY-MM-DD
TIME = HH:MM:SS
DATETIME = YYYY-MM-DD HH:MM:SS
*/

CREATE TABLE PERSON
(
	NAME VARCHAR(100),
	BIRTHDATE DATE
);

INSERT INTO PERSON
SELECT 'JOHN', '1950-11-23'

SELECT * FROM PERSON

--TIME

CREATE TABLE EXAM
(
	SUBJECT VARCHAR(50),
	EXAM_TIME TIME
);

INSERT INTO EXAM
SELECT 'PYHTON', '15:00'

SELECT * FROM EXAM

--DATETIME

SELECT GETDATE()

--2025-04-10 13:30:18.300

CREATE TABLE [ORDER]
(
	ITEM VARCHAR(50),
	PRICE INT,
	CREATED_DATETIME DATETIME
	--UPDATED_DATETIME DATETIME
);

INSERT INTO [ORDER]
SELECT 'apple', 1000, getdate();

INSERT INTO [ORDER]
SELECT 'cherry', 3000, getdate();

select * from [order]

select getdate();
select getutcdate();

--datetime2

/* guid */

create table nimadir
(
	id uniqueidentifier,
	name varchar(50)
);

select newid();

insert into nimadir
select newid(), 'adam'

insert into nimadir
select newid(), 'john'

select * from nimadir

insert into nimadir
select 'F553C8F1-F4D6-49F5-95E1-C8A52EC873E6', 'jamie';

/* ma'lumotlar bazasida rasm saqlamoqchimiz */
--1.
create table products
(
	id int primary key,
	name varchar (50),
	category_name varchar(50),
	photo_path varchar (50)
);

--2.

drop table if exists products
create table products
(
	id int primary key,
	name varchar (50),
	category_name varchar(50),
	photo varbinary(max)
);

insert into products

select 1, 'cherry', BulkColumn from openrowset (
		bulk 'C:\Users\Admin\Pictures\istockphoto-533381303-612x612.jpg', SINGLE_BLOB
) as image_file

select * from products

select @@SERVERNAME
DESKTOP-495GBSC


create table file_storage(
	file_id int primary key identity,
	file_name varchar(50),
	file_type varchar(10),
	file_data varbinary(max)
);

insert into file_storage(file_name, file_type, file_data)
select 'words', 'docx', * from openrowset(
	bulk 'C:\Users\Admin\Documents\Summary.txt', single_blob
) as something;

select * from file_storage

select * from openrowset(
	bulk 'C:\SQL_TASKS\sample.csv', single_clob
) as data;

id,name  1,carol  2,frank  3,fridrix

drop table if exists employee
create table employee
(
	id int identity,
	name varchar(100)
);

insert into employee(name)
select 'Oktambek'
union all
select 'Suhrob'

delete from employee

truncate table employee

bulk insert employee
from 'C:\SQL_TASKS\sample.csv' 
with(
	firstrow=2,
	fieldterminator =',',
	rowterminator='\n'
);

select * from employee

/* drop vs delete vs truncate */

delete from employee where name='fridrix'; --removes values inside the table, while remaining columns.
delete from employee where id=2

truncate table employee; -- truncate=delete

select * from employee;

drop table employee; --removes table completetely=drop table if exists






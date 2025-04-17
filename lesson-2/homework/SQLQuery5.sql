 --TASK-1
 
 --DELETE vs TRUNCATE vs DROP (with IDENTITY example)

 --   Create a table test_identity with an IDENTITY(1,1) column and insert 5 rows.
 --   Use DELETE, TRUNCATE, and DROP one by one (in different test cases) and observe how they behave.
 --   Answer the following questions:

 drop table if exists test_identity
 create table test_identity
 (
	id int primary key identity(1, 1),
	name varchar(max)
 );

insert into test_identity
values
	('john'),
	('Carol'),
	('Alan'),
	('Rodger'),
	('Jack');
select*from test_identity;

---delete usage:
delete from test_identity;

delete from test_identity where name='Alan';

delete from test_identity where id=6;

---truncate usage:
truncate table test_identity;

---drop usage:
drop table test_identity;

 --       What happens to the identity column when you use DELETE?
 ---answer: when we use delete function it deletes all values that exist in the table while saving columns only. There is a shortcut while using delete in coding: if i delete values from the table and insert again values into table its id starts counting from where it left last time before deleting.
 ----ex:

 --before:								after:
--1	john                                6 john
--2	Carol								7 Carol
--3	Alan								8 Alan
--4	Rodger							    9 Rodger
--5	Jack								10 Jack				   


 --       What happens to the identity column when you use TRUNCATE?

 ---answer: truncate function is quite similar to delete, but differs in case when using truncate after truncating table. Unlike delete, it puts id to table from the beginnning no matter how many times you truncate table. 
--ex:
--before truncating table:                after truncating table and inserting values again into table:


--1	john								1 john
--2	Carol							    2 Carol
--3	Alan								3 Alan
--4	Rodger								4 Rodger
--5	Jack								5 Jack


 --  What happens to the table when you use DROP?

 --answer: as name suggests, it simply drops table leaving nothing. It is the same as 'drop table if exists  {table name}' query.


 ---==========TASK-2

 --Common Data Types

 --   Create a table data_types_demo with columns covering at least one example of each data type covered in class.
 --   Insert values into the table.
 --   Retrieve and display the values.
 drop table if exists data_types_demo
 create table data_types_demo
 (
	id tinyint primary key identity,
	football_club nvarchar(50),
	total_players smallint,
	founded_date date
);
insert into data_types_demo(football_club,total_players,founded_date)
values
	('Real madrid', 11, '1950-02-18'),
	('Barcelona', 11, '1960-08-24');
select*from data_types_demo

create table mall
(
	product_type varchar(100),
	price bigint,
	produced_date datetime
);
insert into mall
values ('Fruits-apple', 200, getdate()),
	   ('Vegetables-tomato', 300, '2025-04-15');
select*from mall

--===================TASK-3. 

--Inserting and Retrieving an Image

--    Create a photos table with an id column and a varbinary(max) column.
--    Insert an image into the table using OPENROWSET.
--    Write a Python script to retrieve the image and save it as a file.

drop table if exists photos
create table photos
(
	id int primary key identity(1,1),
	name varchar(max),
	photo varbinary(max)
);

INSERT INTO photos (photo)
SELECT BulkColumn
FROM OPENROWSET(
    BULK 'C:\Users\Admin\Pictures\wp3588576.webp',
    SINGLE_BLOB
) AS ImageData;

select*from photos








---==============TASK-4


--Computed Columns

--    Create a student table with a computed column total_tuition as classes * tuition_per_class.
--    Insert 3 sample rows.
--    Retrieve all data and check if the computed column works correctly.

drop table if exists student
create table student 
(
	classes smallint,
	tuition_per_class tinyint
);
insert into student
values
	(5, 200),
	(2, 100),
	(7,150);

select *,
	total_tuition=classes * tuition_per_class
from student;



----=====================TASK-5. 

--CSV to SQL Server

--    Download or create a CSV file with at least 5 rows of worker data (id, name).
--    Use BULK INSERT to import the CSV file into the worker table.
--    Verify the imported data.


CREATE TABLE Workers (
    id INT,
    name VARCHAR(50)
);


BULK INSERT workers
FROM 'C:\Users\Admin\Documents\wassup.txt'
WITH (
	firstrow=2,
	fieldterminator=',',
	rowterminator='\n'
);

select*from workers;
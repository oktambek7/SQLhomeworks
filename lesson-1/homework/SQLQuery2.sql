create database lesson_1
use lesson_1

--1. NOT NULL Constraint

--    Create a table named student with columns:
--        id (integer, should not allow NULL values)
--        name (string, can allow NULL values)
--        age (integer, can allow NULL values)
--    First, create the table without the NOT NULL constraint.
--    Then, use ALTER TABLE to apply the NOT NULL constraint to the id column.


/* WITHOUT NOT NULL CONSTRAINT */

create table student
(
	Id int not null,
	Name varchar(50) null,
	Age int null
);

insert into student
values
	(1, 'Toby', 23),
	(2, 'Tom', 25),
	(3, 'Andrew', 22),
	(4, 'Bruce', 30);

select * from student

/* WITH NOT NULL CONSTARINT */

ALTER TABLE student ALTER COLUMN id INTEGER NOT NULL;

insert into student(id, name, age)
values
(null, 'james', 40);

--2. UNIQUE Constraint

--    Create a table named product with the following columns:
--        product_id (integer, should be unique)
--        product_name (string, no constraint)
--        price (decimal, no constraint)
--    First, define product_id as UNIQUE inside the CREATE TABLE statement.
--    Then, drop the unique constraint and add it again using ALTER TABLE.
--    Extend the constraint so that the combination of product_id and product_name must be unique.

drop table if exists product
create table product 
(
	product_id int unique,
	product_name varchar(50),
	price decimal(10, 2)
);

alter table product
drop constraint product_id;

alter table product
add unique (product_id);

alter table product
add unique (product_id);

alter table product
add unique (product_name);

insert into product
values
(1, 'apple', 10.99),
(2, 'banana', 12.99);

select * from product

insert into product
values
(1, 'apple', 10.99),
(1, 'banana', 12.99);

--Violation of UNIQUE KEY constraint 'UQ__product__47027DF40A050BD3'. Cannot insert duplicate key in object 'dbo.product'. The duplicate key value is (1).

insert into product
values
(3, 'apple', 10.99);

--Violation of UNIQUE KEY constraint 'UQ__product__2B5A6A5FD3B700C1'. Cannot insert duplicate key in object 'dbo.product'. The duplicate key value is (apple).

--3. PRIMARY KEY Constraint

--    Create a table named orders with:
--        order_id (integer, should be the primary key)
--        customer_name (string, no constraint)
--        order_date (date, no constraint)
--    First, define the primary key inside the CREATE TABLE statement.
--    Then, drop the primary key and add it again using ALTER TABLE.


create table orders
(
	order_id int not null,
	customer_name varchar(50),
	order_date date,
	CONSTRAINT FK_orders_primaryKey primary key (order_id)
);

alter table orders
drop constraint FK_orders_primaryKey;

alter table orders
add CONSTRAINT FK_orders_primaryKey primary key (order_id);


--4. FOREIGN KEY Constraint

--    Create two tables:
--        category:
--            category_id (integer, primary key)
--            category_name (string)
--        item:
--            item_id (integer, primary key)
--            item_name (string)
--            category_id (integer, should be a foreign key referencing category_id in category table)
--    First, define the foreign key inside CREATE TABLE.
--    Then, drop and add the foreign key using ALTER TABLE.

create table category
(
	
	category_id int primary key,
    category_name varchar(50)
);

create table item
(
	item_id int primary key,
    item_name varchar(255),
    category_id int,
	CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

select * from category
select * from item

ALTER TABLE ITEM
DROP CONSTRAINT FK_item_category;

ALTER TABLE ITEM
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id)


--5. CHECK Constraint

--    Create a table named account with:
--        account_id (integer, primary key)
--        balance (decimal, should always be greater than or equal to 0)
--        account_type (string, should only accept values 'Saving' or 'Checking')
--    Use CHECK constraints to enforce these rules.
--    First, define the constraints inside CREATE TABLE.
--    Then, drop and re-add the CHECK constraints using ALTER TABLE.


create table account
(
	account_id int primary key,
    balance decimal(10, 2) constraint CHK_balance check (balance >= 0),
    account_type varchar(50) constraint CHK_accountType check(account_type in ('Saving','Checking'))
);

insert into account
values
	(1, 200.4, 'Saving'),
	(2, 400.99, 'Checking');

select * from account

insert into account
values
	(3, 843.29, 'Visa')

--The INSERT statement conflicted with the CHECK constraint "CHK_accountType". The conflict occurred in database "lesson_1", table "dbo.account", column 'account_type'.

insert into account
values
	(3, -1000, 'Saving')

--The INSERT statement conflicted with the CHECK constraint "CHK_balance". The conflict occurred in database "lesson_1", table "dbo.account", column 'balance'.

alter table account
drop constraint CHK_balance;

alter table account
add constraint CHK_balance check (balance >= 0);


alter table account
drop constraint CHK_accountType;

alter table account
add constraint CHK_account_type check (account_type in ('Saving', 'Checking'));

--6. DEFAULT Constraint

--    Create a table named customer with:
--        customer_id (integer, primary key)
--        name (string, no constraint)
--        city (string, should have a default value of 'Unknown')
--    First, define the default value inside CREATE TABLE.
--    Then, drop and re-add the default constraint using ALTER TABLE.

drop table if exists customer
create table customer
(
	customer_id int primary key,
    name varchar(255),
    city varchar(255) constraint CV_customer_default default 'Unknown'
);

insert into customer(customer_id, name)
values (1, 'John'), (2, 'Alex'), (3, 'Smith');

select * from customer


alter table customer
drop constraint CV_customer_default;

ALTER TABLE customer
ADD CONSTRAINT CV_customer_default DEFAULT 'Unknown' FOR city;

--7. IDENTITY Column

--    Create a table named invoice with:
--        invoice_id (integer, should auto-increment starting from 1)
--        amount (decimal, no constraint)
--    Insert 5 rows into the table without specifying invoice_id.
--    Enable and disable IDENTITY_INSERT, then manually insert a row with invoice_id = 100.


create table invoice
(
	invoice_id int identity,
	amount decimal(10, 2)

);

insert into invoice
values
	(99.99),
	(10.32),
	(323.4323),
	(576.75),
	(673.9632);

select * from invoice

SET IDENTITY_INSERT invoice ON;

insert into invoice (invoice_id, amount)
values
(100, 193.35);

select * from invoice

SET IDENTITY_INSERT invoice OFF;



--8. All at once

--    Create a books table with:
--        book_id (integer, primary key, auto-increment)
--        title (string, must not be empty)
--        price (decimal, must be greater than 0)
--        genre (string, default should be 'Unknown')
--    Insert data and test if all constraints work as expected.

drop table if exists books
create table books 
(
	book_id int primary key,
	title varchar(50) check (title <> '') not null,
	price decimal(5, 2) check (price > 0),
	genre varchar(50) default 'Unknown'
);

insert into books
values
	(1, 'To kill a mockingbird', 88.99, 'drama'),
	(2, '1984', 99.99, 'classic');

insert into books(book_id, title)
values(3, '')

--The INSERT statement conflicted with the CHECK constraint "CK__books__title__7D439ABD". The conflict occurred in database "lesson_1", table "dbo.books", column 'title'.

insert into books(book_id, title, price)
values(3, 'dsdd', -10)

--The INSERT statement conflicted with the CHECK constraint "CK__books__price__7E37BEF6". The conflict occurred in database "lesson_1", table "dbo.books", column 'price'.

insert into books(book_id, title, price)
values(3, 'Romeo and Juliet', 35.25)

select * from books


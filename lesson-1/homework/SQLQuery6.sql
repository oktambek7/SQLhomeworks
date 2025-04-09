--9. Scenario: Library Management System
--You need to design a simple database for a library where books are borrowed by members.

create database [Library Management System]
use [Library Management System]

--Tables and Columns:

--1. Book (Stores information about books)

--    book_id (Primary Key)
--    title (Text)
--    author (Text)
--    published_year (Integer)


create table Book
(
	book_id int primary key,
	title varchar(50),
	author varchar(50),
	published_year int
);

insert into Book
values
	(1, 'To Kill a Mockingbird', 'Harper Lee', 1960),
    (2, 'Pride and Prejudice', 'Jane Austen', 1813),
    (3, 'The Catcher in the Rye', 'J.D. Salinger', 1951),
    (4, 'The Hobbit', 'J.R.R. Tolkien', 1937),
    (5, 'Brave New World', 'Aldous Huxley', 1932);

select * from Book;



--2. Member (Stores information about library members)

--    member_id (Primary Key)
--    name (Text)
--    email (Text)
--    phone_number (Text)

create table Member
(
	member_id int primary key,
	name varchar(50),
	email varchar(50),
	phone_number varchar(50)
);

insert into Member 
values
	(1, 'John', 'john@gmail.com', '7771771'),
	(2, 'Alexandra', 'alexandra@gmail.com', '1234567'),
	(3, 'Jack', 'jack@gmail.com', '742313913'),
	(4, 'Rocky', 'rocky@gmail.com', '87654363');

select * from Member



--3. Loan (Tracks which members borrow which books)

--    loan_id (Primary Key)
--    book_id (Foreign Key → References book.book_id)
--    member_id (Foreign Key → References member.member_id)
--    loan_date (Date)
--    return_date (Date, can be NULL if not returned yet)


create table Loan
(
	loan_id int primary key,
	book_id int foreign key references Book (book_id),
	member_id int foreign key references Member (member_id),
	loan_date date,
	return_date date null
);

insert into Loan
values
	(1, 2, 3, '2023-01-01', '2023-02-01'),
	(2, 3, 1, '2024-04-20', '2024-05-20'),
	(3, 5, 4, '2025-03-14', null);

select * from Loan



--2. Write SQL Statements

--    Create the tables with proper constraints (Primary Key, Foreign Key).
--    Insert at least 2-3 sample records into each table

create table Cars
(
	car_id int constraint CV_cars_primaryKey primary key(car_id),
	brand varchar(50),
	price int
);

insert into cars
values
	(1, 'BMW', 120000),
	(2, 'Mercedes', 140000);
select*from cars

--checking for duplicate id in primary key

insert into cars(car_id)
values(2);

--Violation of PRIMARY KEY constraint 'CV_cars_primaryKey'. Cannot insert duplicate key in object 'dbo.Cars'. The duplicate key value is (2).

drop table if exists person
create table person
(
	name varchar(50) constraint CV_primaryKey primary key(name),
	hobby varchar (50),
	gender varchar (50)
);

insert into person
values
	('Josh', 'reading magazines', 'man'),
	('Anastasia', 'surfing net', 'female');
select * from person


create table department
(
	dep_id int primary key,
	dep_name varchar(100) not null
);


create table employee
(
	emp_id int identity(1, 1) primary key,
	emp_name varchar(100) not null,
	salary decimal (10, 2),
	dep_id int,
	constraint FK_employee_department foreign key (dep_id) references department(dep_id)
);

insert into department(dep_id, dep_name)
values
	(1, 'HR'),
	(2, 'IT'),
	(3, 'Accounting'),
	(4, 'Marketing');

insert into employee
values
	('John', 1000.00, 4),
	('Tom', 12000.03, 1),
	('Carol', 80000.42, 3),
	('Oktam', 2000000.1323, 2);

select * from department
select * from employee

create table products
(
	prod_id int identity primary key,
	prod_name varchar(50)

);

create table info
(
	product_del_date date,
	product_price int check(product_price > 0),
	prod_id int,
	constraint AL_info_product foreign key (prod_id) references products(prod_id)
);

insert into products
values
	('potato'),
	('meat'),
	('lemon');

insert into info
values
	('2025-12-12', 200, 3),
	('2024-07-24', 100, 1),
	('2022-04-14', 120, 2);

select * from products
select * from info
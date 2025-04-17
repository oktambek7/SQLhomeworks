create database lesson_5_clsw
go
use lesson_5_clsw
-------------------------------------------------
--lesgoooooooooooooooooooooo
drop table if exists nobel_win
CREATE TABLE nobel_win (
    year INTEGER,
    subject VARCHAR(50),
    winner VARCHAR(100),
    country VARCHAR(50),
    category VARCHAR(50)
);
INSERT INTO nobel_win (year, subject, winner, country, category) VALUES
(1970, 'Physics', 'Hannes Alfven', 'Sweden', 'Scientist'),
(1970, 'Physics', 'Louis Neel', 'France', 'Scientist'),
(1970, 'Chemistry', 'Luis Federico Leloir', 'France', 'Scientist'),
(1970, 'Physiology', 'Ulf von Euler', 'Sweden', 'Scientist'),
(1970, 'Physiology', 'Bernard Katz', 'Germany', 'Scientist'),
(1970, 'Literature', 'Aleksandr Solzhenitsyn', 'Russia', 'Linguist'),
(1970, 'Economics', 'Paul Samuelson', 'USA', 'Economist'),
(1970, 'Physiology', 'Julius Axelrod', 'USA', 'Scientist'),
(1971, 'Physics', 'Dennis Gabor', 'Hungary', 'Scientist');

select*
from nobel_win
where year=1970
order by (case when subject in ('chemistry', 'economics') then 1 else 0 end), subject;

create table sales
(
	id int primary key identity,
	name varchar(50),
	date_sold date
)
insert into sales
values
	('apple', '2020-11-12'),
	('banana', '2019-01-15'),
	('grapes', '2020-03-14'),
	('apple', '2020-06-12');
	select * from sales

select name
from sales
group by name
having max(year(date_sold))=min(year(date_sold)) and year(max(date_sold))=2020;

--Window functions

CREATE TABLE Sales2 (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    SaleDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL
);


INSERT INTO Sales2 (SaleDate, Amount) VALUES
('2024-01-01', 100),
('2024-01-02', 200),
('2024-01-03', 150),
('2024-01-04', 300),
('2024-01-05', 250),
('2024-01-06', 400),
('2024-01-07', 350),
('2024-01-08', 450),
('2024-01-09', 500),
('2024-01-10', 100);


select *,
	row_number() over(order by amount asc) as rn_asc,
	dense_rank() over(order by amount asc) as drn_asc,
	rank() over(order by amount asc) as drn_asc
from sales2
order by saleid;


----1	2024-01-01	100.00	1
----2	2024-01-02	200.00	4
----3	2024-01-03	150.00	3
----4	2024-01-04	300.00	6
----5	2024-01-05	250.00	5
----6	2024-01-06	400.00	8
----7	2024-01-07	350.00	7
----8	2024-01-08	450.00	9
----9	2024-01-09	500.00	10
----10	2024-01-10	100.00	2

--agg functions
--sum, count, min, max, avg

select *,
(select sum(amount) from sales2)
from sales2

select sum(amount) from sales2

select *, sum(amount) over() as sum_of_amount
from sales2

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);


INSERT INTO Employees ([Name], Department, Salary, HireDate) VALUES
('Alice', 'HR', 50000, '2020-06-15'),
('Bob', 'HR', 60000, '2018-09-10'),
('Charlie', 'IT', 70000, '2019-03-05'),
('David', 'IT', 80000, '2021-07-22'),
('Eve', 'Finance', 90000, '2017-11-30'),
('Frank', 'Finance', 75000, '2019-12-25'),
('Grace', 'Marketing', 65000, '2016-05-14'),
('Hank', 'Marketing', 72000, '2019-10-08'),
('Ivy', 'IT', 67000, '2022-01-12'),
('Jack', 'HR', 52000, '2021-03-29');

select *, sum(salary) over(partition by department) as sum_of_salary from Employees;

select department, sum(salary) as sum_of_salary
from  employees
group by department;

select *,
dense_rank() over(partition by department order by salary desc) as rnk
from employees
order by department, rnk;


select * from(
	select *,
			dense_rank() over(partition by department order by salary desc) as rnk from employees)
my_table
where rnk=1
order by department, rnk;

select top 5 * from sales2

select *,
	cast(amount/sum(amount) over() * 100 as decimal(10, 2)) as percentage
from sales2;

select*,
	avg(amount) over(order by saleid rows between preceding and current row) as avg
from sales2
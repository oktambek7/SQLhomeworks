--Given Tables:

-----1)Employee

--EmployeeID 	Name 	DepartmentID 	Salary
--1 	        Alice 	    101 	    60000
--2 	        Bob 	    102 	    70000
--3 	        Charlie 	101 	    65000
--4 	        David 	    103 	    72000
--5 	        Eva 	    NULL 	    68000
create table employee
(
	EmployeeID int primary key identity,
	Name varchar(50),
	DepartmentID int,
	Salary int
);
insert into employee
values
	('Alice', 101, 60000),
	('Bob', 102, 70000),
	('Charlie', 101, 65000),
	('David', 103, 72000),
	('Eva', Null, 680000);
select*from employee;

-------2) Departments


--DepartmentID 	DepartmentName
--		101 	IT
--		102 	HR
--		103 	Finance
--		104 	Marketing

create table Departments
(
	DepartmentID int,
	DepartmentName varchar(50)
);
insert into Departments
values
	(101, 'IT'),
	(102, 'HR'),
	(103, 'Finance'),
	(104, 'Marketing');
	select*from departments;

--------------3) Projects

--   ProjectID 	ProjectName 	EmployeeID
	--		1 	  Alpha 	           1
	--		2 	   Beta 	           2
	--		3 	   Gamma 	           1
	--		4 	   Delta 	           4
	--		5 	   Omega 	          NULL

create table Projects
(
	ProjectID int primary key identity,
	ProjectName varchar(50),
	EmployeeID int
);
insert into projects
values
	('Alpha', 1),
	('Beta', 2),
	('Gamma', 1),
	('Delta', 4),
	('Omega', Null);
	select*from projects;

--Questions:

--    INNER JOIN
--        1. Write a query to get a list of employees along with their department names.

select  * from employee;
select  * from departments;

select*
from employee as e inner join 
departments as d
on e.departmentID=d.DepartmentID;




--    LEFT JOIN
--        2. Write a query to list all employees, including those who are not assigned to any department.

select * from
employee as e left outer join
Departments as d
on e.DepartmentID=d.DepartmentID;

--    RIGHT JOIN
--        3. Write a query to list all departments, including those without employees.

select *
from employee emp RIGHT JOIN
departments dep
on emp.DepartmentID=dep.DepartmentID;

--    FULL OUTER JOIN
--        4. Write a query to retrieve all employees and all departments, even if there’s no match between them.

select *from 
employee FULL OUTER JOIN departments
on employee.DepartmentID=Departments.DepartmentID;

--    JOIN with Aggregation
--        5. Write a query to find the total salary expense for each department.

SELECT d.DepartmentName, SUM(salary) AS total_salary_expenses
from departments AS d
LEFT OUTER JOIN employee AS e
ON d.DepartmentID=e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY d.DepartmentName;

--    CROSS JOIN
--        6. Write a query to generate all possible combinations of departments and projects.

SELECT *FROM
departments cross join
projects ;

--    MULTIPLE JOINS
--        7.Write a query to get a list of employees with their department names and assigned project names. Include employees even if they don’t have a project.

select *from
employee e left join 
departments d
on e.DepartmentID=d.DepartmentID
left join projects p
on e.EmployeeID=p.EmployeeID;

create database lesson_5_homework
go

use lesson_5_homework;

--Tasks:

--Ranking Functions

--    1.Assign a Unique Rank to Each Employee Based on Salary

--    2.Find Employees Who Have the Same Salary Rank

--    3.Identify the Top 2 Highest Salaries in Each Department

--    4.Find the Lowest-Paid Employee in Each Department

--    5.Calculate the Running Total of Salaries in Each Department

--    6.Find the Total Salary of Each Department Without GROUP BY

--    7.Calculate the Average Salary in Each Department Without GROUP BY

--    8.Find the Difference Between an Employee’s Salary and Their Department’s Average

--    9.Calculate the Moivng Average Salary Over 3 Employees (Including Current, Previous, and Next)

--    10.Find the Sum of Salaries for the Last 3 Hired Employees

--    11.Calculate the Running Average of Salaries Over All Previous Employees

--    12.Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After

--    13.Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary


CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);


INSERT INTO Employees ([Name], Department, Salary, HireDate) VALUES

('Josh', 'HR', 70000, '2020-06-15'),
('Bob', 'HR', 60000, '2018-09-10'),
('Charlie', 'IT', 70000, '2019-03-05'),
('David', 'IT', 80000, '2021-07-22'),
('Eve', 'Finance', 90000, '2017-11-30'),
('Frank', 'Finance', 75000, '2019-12-25'),
('Grace', 'Marketing', 65000, '2016-05-14'),
('Hank', 'Marketing', 72000, '2019-10-08'),
('Ivy', 'IT', 67000, '2022-01-12'),
('Jack', 'HR', 52000, '2021-03-29');

select * from employees;


--1.
select *,
	dense_rank()  over(order by salary desc) as unique_rank
from employees;

--2.
SELECT *
FROM Employees e1
WHERE (
    SELECT COUNT(*)
    FROM Employees e2
    WHERE e2.Salary = e1.Salary
) > 1
ORDER BY Salary DESC, Name;

--3.
SELECT *
FROM (
    SELECT *,
        DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS top_2
    FROM Employees
) AS RankedEmployees
WHERE top_2 <= 2
ORDER BY Department, Salary DESC, Name;

--4.

select department, salary from employees;
select * from(
select*,
		min(salary) over(partition by department) as min_salary from employees)
as min_salaries
where salary=min_salary
order by department, name;

--5.

SELECT *,
    SUM(Salary) OVER(PARTITION BY Department ORDER BY EmployeeID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Employees
ORDER BY Department, EmployeeID;

--6.

select department, salary, sum_of_salaries from(
select*,
	sum(salary) over(partition by department) as sum_of_salaries from employees)
as total
order by department;

--7.

select*,
	avg(salary) over(pratition by department) as average_salary
from employees;

--8.

select*,
	salary-avg(salary) over(partition by department) as difference_salary_and_avg
from employees;

--9.
select*,
	avg(salary) over(order by salary rows between 1 preceding and 1 following) as avg_running
from employees
order by department, salary;

	
--10.


with RankedEmployees as(
select *, 
	row_number() over(order by hiredate) as hire_rank
from employees)
SELECT
    SUM(Salary) AS total_salary_last_3
FROM RankedEmployees
WHERE hire_rank <= 3;

--11.

select department, salary, avg_preceding from(
select*,
	avg(salary) over (order by salary rows between unbounded preceding and current row) as avg_preceding
from employees) t;


--12.

select*,
	max(salary) over(order by salary rows between 1 preceding and 1 following) as avg_of_two_emp
from employees;


--13.

select*,
	cast(salary/sum(salary) over(partition by department)  * 100 as decimal(10, 2)) as percentage
from employees;


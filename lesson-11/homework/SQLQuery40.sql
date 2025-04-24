--Puzzle 1: The Shifting Employees

--A company has a rotational transfer policy where employees switch departments every 6 months. You have an Employees table:

--Table: Employees
--EmployeeID 	Name 	Department 	Salary
--1 	        Alice 	HR 	        5000
--2 	        Bob 	IT          7000
--3 	      Charlie  Sales 	    6000
--4 	      David 	HR 	        5500
--5 	      Emma 	    IT 	        7200
--Task:

--    Create a temporary table #EmployeeTransfers with the same structure as Employees.
--    Swap departments for each employee in a circular manner:
--        HR → IT → Sales → HR
--        Example: Alice (HR) moves to IT, Bob (IT) moves to Sales, Charlie (Sales) moves to HR.
--    Insert the updated records into #EmployeeTransfers.
--    Retrieve all records from #EmployeeTransfers.


-- ==============================================================
--                          Puzzle 1 DDL
-- ==============================================================

create table #EmployeeTransfers
(
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);

select*from #EmployeeTransfers


---Updating departments like in circular manner: HR → IT → Sales → HR

update #EmployeeTransfers
set department= 
	case department
		when 'HR' then 'IT'
		when 'IT' then 'Sales'
		when 'Sales' then 'HR'
		else department
	end 
where department in ('HR','IT','Sales','HR');


-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);



--Puzzle 2: The Missing Orders

--An e-commerce company tracks orders in two separate systems, but some orders are missing in one of them. You need to find the missing records.

--Table 2: Orders_DB2 (Backup System, with some missing records)
--OrderID 	CustomerName 	Product 	Quantity
--101 	Alice 	Laptop 	1
--103 	Charlie 	Tablet 	1
--Task:

--    Declare a table variable @MissingOrders with the same structure as Orders_DB1.
--    Insert all orders that exist in Orders_DB1 but not in Orders_DB2 into @MissingOrders.
--    Retrieve the missing orders.

select*from Orders_DB1;
select*from Orders_DB2;


declare @MissingOrders table
(
	OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
)
	
insert into @MissingOrders (OrderID, CustomerName, Product, Quantity)
select o1.OrderID, o1.CustomerName, o1.product, o1.Quantity
from Orders_DB1 o1
left join Orders_DB2 o2
on o1.OrderID=o2.OrderID
where o2.OrderId is null


select *
from @MissingOrders;


-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);


-----------===========Puzzle 3: The Unbreakable View

--You are given a database that tracks employee working hours. The company needs a monthly summary report that calculates:

--    Total hours worked per employee
--    Total hours worked per department
--    Average hours worked per department

--Given Table: WorkLog
--EmployeeID 	EmployeeName 	Department 	WorkDate 	HoursWorked
--1 	Alice 	HR 	2024-03-01 	8
--2 	Bob 	IT 	2024-03-01 	9
--3 	Charlie 	Sales 	2024-03-02 	7
--1 	Alice 	HR 	2024-03-03 	6
--2 	Bob 	IT 	2024-03-03 	8
--3 	Charlie 	Sales 	2024-03-04 	9
--Task:

--    Create a view vw_MonthlyWorkSummary that calculates:
--        EmployeeID, EmployeeName, Department, TotalHoursWorked (SUM of hours per employee).
--        Department, TotalHoursDepartment (SUM of all hours per department).
--        Department, AvgHoursDepartment (AVG hours worked per department).
--    Retrieve all records from vw_MonthlyWorkSummary.


----1.

--select department, HoursWorked,
--sum(HoursWorked)over(partition by department order by Department) as TotalHoursDepartment
--into table1 from WorkLog

--select department, HoursWorked,
--avg(HoursWorked)over(partition by department order by Department) as AvgHoursDepartment
--into table2 from WorkLog

CREATE VIEW vw_MonthlyWorkSummary AS 
WITH AggregatedWork AS (
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        SUM(HoursWorked) as TotalHoursWorked
    FROM WorkLog
    GROUP BY EmployeeID, EmployeeName, Department
)
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    TotalHoursWorked,
    SUM(TotalHoursWorked) OVER(PARTITION BY Department ORDER BY Department) as TotalHoursDepartment,
    AVG(1.0*TotalHoursWorked) OVER(PARTITION BY Department ORDER BY Department) as AvgHoursDepartment
FROM AggregatedWork;

SELECT *
FROM vw_MonthlyWorkSummary;
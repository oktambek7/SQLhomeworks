use lesson_3_homework
create table guys
(
	id tinyint primary key identity,
	name varchar(max),
	age smallint,
	profession varchar(max),
	married varchar(max)
);

insert into guys(name, age, profession, married)
values
('Oktambek', 19, 'Data Analytic', 'No'),
('Bexruz', 18, 'MIB', 'No'),
('Ibrohim', 18, 'Doctor', 'Not yet');
select * from guys

insert into guys
select 'Begzod', 17, 'Gamer', 'Yes'

select *
from guys
where age > 17

drop table if exists employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate) VALUES
(1, 'John', 'Doe', 'Engineering', 75000.00, '2020-03-15'),
(2, 'Jane', 'Smith', 'Marketing', 20000.00, '2019-06-22'),
(3, 'Alice', 'Johnson', 'Finance', 80000.00, '2021-01-10'),
(4, 'Bob', 'Williams', 'Engineering', 90000.00, '2018-11-05'),
(5, 'Emma', 'Brown', 'HR', 40000.00, '2022-04-18'),
(6, 'Michael', 'Davis', 'Marketing', 70000.00, '2020-09-30'),
(7, 'Sarah', 'Wilson', 'Finance', 85000.00, '2019-02-25'),
(8, 'David', 'Taylor', 'Engineering', 95000.00, '2021-07-12'),
(9, 'Laura', 'Martinez', 'HR', 62000.00, '2023-03-01'),
(10, 'James', 'Anderson', 'Marketing', 68000.00, '2022-08-20'),
(11, 'Olivia', 'Thomas', 'Engineering', 82000.00, '2020-05-17'),
(12, 'Ethan', 'Lee', 'Marketing', 71000.00, '2021-10-03'),
(13, 'Sophia', 'Clark', 'Finance', 78000.00, '2019-12-11'),
(14, 'Liam', 'Harris', 'HR', 64000.00, '2022-06-29'),
(15, 'Ava', 'Walker', 'Engineering', 87000.00, '2023-01-15');
select * from Employees

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

--Task 1: Employee Salary Report

--Write an SQL query that:

    --Selects the top 10% highest-paid employees.
    --Groups them by department and calculates the average salary per department.
    --Displays a new column SalaryCategory:
    --    'High' if Salary > 80,000
    --    'Medium' if Salary is between 50,000 and 80,000
    --    'Low' otherwise.
    --Orders the result by AverageSalary descending.
    --Skips the first 2 records and fetches the next 5.


select top 10 percent EmployeeID, FirstName, LastName, Department, Salary, Hiredate
from employees
order by salary desc;

select Department, round(avg(Salary), 2) as Average_salary_per_department
from employees
group by department
order by department

select salary,
	case
		when salary > 80000 then 'High'
		when salary between 50000 and 80000 then 'Medium'
		else 'Low'
	end
	as SalaryCategory
from employees;

select department, round(avg(salary), 2) as AverageSalary
from employees
group by department
order by AverageSalary desc;


select *
from employees
order by EmployeeID
offset 2 rows fetch first 5 rows only;


--Task 2: Customer Order Insights

--Write an SQL query that:

--    Selects customers who placed orders between '2023-01-01' and '2023-12-31'.
--    Includes a new column OrderStatus that returns:
--        'Completed' for Shipped or Delivered orders.
--        'Pending' for Pending orders.
--        'Cancelled' for Cancelled orders.
--    Groups by OrderStatus and finds the total number of orders and total revenue.
--    Filters only statuses where revenue is greater than 5000.
--    Orders by TotalRevenue descending.


INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status) VALUES
(1, 'Alice Johnson', '2023-01-15', 5500.75, 'Delivered'),
(2, 'Bob Smith', '2022-02-10', 6000.99, 'Shipped'),
(3, 'Carol Williams', '2023-03-05', 4000.00, 'Pending'),
(4, 'David Brown', '2021-04-20', 2000.50, 'Cancelled'),
(5, 'Emma Davis', '2019-05-12', 8000.25, 'Delivered'),
(6, 'Frank Wilson', '2023-06-08', 4600.00, 'Shipped'),
(7, 'Grace Taylor', '2023-07-19', 9000.80, 'Pending'),
(8, 'Henry Martinez', '2024-08-25', 10000.00, 'Delivered'),
(9, 'Isabella Clark', '2023-09-30', 3230.45, 'Cancelled'),
(10, 'James Lee', '2021-10-11', 1020.60, 'Shipped');

select * from orders

select *
from orders
where orderdate between '2023-01-01' and '2023-12-31'


select OrderID, CustomerName, OrderDate, TotalAmount, Status,
	case
		when status in ('Shipped','Delivered') then 'Completed'
		when status in ('Pending') then 'Pending'
		else 'Cancelled'
	end
	as OrderStatus
from orders;


--Groups by OrderStatus and finds the total number of orders and total revenue.	

select [Status],
	count(*) as TotalOrders,
	sum(TotalAmount) as TotalRevenue
from orders
group by status
order by status;

select * from orders


--Filters only statuses where revenue is greater than 5000.

SELECT Status, 
       COUNT(*) AS TotalOrders, 
       SUM(TotalAmount) AS TotalRevenue
FROM Orders
GROUP BY Status
HAVING SUM(TotalAmount) > 5000
ORDER BY Status;

--Orders by TotalRevenue descending.

SELECT OrderID, OrderDate, TotalAmount, Status,
	  SUM(TOTALAMOUNT) AS TotalRevenue
FROM Orders
GROUP BY ORDERID, OrderDate, TotalAmount, Status
ORDER BY TOTALAMOUNT DESC;




--Task 3: Product Inventory Check

--Write an SQL query that:

--    Selects distinct product categories.
--    Finds the most expensive product in each category.
--    Assigns an inventory status using IIF:
--        'Out of Stock'i f Stock = 0.
--        'Low Stock' if Stock is between 1 and 10.
--        'In Stock' otherwise.
--    Orders the result by Price descending and skips the first 5 rows.

truncate table Products
INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop Pro', 'Electronics', 999.99, 50),
(2, 'Wireless Mouse', 'Accessories', 29.99, 70),
(3, 'Smartphone X', 'Electronics', 699.99, 75),
(4, 'Desk Chair', 'Furniture', 149.99, 30),
(5, 'LED Monitor', 'Electronics', 199.99, 0),
(6, 'USB Cable', 'Accessories', 9.99, 8),
(7, 'Coffee Table', 'Furniture', 249.99, 5),
(8, 'Headphones', 'Accessories', 59.99, 150),
(9, 'Tablet S', 'Electronics', 399.99, 7),
(10, 'Bookshelf', 'Furniture', 89.99, 0);

select*from products


--Selects distinct product categories.
select distinct Category from products;

--Finds the most expensive product in each category.
select Category,
	max(Price) as MostExpensive
from products
group by Category
order by category;
	
--Assigns an inventory status using IIF:
--  'Out of Stock'if Stock = 0.
--  'Low Stock' if Stock is between 1 and 10.
--  'In Stock' otherwise.
select*from products

select Stock,
	iif(stock = 0, 'Out of Stock',
		iif(stock between 1 and 10, 'Low Stock', 'In Stock')
		)
	as InventoryStatus
from Products;

--Orders the result by Price descending and skips the first 5 rows.

select Category, ProductName, price, stock,
	iif(stock = 0, 'Out of Stock',
		iif(stock between 1 and 10, 'Low Stock', 'In Stock')
		)
	as InventoryStatus
from Products
order by price desc
offset 5 rows fetch next 5 rows only;



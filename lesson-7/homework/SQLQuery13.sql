CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);


CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);



INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');


----=============TASKS:

--1. Retrieve All Customers With Their Orders (Include Customers Without Orders)
--    Use an appropriate JOIN to list all customers, their order IDs, and order dates.
--    Ensure that customers with no orders still appear.

select*from Customers
select*from orders

SELECT * FROM
customers c LEFT OUTER JOIN
orders o
ON c.customerid=o.customerid;

--2. Find Customers Who Have Never Placed an Order

--    Return customers who have no orders.

SELECT c.CustomerID AS CustomerID,
c.CustomerName AS CustomerName
FROM customers AS c
left join orders AS o
	ON c.CustomerID=o.CustomerID WHERE orderid is null;


--3. List All Orders With Their Products

--    Show each order with its product names and quantity.


select p.productname,
sum(od.quantity) as quantity from orderdetails od join
products p
on od.productID=p.productID
group by p.productname;

--4. Find Customers With More Than One Order

--    List customers who have placed more than one order.


select c.customerid CustomerID, c.customername as CustomerName, od.quantity as Quantity, od.orderid OrderID from(
orders o join
OrderDetails od
on o.orderid=od.orderid and quantity>2)
join customers c
on c.customerID=o.customerid;


--5. Find the Most Expensive Product in Each Order


with RankedProducts as(
	select p.Productname as Productname,
	od.orderid,
	od.price,
	max(od.price)over(partition by od.orderid) as Max_Price
	from products p join orderdetails od
	on p.productid=od.productid
)
select
	OrderID,
	ProductName,
	Price as most_expensive_price
from RankedProducts
where price=max_price
order by orderid;


--6. Find the Latest Order for Each Customer

with LatestOrders AS( 
	select 
		c.CustomerName AS CustomerName,
		o.orderdate AS OrderDate,
		max(o.orderdate) over(partition by c.customerName) as Latest_order
	from customers c join orders o
		ON c.CustomerID=o.customerid
)
select
	CustomerName,
	OrderDate as Latest_orders
from LatestOrders
where orderdate=Latest_Order
order by CustomerName;


--7. Find Customers Who Ordered Only 'Electronics' Products

--    List customers who only purchased items from the 'Electronics' category.

select *
from customers c join
products p
	on c.customerid=p.productid and p.category='Electronics';

--8. Find Customers Who Ordered at Least One 'Stationery' Product

--    List customers who have purchased at least one product from the 'Stationery' category.

select 
c.CustomerName as CustomerName,p.category as Category
from orderdetails od
join products p
	on od.productid=p.productid and p.Category='stationery'
join orders o
	on o.orderid=od.orderid
join customers c
	on c.customerid=o.customerID

--9. Find Total Amount Spent by Each Customer

--    Show CustomerID, CustomerName, and TotalSpent.

select*from OrderDetails
select*from products

select* from customers
select*from orders

with Sum_Price AS(
	select
		c.Customername,
		c.customerID,
		od.Price,
		sum(od.price) over(partition by c.customername) as SUM_OF_PRICE
	from
		customers C join
		orders O
			ON c.CustomerID=o.CustomerID
		join OrderDetails OD
			ON od.orderid=o.orderid)
SELECT DISTINCT 
	CustomerName,
	CustomerID,
	SUM_OF_PRICE as TotalPrice
from Sum_Price
order by SUM_OF_PRICE
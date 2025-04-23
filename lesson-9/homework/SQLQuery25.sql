--Task 1

--Given this Employee table below, find the level of depth each employee from the President.

CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

Expected Output:
EmployeeID 	ManagerID 	JobTitle 	     Depth
		1001 	NULL 	President 	      0
		2002 	1001 	Director 	      1
		3003 	1001 	Office Manager    1
		4004 	2002 	Engineer 	      2
		5005 	2002 	Engineer 	      2
		6006 	2002 	Engineer 	      2


		---Query
;WITH CTE AS(
	select EmployeeID, ManagerID, JobTitle, 0 as Depth
	from employees
	where ManagerID is null

	UNION ALL

	select e.EmployeeID, e. ManagerID, e.JobTitle, c.depth + 1
	from employees e
	INNER JOIN cte c
	ON e.ManagerID=c.EmployeeID
)
select EmployeeID, ManagerID, JobTitle, Depth
from cte
order by EmployeeID

--Task 2

--Find Factorials up to N .

--Expected output for N = 10 :
--Num 	Factorial
--1 	1
--2 	2
--3 	6
--4 	24
--5 	120
--6 	720
--7 	5040
--8 	40320
--9 	362880
--10 	3628800

-- Declare the input parameter N
DECLARE @N INT = 10;

-- Recursive CTE to generate numbers from 1 to N
WITH NumberSequence AS (
    -- Base case: Start with 1
     SELECT 1 AS Num
    
    UNION ALL
    
    -- Recursive part: Generate numbers up to N
    SELECT Num + 1
    FROM NumberSequence
    WHERE Num < @N
),
FactorialCalc AS (
    -- Base case: Start with Num and initial Factorial = 1 (cast to BIGINT)
    SELECT Num, CAST(1 AS BIGINT) AS Factorial, 1 AS Counter
    FROM NumberSequence
    
    UNION ALL
    
    -- Recursive part: Multiply Factorial by Counter and increment Counter
    SELECT f.Num, 
           CAST(f.Factorial * f.Counter AS BIGINT) AS Factorial,
           f.Counter + 1
    FROM FactorialCalc f
    WHERE f.Counter <= f.Num
)
-- Final query: Select the maximum Counter for each Num to get the final Factorial
SELECT Num, MAX(Factorial) AS Factorial
FROM FactorialCalc
GROUP BY Num
ORDER BY Num;


--Task 3

--Find Fibonacci numbers up to N .

--Expected output for N = 10 :
--n 	Fibonacci_Number
--1 	1
--2 	1
--3 	2
--4 	3
--5 	5
--6 	8
--7 	13
--8 	21
--9 	34
--10 	55

-- Declare the input parameter N
DECLARE @N INT = 10;

-- Recursive CTE to generate Fibonacci numbers
WITH FibonacciSequence AS (
    -- Base case: Initialize first two Fibonacci numbers
    SELECT 1 AS n, CAST(1 AS BIGINT) AS Fibonacci_Number, CAST(1 AS BIGINT) AS Previous_Fibonacci
    UNION ALL
    SELECT 2 AS n, CAST(1 AS BIGINT) AS Fibonacci_Number, CAST(1 AS BIGINT) AS Previous_Fibonacci
    
    UNION ALL
    
    -- Recursive part: Generate next n and compute next Fibonacci number
    SELECT f.n + 1,
           CAST(f.Fibonacci_Number + f.Previous_Fibonacci AS BIGINT) AS Fibonacci_Number,
           f.Fibonacci_Number AS Previous_Fibonacci
    FROM FibonacciSequence f
    WHERE f.n < @N
),
-- Select only the latest Fibonacci number for each n
FibonacciResults AS (
    SELECT n, Fibonacci_Number,
           ROW_NUMBER() OVER (PARTITION BY n ORDER BY Fibonacci_Number DESC) AS rn
    FROM FibonacciSequence
)
-- Final query: Select n and Fibonacci_Number where rn = 1
SELECT n, Fibonacci_Number
FROM FibonacciResults
WHERE rn = 1
AND n <= 10
ORDER BY n;



		
		








--Task 1:

--If all the columns having zero value then don't show that row.
truncate table [TestMultipleZero]
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

select * from [TestMultipleZero]

select *
from [TestMultipleZero]
delete from [TestMultipleZero] where A=0 and B=0 and C=0 and D=0;

--Task 2

--Write a query which will find maximum value from multiple columns of the table.

CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);
select*from TestMax

select year1,
	case
		when Max1>=Max2 and Max1>=Max3 then Max1
		when Max2>=Max1 and Max2>=Max3 then Max2
		else Max3
	end as Max_values
from testmax;


--Task 3

--Write a query which will find the Date of Birth of employees whose birthdays lies between May 7 and May 15.

CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

select*from EmpBirth;

select *
from EmpBirth
where (day(Birthdate) between 7 and 15) and month(birthdate)=5;

--Task 4

--    Order letters but 'b' must be first/last
--    Order letters but 'b' must be 3rd (Optional)

create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

  ---first
select letter from letters
order by
case when letter='b' then 0 else 1 end,
letter;


  ---last
select letter from letters
order by
case when letter='b' then 1 else 0 end,
letter;




--    1.Write an SQL statement that counts the consecutive values in the Status field.

--Input table (Groupings):
--     Step Number 	Status
--		    1 	    Passed
--			2 	    Passed
--			3 	    Passed
--			4 	    Passed
--			5 	    Failed
--			6 	    Failed
--			7 	    Failed
--			8 	    Failed
--			9 	    Failed
--			10 	    Passed
--			11 	    Passed
--			12      Passed

--Expected Output:

--Min Step Number 	Max Step Number 	Status 	Consecutive Count
--			1 	       4 	             Passed 	4
--			5 	       9                 Failed  	5
--			10 	       12 	             Passed 	3


drop table groupings
create table Groupings
(
	StepNumber int,
	Status varchar(50)
);
insert into Groupings
values
	(1, 'Passed'),
	(2,  'Passed'),
	(3,  'Passed'),
	(4,  'Passed'),
	(5,  'Failed'),
	(6,	 'Failed'),
    (7,  'Failed'),
	(8,	 'Failed'),
	(9,  'Failed'),
	(10, 'Passed'),
	(11, 'Passed'),
	(12, 'Passed');

select*from Groupings

--Min Step Number 	Max Step Number 	Status 	Consecutive Count
--			1 	       4 	             Passed 	4
--			5 	       9                 Failed  	5
--			10 	       12 	             Passed 	3


select
	min(StepNumber) as MinStepNumber,
	max(stepnumber) as MaxStepNumber,
	Status,
	count(*) as ConsecuitiveCount
from (
	select 
		StepNumber,
		Status,
		(row_number()over(order by StepNumber)-
		row_number() over(partition by Status order by StepNumber)) as GroupID
	from groupings
) as StatusGroups
Group by status, GroupID
order By Minstepnumber;



--2.Find all the year-based intervals from 1975 up to current when the company did not hire employees.

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
);

INSERT INTO [dbo].[EMPLOYEES_N]
VALUES
	(1001,'Pawan','1975-02-21'),
	(1002,'Ramesh','1976-02-21'),
	(1003,'Avtaar','1977-02-21'),
	(1004,'Marank','1979-02-21'),
	(1008,'Ganesh','1979-02-21'),
	(1007,'Prem','1980-02-21'),
	(1016,'Qaue','1975-02-21'),
	(1155,'Rahil','1975-02-21'),
	(1102,'Suresh','1975-02-21'),
	(1103,'Tisha','1975-02-21'),
	(1104,'Umesh','1972-02-21'),
	(1024,'Veeru','1975-02-21'),
	(1207,'Wahim','1974-02-21'),
	(1046,'Xhera','1980-02-21'),
	(1025,'Wasil','1975-02-21'),
	(1052,'Xerra','1982-02-21'),
	(1073,'Yash','1983-02-21'),
	(1084,'Zahar','1984-02-21'),
	(1094,'Queen','1985-02-21'),
	(1027,'Ernst','1980-02-21'),
	(1116,'Ashish','1990-02-21'),
	(1225,'Bushan','1997-02-21');

select*from employees_n

--Expected Output:
--Years
--1978 - 1978
--1981 - 1981
--1986 - 1989
--1991 - 1996
--1998 - 2025

;with hire_years AS(
	select distinct year(hire_date) y
	from employees_n
), all_years as (
	select 1974+ordinal as y
	from string_split(replicate(',', year(getdate()) - 1975), ',', 1)
), not_hire_years as(
	select a.y
	from all_years a
	left join hire_years b
	on a.y=b.y
	where b.y is null
)
select concat(min(y), '-', max(y)) as NOT_HIRED_YEARS
from
(
	select y,
		y-row_number()over(order by y) as grp
	from not_hire_years
) t
group by grp;








		

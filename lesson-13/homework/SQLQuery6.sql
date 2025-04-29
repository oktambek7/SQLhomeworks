--Calendar Table Query with Sunday as First Column

--You will create an SQL Server query that generates a tabular representation of a given month, displaying the days of each week in separate columns, with Sunday as the first column and Saturday as the last column.


------===================CALENDAR


declare @inputDate date = getdate()

;with cte as(
	select datefromparts(Year(@inputDate), month(@inputdate), 1) as [date],
	datename(weekday, datefromparts(Year(@inputDate), month(@inputdate), 1)) as weekday_name,
	datepart(weekday, datefromparts(Year(@inputDate), month(@inputdate), 1)) as weekday_num,
	1 as weeknumber

	UNION ALL

	select
	dateadd(day, 1, [date]),
	datename(weekday, dateadd(day, 1, [date])),
	datepart(weekday, dateadd(day, 1, [date])),
	case 
		when datepart(weekday, dateadd(day, 1, [date])) > weekday_num then weeknumber else weeknumber+1
	end
	from cte
	where [date]<EOMONTH(@inputdate)
)

select
	max(case when weekday_name='Sunday' then day(date) end) as Sunday,
	max(case when weekday_name='Monday' then day(date) end) as Monday,
	max(case when weekday_name='Tuesday' then day(date) end) as Tuesday,
	max(case when weekday_name='Wednesday' then day(date) end) as Wednesday,
	max(case when weekday_name='Thursday' then day(date) end) as Thursday,
	max(case when weekday_name='Friday' then day(date) end) as Friday,
	max(case when weekday_name='Saturday' then day(date) end) as Saturday
from
	cte
group by weeknumber;

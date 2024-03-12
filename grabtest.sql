--create database Grabtest
GO
use Grabtest
/*
create table candidate(
			employee_id int primary key,
			experience varchar(30),
			salary int
			)
GO
insert into  candidate ( employee_id,experience, salary)
values( 1,'Junior',10000),
		(9,'Junior',10000),
		(2,'Senior',20000),
		(11,'Senior',20000),
		(13,'Senior',50000),
		(4,'Junior',40000)
*/ 
--select * from candidate
WITH -- calculate culativesum partition base experience
CTE1 as (
	SELECT *,
		SUM(salary) OVER(PARTITION BY experience ORDER BY salary ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS culativesum 
	FROM candidate 
),
-- calculate max quantity senior in budget 70000
CTE2 as (
	SELECT *,
		(CASE 
			WHEN culativesum <70000 AND experience = 'Senior'  THEN 1 
		END) as approve_senior
	FROM CTE1
		),
-- calculate max quantity juninor after max quantity senior
CTE3 as(
		SELECT *,
		(CASE 
			WHEN culativesum < (70000- (SELECT MAX(culativesum) FROM CTE2 where experience = 'Senior' and approve_senior = 1 )) and experience = 'Junior' then 1
		END) as approve_junior		
		FROM CTE2
		),
-- summary quantity senior and junior
CTE4 as(
		SELECT experience,
			count(approve_senior) as a,
			count(approve_junior) as b
		FROM CTE3
		GROUP BY experience
		)
-- tranform 2 col quantity to 1 col base on output of topic
SELECT experience, 
		(case 
			when a = 0 then b
			else a
		end) as accepted_candidates 
FROM CTE4
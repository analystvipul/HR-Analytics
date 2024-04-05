create schema employee_retention;
use employee_retention;
desc hr_1;
desc hr_2;
show tables;
select * from hr_1;
select * from hr_2;

/* 1-- Average Attrition Rate for All Department -- */
select a.Department, concat(format(avg(a.attrition_y)*100,2),'%') as Attrition_Rate
from  
( select department,attrition,
case when attrition='Yes'
then 1
Else 0
End as attrition_y from hr_1 ) as a
group by a.department;

/*  2-- Average Hourly Rate for Male Research Scientist --*/
select JobRole, format(avg(hourlyrate),2) as Average_HourlyRate,Gender
from hr_1
where upper(jobrole)= 'RESEARCH SCIENTIST' and upper(gender)='MALE'
group by jobrole,gender;

/* 3-- AttritionRate VS MonthlyIncomeStats against department-- */
select a.department, concat(format(avg(a.attrition_rate)*100,2),'%') as Average_attrition,format(avg(b.monthlyincome),2) as Average_Monthly_Income
from ( select department,attrition,employeenumber,
case when attrition = 'yes' then 1
else 0
end as attrition_rate from hr_1) as a
inner join hr_2 as b on b.employeeid = a.employeenumber
group by a.department;

/* 4-- Average Working Years for Each Department -- */
select a.department, format(avg(b.TotalWorkingYears),1) as Average_Working_Year
from hr_1 as a
inner join hr_2 as b on b.EmployeeID=a.EmployeeNumber
group by a.department;


/* 5-- Job Role VS Work Life Balance -- */
select a.JobRole,
sum(case when performancerating = 1 then 1 else 0 end) as 1st_Rating_Total,
sum(case when performancerating = 2 then 1 else 0 end) as 2nd_Rating_Total,
sum(case when performancerating = 3 then 1 else 0 end) as 3rd_Rating_Total,
sum(case when performancerating = 4 then 1 else 0 end) as 4th_Rating_Total, 
count(b.performancerating) as Total_Employee, format(avg(b.WorkLifeBalance),2) as Average_WorkLifeBalance_Rating
from hr_1 as a
inner join hr_2 as b on b.EmployeeID = a.Employeenumber
group by a.jobrole;

/* 6-- Attrition Rate Vs Year Since Last Promotion Relation Against Job Role -- */
SELECT
    h1.Department,
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 0 AND 5 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 0 AND 5 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS '0-5 Years',
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 6 AND 10 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 6 AND 10 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS '6-10 Years',
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 11 AND 15 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 11 AND 15 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS '11-15 Years',
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 16 AND 20 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 16 AND 20 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS '16-20 Years',
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 21 AND 25 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 21 AND 25 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS '21-25 Years',
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 26 AND 30 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion BETWEEN 26 AND 30 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS '26-30 Years',
    CONCAT(
        FORMAT(
            COUNT(CASE WHEN h2.YearsSinceLastPromotion > 30 AND h1.Attrition = 'Yes' THEN 1 END) / COUNT(CASE WHEN h2.YearsSinceLastPromotion > 30 THEN 1 END) * 100, 2
        ),
        '%'
    ) AS 'Above 30'
FROM
    hr_1 h1
INNER JOIN
    hr_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY
    h1.Department;

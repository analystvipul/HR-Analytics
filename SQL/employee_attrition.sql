select *
from hr_joined;

#1 Query to find details of employee under attritiom having 5+ yrs of experience in between age group of 27-35

select *
from hr_joined
where age between 27 and 35
and TotalWorkingYears >= 5;

#2 Fethch details of employees having max and min salary working in different departments who received less than 13% salary hike

select department,
	max(MonthlyIncome),
    min(MonthlyIncome)
from hr_joined
where PercentSalaryHike < 13
group by Department;

#3 Calculating average monthly income of all the employees who worked more than 3 years whose education background is medical

select EducationField, avg(MonthlyIncome)
from hr_joined
where YearsAtCompany > 3
and EducationField = "Medical"
group by EducationField;

#4 Total no. of male and female employees under attrition whose marital status is married and havent received promotion in last 2 years

select gender, count(EmployeeId)
from hr_joined
where MaritalStatus = "Married"
and YearsSinceLastPromotion = 2
and Attrition = "Yes"
group by Gender;

#5 Employees with max performance rating but no promotion for 4 years and above

select *
from hr_joined
where PerformanceRating = (
select max(PerformanceRating)
from hr_joined)
and YearsSinceLastPromotion >= 4;

#6 max and min percent salary hike

select YearsAtCompany, PerformanceRating, YearsSinceLastPromotion,
	max(PercentSalaryHike),
    min(PercentSalaryHike)
from hr_joined
group by YearsAtCompany, PerformanceRating, YearsSinceLastPromotion
order by max(PercentSalaryHike) desc,
min(PercentSalaryHike) asc;

#7 employees working overtime but given min salary hike and are more than  5 years with company

select *
from hr_joined
where OverTime = "Yes"
and PercentSalaryHike = (select
min(PercentSalaryHike)
from hr_joined)
and YearsAtCompany > 5
and Attrition = "Yes";

#8 employees working overtime and given max salary hike but worked less than  5 years with company

select *
from hr_joined
where OverTime = "Yes"
and PercentSalaryHike = (select
max(PercentSalaryHike)
from hr_joined)
and YearsAtCompany < 5;

#9 employees not working overtime and given max salary hike but worked less than  5 years with company

select *
from hr_joined
where OverTime = "No"
and PercentSalaryHike = (select
max(PercentSalaryHike)
from hr_joined)
and YearsAtCompany < 5;

################################

-- 1. Overall Attrition Rate
SELECT 
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Overall_Attrition_Rate
FROM HR_Joined;

-- 2. Attrition by Categorical Variables
SELECT 
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY Department;

SELECT 
    Gender,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY Gender;

-- Repeat for other categorical variables like job role, education field, etc.

-- 3. Attrition by Numerical Variables
SELECT 
    ROUND(AVG(Age), 2) AS Average_Age,
    ROUND(AVG(MonthlyIncome), 2) AS Average_Income,
    ROUND(AVG(TotalWorkingYears), 2) AS Average_Total_Working_Years,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined;

-- You can explore the relationship between attrition and other numerical variables using similar queries.

-- 4. Identify Correlated Factors
SELECT 
    Department,
    Gender,
    ROUND(AVG(Age), 2) AS Average_Age,
    ROUND(AVG(MonthlyIncome), 2) AS Average_Income,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY Department, Gender;

##########################################

-- T-test for numerical variables (example with MonthlyIncome)
SELECT 
    'MonthlyIncome' AS Variable,
    CASE WHEN AVG(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) IS NULL THEN 0 ELSE AVG(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) END AS Attrition_MonthlyIncome,
    CASE WHEN AVG(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END) IS NULL THEN 0 ELSE AVG(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END) END AS No_Attrition_MonthlyIncome,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) - AVG(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END), 2) AS Difference,
    ROUND((STDDEV(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) / SQRT(COUNT(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END))) + (STDDEV(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END) / SQRT(COUNT(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END))), 2) AS Standard_Error,
    ROUND((AVG(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) - AVG(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END)) / (STDDEV(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) / SQRT(COUNT(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END))), 2) AS T_Value,
    COUNT(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome ELSE NULL END) AS Attrition_Count,
    COUNT(CASE WHEN Attrition = 'No' THEN MonthlyIncome ELSE NULL END) AS No_Attrition_Count
FROM HR_Joined;

-- 7. Explore Attrition Patterns Over Employee Lifecycle (example with YearsSinceLastPromotion)
SELECT 
    YearsSinceLastPromotion,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

-- 8. Segmentation Analysis (example with Age and Department)
SELECT 
    Age,
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY Age, Department;

##################################################


-- 11. Cross-tabulations and Heatmaps (example with JobRole and Department)
SELECT 
    JobRole,
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY JobRole, Department
ORDER BY JobRole, Department;


-- 14. Employee Satisfaction and Engagement (example with JobSatisfaction)
SELECT 
    JobSatisfaction,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

###
SELECT 
    (COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS Total_Attrition_Percent
FROM HR_Joined;


###
SELECT 
    Education,
    CASE 
        WHEN Education = 1 THEN 'Secondary School (10th Grade)'
        WHEN Education = 2 THEN 'Higher Secondary School (12th Grade)'
        WHEN Education = 3 THEN 'Bachelor\'s Degree'
        WHEN Education = 4 THEN 'Master\'s Degree'
        WHEN Education = 5 THEN 'Doctorate'
        ELSE 'Unknown'
    END AS Education_Level_India
FROM HR_Joined;



#########################################
################   KPI   ################
#########################################

#1 Average Attrition Rate for all Departments:
SELECT 
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY Department;

#2 Average Hourly Rate of Male Research Scientists:
SELECT 
    AVG(HourlyRate) AS Avg_Hourly_Rate
FROM HR_Joined
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';

#3 Attrition Rate Vs Monthly Income Stats:
SELECT 
    CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low'
        WHEN MonthlyIncome >= 5000 AND MonthlyIncome < 10000 THEN 'Medium'
        ELSE 'High'
    END AS Income_Group,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY Income_Group;

#4 Average Working Years for each Department:
SELECT 
    Department,
    ROUND(AVG(TotalWorkingYears)) AS Avg_Working_Years
FROM HR_Joined
GROUP BY Department;


#5 Job Role Vs Work Life Balance:
SELECT 
    JobRole,
    ROUND(AVG(WorkLifeBalance)) AS Avg_WorkLife_Balance
FROM HR_Joined
GROUP BY JobRole;


#6 Attrition Rate Vs Year Since Last Promotion Relation:
SELECT 
    YearsWithCurrManager,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Rate
FROM HR_Joined
GROUP BY YearsWithCurrManager;

######################################################
################## Views ##############################
######################################################

#1 Average Attrition Rate for all Departments:
CREATE VIEW AvgAttritionRateByDepartment AS
SELECT 
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AvgAttritionRate
FROM HR_Joined
GROUP BY Department;

#2 Average Hourly Rate of Male Research Scientists:
CREATE VIEW AvgHourlyRateMaleResearchScientists AS
SELECT 
    AVG(HourlyRate) AS AvgHourlyRate
FROM HR_Joined
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';

#3 Attrition Rate Vs Monthly Income Stats:
CREATE VIEW AttritionRateVsMonthlyIncome AS
SELECT 
    CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low'
        WHEN MonthlyIncome >= 5000 AND MonthlyIncome < 10000 THEN 'Medium'
        ELSE 'High'
    END AS Income_Group,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionRate
FROM HR_Joined
GROUP BY Income_Group;

#4 Average Working Years for each Department:
CREATE VIEW AvgWorkingYearsByDepartment AS
SELECT 
    Department,
    ROUND(AVG(TotalWorkingYears)) AS AvgWorkingYears
FROM HR_Joined
GROUP BY Department;

#5 Job Role Vs Work Life Balance:
CREATE VIEW AvgWorkLifeBalanceByJobRole AS
SELECT 
    JobRole,
    ROUND(AVG(WorkLifeBalance)) AS AvgWorkLifeBalance
FROM HR_Joined
GROUP BY JobRole;

#6 Attrition Rate Vs Year Since Last Promotion Relation:
CREATE VIEW AttritionRateVsYearsSinceLastPromotion AS
SELECT 
    YearsSinceLastPromotion,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionRate
FROM HR_Joined
GROUP BY YearsSinceLastPromotion;

CREATE VIEW All_KPIs_View AS
SELECT 
    'Average Attrition Rate for all Departments' AS KPI,
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Value
FROM HR_Joined
GROUP BY Department

UNION ALL

SELECT 
    'Average Hourly Rate of Male Research Scientists' AS KPI,
    NULL AS Department,
    AVG(HourlyRate) AS Value
FROM HR_Joined
WHERE Gender = 'Male' AND JobRole = 'Research Scientist'

UNION ALL

SELECT 
    'Attrition Rate Vs Monthly Income Stats' AS KPI,
    CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low'
        WHEN MonthlyIncome >= 5000 AND MonthlyIncome < 10000 THEN 'Medium'
        ELSE 'High'
    END AS Income_Group,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Value
FROM HR_Joined
GROUP BY Income_Group

-- Add more queries for other KPIs here...

;















CREATE VIEW KPI_1 AS
SELECT
    Department,
    CONCAT(FORMAT(AVG(attrition_y) * 100, 2), '%') AS Attrition_Rate
FROM  
    (
        SELECT
            Department,
            Attrition,
            CASE
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END AS attrition_y
        FROM
            hr_1
    ) AS a
GROUP BY
    Department;

CREATE VIEW KPI_2 AS
SELECT
    JobRole,
    FORMAT(AVG(HourlyRate), 2) AS Average_HourlyRate,
    Gender
FROM
    hr_1
WHERE
    UPPER(JobRole) = 'RESEARCH SCIENTIST'
    AND UPPER(Gender) = 'MALE'
GROUP BY
    JobRole,
    Gender;

CREATE VIEW KPI_3 AS
SELECT
    a.Department,
    CONCAT(FORMAT(AVG(a.attrition_rate) * 100, 2), '%') AS Average_attrition,
    FORMAT(AVG(b.monthlyincome), 2) AS Average_Monthly_Income
FROM
    (
        SELECT
            Department,
            Attrition,
            employeenumber,
            CASE
                WHEN Attrition = 'yes' THEN 1
                ELSE 0
            END AS attrition_rate
        FROM
            hr_1
    ) AS a
    INNER JOIN hr_2 AS b ON b.employeeid = a.employeenumber
GROUP BY
    a.Department;

CREATE VIEW KPI_4 AS
SELECT
    a.Department,
    FORMAT(AVG(b.TotalWorkingYears), 1) AS Average_Working_Year
FROM
    hr_1 AS a
    INNER JOIN hr_2 AS b ON b.EmployeeID = a.EmployeeNumber
GROUP BY
    a.Department;

CREATE VIEW KPI_5 AS
SELECT
    a.JobRole,
    SUM(CASE WHEN Performancerating = 1 THEN 1 ELSE 0 END) AS '1st_Rating_Total',
    SUM(CASE WHEN Performancerating = 2 THEN 1 ELSE 0 END) AS '2nd_Rating_Total',
    SUM(CASE WHEN Performancerating = 3 THEN 1 ELSE 0 END) AS '3rd_Rating_Total',
    SUM(CASE WHEN Performancerating = 4 THEN 1 ELSE 0 END) AS '4th_Rating_Total', 
    COUNT(b.performancerating) AS Total_Employee,
    FORMAT(AVG(b.WorkLifeBalance), 2) AS Average_WorkLifeBalance_Rating
FROM
    hr_1 AS a
    INNER JOIN hr_2 AS b ON b.EmployeeID = a.EmployeeNumber
GROUP BY
    a.JobRole;

    
  CREATE VIEW KPI_6 AS
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




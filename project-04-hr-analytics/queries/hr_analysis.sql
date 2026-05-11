-- Count total employees in dataset
SELECT COUNT(*) FROM hr_data;

--  Overall attrition rate?
SELECT 
    Attrition,
    COUNT(*) as Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hr_data), 2) AS Percentage
FROM hr_data
GROUP BY Attrition;

--  Department has the highest attrition
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate
FROM hr_data
GROUP BY Department
ORDER BY Attrition_Rate DESC;

-- Average salary by department
SELECT 
    Department,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Monthly_Income
FROM hr_data
GROUP BY Department
ORDER BY Avg_Monthly_Income DESC;

SELECT 
    Attrition,
	JobRole,
    COUNT(*) AS Total_Employees
FROM hr_data
GROUP BY JobRole
ORDER BY Total_Employees DESC;

-- Overtime vs attrition
SELECT 
    OverTime, 
    Attrition, 
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY OverTime, Attrition;


-- Average age of employers who stayed
SELECT 
    Attrition, 
    AVG(Age) AS Average_Age
FROM Employees
GROUP BY Attrition;


-- Q3: Which Job Role has highest attrition?
-- We filter for only those who left (Attrition = 'Yes'), then group by JobRole 
-- and sort the results from highest to lowest to find the role with the most departures.
SELECT 
    JobRole, 
    COUNT(*) AS AttritionCount
FROM Employees
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY AttritionCount DESC;
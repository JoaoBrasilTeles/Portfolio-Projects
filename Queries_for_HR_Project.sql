  -- Visualize inicial Data -- 

SELECT TOP 15 * FROM EmployeeAttrition; 

SELECT COUNT(DISTINCT PerformanceRating) FROM EmployeeAttrition

SELECT COUNT(*) FROM EmployeeAttrition
  -- Creat an Id column to conect tables -- 

ALTER TABLE EmployeeAttrition
ADD Id int identity(1,1)


  -- Analysis by gender, maritial status and age --

     -- Preview of data -- 
	    
		-- Gender --

	SELECT Attrition, Gender, COUNT(*) AS NumofEmp
	FROM EmployeeAttrition
	GROUP BY Attrition, Gender
	ORDER BY Attrition, NumofEmp DESC

			-- Conclusion : Almost 2/3 of emp that had attrition are male --

        -- Maritial Status --
	
SELECT Attrition, MaritalStatus, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition, MaritalStatus
ORDER BY Attrition, NumofEmp DESC


			-- Conclusion : Half of the attrition are of single emp, eventhough there are much more married people overall --

		-- Age --

SELECT Attrition,
	   MIN(Age) AS min,
	   AVG(Age) AS avg,
	   MAX(Age) AS max,
	   STDEV(Age) AS stdev
FROM EmployeeAttrition
GROUP BY Attrition


SELECT Age, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Age
ORDER BY Age ASC




WITH ageCTE AS
(
		SELECT Attrition,
			   Age, 
			   'Age_range' = CASE
					WHEN Age >= 18 AND Age <=25 THEN '18-25'
					WHEN Age >= 26 AND Age <=35 THEN '26-35'
					WHEN Age >= 36 AND Age <=45 THEN '36-45'
					WHEN Age >= 46 AND Age <=55 THEN '46-55'
					ELSE '56-60'
					END
		FROM EmployeeAttrition
)
,
TOTALCTE AS
(
SELECT Age_Range, COUNT(*) AS TotalNumofEmp, ROUND((COUNT(*)/1470.00)*100,2) AS TotalPorcentile
FROM ageCTE
GROUP BY Age_Range
)
, 
SEGMENTEDCTE AS
(
SELECT Attrition, 
	   Age_range, 
	   COUNT(*) AS NumofEmp,
	   'Percentile' = CASE
			WHEN Attrition = 0 THEN ROUND((COUNT(*)/1233.00)*100,2)
			WHEN Attrition = 1 THEN ROUND((COUNT(*)/237.00)*100,2)
			END
FROM ageCTE
GROUP BY Attrition, Age_range
)
SELECT s.Attrition, S.Age_range,s.NumofEmp,t.TotalNumofEmp,s.Percentile,t.TotalPorcentile
FROM SEGMENTEDCTE AS s
FULL OUTER JOIN TOTALCTE AS t
ON s.Age_range = t.Age_range
GROUP BY s.Attrition, S.Age_range,s.NumofEmp,s.Percentile,t.TotalNumofEmp,t.TotalPorcentile
ORDER BY S.Attrition, S.Age_range ASC

			-- Conclusion: The proportion between the total num of emp and the num of emp with attrition --
			-- highlights the fact that 48.95% are in the age range of 26-35 --


     -- Data to visuzalize rate of attrition by gender and maritial status --
 
SELECT Id, Attrition, Gender, MaritalStatus, Age
FROM EmployeeAttrition
   

  -- Analysis by job -- 

     -- Preview of Data --

		-- Job Level --

SELECT Attrition, JobLevel, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition, JobLevel
ORDER BY Attrition, NumofEmp DESC


			-- Conclusion : Huge mayority of emp with attrition are level 1/2 --

		-- Job Satisfaction -- 

SELECT Attrition, JobSatisfaction, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition, JobSatisfaction
ORDER BY Attrition, NumofEmp DESC

SELECT AVG(JobSatisfaction) AS JB_avg FROM EmployeeAttrition

			-- Conclusion : Highest number of emp that had attrition are those who claimed 3 out 4 of satisfaction --
			-- and the avg is 2 --

		-- Num of Companies Worked --

SELECT Attrition, NumCompaniesWorked, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition, NumCompaniesWorked
ORDER BY Attrition, NumofEmp DESC

SELECT AVG(NumCompaniesWorked) AS CW_avg FROM EmployeeAttrition

			-- Conclusion : People with one company exp or none are more likely to exit and the avg is 2--

		-- Data for visualization --
   
SELECT Id, Attrition, JobLevel, JobSatisfaction, NumCompaniesWorked
FROM EmployeeAttrition
ORDER BY Attrition, JobLevel, JobSatisfaction, NumCompaniesWorked ASC



	-- Analysis of Department, salary and History in company --

	   -- Preview of Data -- 

		  -- Department -- 

SELECT Attrition, COUNT(*) AS NumofEmp FROM EmployeeAttrition
GROUP BY Attrition

SELECT Department, 
	   COUNT(*) AS NumofEmp,
	   (COUNT(*)/1470.00)*100 AS Porcentile	   
FROM EmployeeAttrition
GROUP BY Department
ORDER BY NumofEmp DESC

SELECT Attrition, Department, COUNT(*) AS NumofEmp, 
	  'Percentile' = CASE
			WHEN Attrition = 0 THEN ROUND((COUNT(*)/1233.00)*100,2)
			WHEN Attrition = 1 THEN ROUND((COUNT(*)/237.00)*100,2)
			END
FROM EmployeeAttrition
GROUP BY Attrition, Department
ORDER BY Attrition, NumofEmp DESC

			-- Conclusion: The rate of attrition follows a proportion within the overall number of emp and the num of 
			-- emp with and  without attrition --

		 -- Salary -- 

SELECT COUNT(MonthlyIncome), COUNT(DISTINCT MonthlyIncome) FROM EmployeeAttrition

SELECT Attrition,
	   MIN(MonthlyIncome) AS min, 
	   AVG(MonthlyIncome) AS avg, 
	   MAX(MonthlyIncome) AS max
FROM EmployeeAttrition
GROUP BY Attrition

			-- Conclusion: It doesn't seem to be a big realtion within attrition and salary, what may indicate that 
			-- attrition is more related with the environment --

			
		-- Company

SELECT  Attrition,
	TrainingTimesLastYear, 
	YearsAtCompany, 
	YearsInCurrentRole, 
	YearsSinceLastPromotion,
	YearsWithCurrManager,TotalWorkingYears, 
	WorkLifeBalance
FROM EmployeeAttrition;

                             -- Years at company and attrition x avg worlife balance --

SELECT Attrition, YearsAtCompany,AVG(WorkLifeBalance) AS worklife_avg
FROM EmployeeAttrition
GROUP BY Attrition, YearsAtCompany
ORDER BY Attrition, YearsAtCompany ASC

							 -- Years at company x attrition --

SELECT Attrition,YearsAtCompany, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition,YearsAtCompany
ORDER BY Attrition, YearsAtCompany ASC

							 -- attrition x worklife balance --

SELECT Attrition, WorkLifeBalance, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition, WorkLifeBalance
ORDER BY Attrition, WorkLifeBalance ASC

							 -- Years w/ curr manager x attrition --

SELECT Attrition,YearsWithCurrManager,COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition,YearsWithCurrManager
ORDER BY Attrition, YearsWithCurrManager ASC

							-- Years as curr role x attrition --

SELECT Attrition, YearsInCurrentRole, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition,YearsInCurrentRole
ORDER BY Attrition,YearsInCurrentRole ASC

							-- Training Last Year x attrition --

SELECT Attrition, TrainingTimesLastYear, COUNT(*) AS NumofEmp
FROM EmployeeAttrition
GROUP BY Attrition, TrainingTimesLastYear
ORDER BY Attrition, TrainingTimesLastYear ASC

						-- Conclusion: employees are more likely to exit with they fit in the following --
						-- segments, untill 5 years in the company work life balance claimed as 3, --
						-- untill 4 years with the same manager, untill 4 years at the same role, --
						-- and 2 or 3 trainments last year --

				  -- Data for Visualization --

SELECT  Id,Attrition, 
	YearsAtCompany,
	WorkLifeBalance, 
	YearsWithCurrManager, 
	YearsInCurrentRole, 
	TrainingTimesLastYear, 
	Department,MonthlyIncome
FROM EmployeeAttrition


		-- In order to be more organized and make easier the formulation of reporting in power bi, -- 
		-- I will donwload the tables from the "Data for Visualization" query but they could also be caught by 
		-- the query that follows: --

SELECT 	Id,
	Attrition, 
	Gender, 
	MaritalStatus, 
	Age, 
	JobLevel, 
	JobSatisfaction, 
	NumCompaniesWorked, 
	YearsAtCompany,
	WorkLifeBalance, 
	YearsWithCurrManager, 
	YearsInCurrentRole, 
	TrainingTimesLastYear,
	Department,MonthlyIncome
FROM EmployeeAttrition

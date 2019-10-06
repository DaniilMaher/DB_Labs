USE AdventureWorks2012;
GO

SELECT E.BusinessEntityID, E.JobTitle, MAX(EPH.Rate) as MaxRate  
FROM HumanResources.Employee AS E
JOIN HumanResources.EmployeePayHistory AS EPH 
ON E.BusinessEntityID = EPH.BusinessEntityID
GROUP BY E.BusinessEntityID, E.JobTitle;
GO

SELECT E.BusinessEntityID, E.JobTitle, EPH.Rate, DENSE_RANK() OVER(ORDER BY EPH.Rate) RankRate
FROM HumanResources.Employee AS E
JOIN HumanResources.EmployeePayHistory AS EPH 
ON EPH.BusinessEntityID = E.BusinessEntityID
ORDER BY EPH.Rate
GO


SELECT Dep.Name AS DepName, E.BusinessEntityID, E.JobTitle, EDH.ShiftID
FROM HumanResources.Employee AS E
JOIN HumanResources.EmployeeDepartmentHistory AS EDH 
ON EDH.BusinessEntityID = E.BusinessEntityID
JOIN HumanResources.Department AS Dep 
ON Dep.DepartmentID = EDH.DepartmentID
WHERE EDH.EndDate IS NULL
ORDER BY Dep.Name, 
	CASE WHEN Dep.Name = 'Document Control' THEN ShiftID 
	ELSE E.BusinessEntityID END
GO

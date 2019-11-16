USE AdventureWorks2012;
GO

CREATE FUNCTION GetDepartementsCount
(
	@DepartmentGroup NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*) FROM HumanResources.Department
		WHERE GroupName = @DepartmentGroup);
END
GO

SELECT * FROM HumanResources.Department;
SELECT dbo.GetDepartementsCount('Manufacturing');
GO

CREATE FUNCTION GetTop3Employee
(
	@DepartmentID INT
)
RETURNS TABLE 
AS RETURN 
(
	SELECT TOP 3 
	D.DepartmentID,
	D.Name,
	EDH.StartDate,
	E.BusinessEntityID,
	LoginID,
	JobTitle,
	BirthDate
	FROM HumanResources.EmployeeDepartmentHistory AS EDH 
	JOIN HumanResources.Employee AS E ON E.BusinessEntityId = EDH.BusinessEntityID
	JOIN HumanResources.Department AS D ON EDH.DepartmentID = D.DepartmentID
	WHERE EDH.DepartmentID = @DepartmentID AND StartDate >= '2005'
	ORDER BY E.BirthDate
)
GO

SELECT * FROM dbo.GetTop3Employee(3);
GO

SELECT * FROM HumanResources.Department
CROSS APPLY dbo.GetTop3Employee(DepartmentID);
GO

SELECT * FROM HumanResources.Department
OUTER APPLY dbo.GetTop3Employee(DepartmentID);
GO

CREATE FUNCTION GetTop3EmployeeMS
(
	@DepartmentID INT
)
RETURNS @Result TABLE 
(
	DepartmentID INT,
	Name NVARCHAR(50),
	StartDate DATETIME,
	BusinessEntityID INT,
	LoginID NVARCHAR(50),
	JobTitle NVARCHAR(50),
	BirthDate DATE
)
AS
BEGIN
	INSERT INTO @Result 
		SELECT TOP(3) 
		D.DepartmentID,
		D.Name,
		EDH.StartDate,
		E.BusinessEntityID,
		LoginID,
		JobTitle,
		BirthDate
		FROM HumanResources.EmployeeDepartmentHistory AS EDH 
		JOIN HumanResources.Employee AS E ON E.BusinessEntityId = EDH.BusinessEntityID
		JOIN HumanResources.Department AS D ON EDH.DepartmentID = D.DepartmentID
		WHERE EDH.DepartmentID = @DepartmentID AND StartDate >= '2005'
		ORDER BY E.BirthDate
	RETURN
END
GO

SELECT * FROM dbo.GetTop3EmployeeMS(3);
GO

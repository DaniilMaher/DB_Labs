USE AdventureWorks2012;
GO

CREATE TABLE dbo.Person (
	BusinessEntityID INT NOT NULL,  
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(8),
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR (10),
	EmailPromotion INT NOT NULL, 
	ModifiedDate DATETIME NOT NULL
);
GO

ALTER TABLE dbo.Person 
ADD ID BIGINT PRIMARY KEY IDENTITY(10, 10);
GO

ALTER TABLE dbo.Person 
ADD CHECK(Title IN ('Mr.', 'Ms.'));
GO

ALTER TABLE dbo.Person
ADD CONSTRAINT defSuffix DEFAULT 'N/A' FOR Suffix;
GO

INSERT INTO dbo.Person (BusinessEntityID, PersonType, NameStyle, Title, 
	FirstName, MiddleName,LastName, Suffix, EmailPromotion, ModifiedDate
)
SELECT Person.BusinessEntityID, PersonType, NameStyle, Title, FirstName, 
	MiddleName, LastName, Suffix, EmailPromotion, Person.ModifiedDate
FROM Person.Person
JOIN HumanResources.Employee AS E 
ON E.BusinessEntityID = Person.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory AS EDH 
ON EDH.BusinessEntityID = Person.BusinessEntityID
JOIN HumanResources.Department AS Dep 
ON Dep.DepartmentID = EDH.DepartmentID
WHERE EDH.EndDate IS NULL AND Dep.Name <> 'Executive'
GO

SELECT * FROM dbo.Person;
GO

ALTER TABLE dbo.Person
ALTER COLUMN Suffix NVARCHAR(5);
GO


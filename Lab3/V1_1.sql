USE AdventureWorks2012;
GO

ALTER TABLE dbo.Person 
ADD FullName NVARCHAR(100);
GO

DECLARE @person TABLE (
	ID BIGINT PRIMARY KEY IDENTITY(10, 10),
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

INSERT INTO @person (
	BusinessEntityID,  
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion, 
	ModifiedDate
) 
SELECT	
	BusinessEntityID,  
	PersonType,
	NameStyle,
	(
	SELECT 
		CASE Gender 
			WHEN 'M' THEN 'Mr.' 
			WHEN 'F' THEN 'Ms.' 
		END 
	FROM HumanResources.Employee
		WHERE HumanResources.Employee.BusinessEntityID = dbo.Person.BusinessEntityID),
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion, 
	ModifiedDate
FROM dbo.Person;

UPDATE dbo.Person
SET dbo.Person.FullName = PERS.Title + ' ' + PERS.FirstName + ' ' + PERS.LastName
FROM (SELECT * FROM @person) AS PERS
WHERE Person.BusinessEntityID = PERS.BusinessEntityID;

SELECT * FROM dbo.Person
GO

DELETE FROM dbo.Person
	WHERE LEN(FullName) > 20;

SELECT * FROM dbo.Person;
GO

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Person';
GO

SELECT
    Schema_name(t.Schema_id)AS SchemaName, 
    t.name AS TableName, 
    c.name AS ColumnName, 
    d.name AS DefaultConstraintName
FROM sys.default_constraints d
INNER JOIN sys.columns c ON
    d.parent_object_id = c.object_id
    AND d.parent_column_id = c.column_id
INNER JOIN sys.tables t ON
    t.object_id = c.object_id
WHERE Schema_name(t.Schema_id) = 'dbo' AND t.name = 'Person';
GO

ALTER TABLE dbo.Person DROP CONSTRAINT PK__Person__3214EC2719033404;
ALTER TABLE dbo.Person DROP CONSTRAINT CK__Person__Title__297722B6;
ALTER TABLE dbo.Person DROP COLUMN ID;
GO

DROP TABLE dbo.Person
GO

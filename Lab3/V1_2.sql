USE AdventureWorks2012;
GO

ALTER TABLE dbo.Person
ADD SalesYTD MONEY, 
	SalesLastYear MONEY,
	OrdersNum INT,
	SalesDiff AS SalesLastYear - SalesYTD
GO

CREATE TABLE #Person (
	BusinessEntityID INT PRIMARY KEY NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(8),
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(5),
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	SalesYTD MONEY, 
	SalesLastYear MONEY,
	OrdersNum INT,
)
GO

WITH OrdersCount AS 
(SELECT  
	BusinessEntityID,
	(SELECT COUNT(*) FROM Sales.SalesOrderHeader
	 WHERE dbo.Person.BusinessEntityID = Sales.SalesOrderHeader.SalesPersonID) AS OrdersNum
FROM dbo.Person)
INSERT INTO #Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	SalesYTD,
	SalesLastYear,
	OrdersNum
)	
SELECT 
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	(SELECT SalesYTD FROM Sales.SalesPerson
	 WHERE dbo.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID),
	(SELECT SalesLastYear FROM Sales.SalesPerson
	 WHERE dbo.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID),
	(SELECT OrdersNum FROM OrdersCount
	 WHERE dbo.Person.BusinessEntityID = OrdersCount.BusinessEntityID)
FROM dbo.Person;

SELECT * FROM #Person
GO

DELETE FROM dbo.Person WHERE BusinessEntityID = 290;

SELECT * FROM dbo.Person
ORDER BY BusinessEntityID
GO

MERGE INTO dbo.Person AS T
USING #Person AS S
ON T.BusinessEntityID = S.BusinessEntityID
WHEN MATCHED THEN UPDATE SET
	SalesYTD = S.SalesYTD,
	SalesLastYear = S.SalesLastYear,
	OrdersNum = S.OrdersNum
WHEN NOT MATCHED BY TARGET THEN	INSERT (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	SalesYTD,
	SalesLastYear,
	OrdersNum)
VALUES (
	S.BusinessEntityID,
	S.PersonType,
	S.NameStyle,
	S.Title,
	S.FirstName,
	S.MiddleName,
	S.LastName,
	S.Suffix,
	S.EmailPromotion,
	S.ModifiedDate,
	S.SalesYTD,
	S.SalesLastYear,
	S.OrdersNum)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT * FROM dbo.Person
GO
USE AdventureWorks2012;
GO

CREATE TABLE Production.ProductCategoryHst (
	ID INT PRIMARY KEY IDENTITY(1,1),
	Action NVARCHAR(10) NOT NULL CHECK (Action IN('insert', 'update', 'delete')),
	ModifiedDate DATETIME NOT NULL,
	UserName NVARCHAR(50) NOT NULL
);
GO

CREATE TRIGGER onPruductCategoryModified
ON Production.ProductCategory
AFTER INSERT, UPDATE, DELETE
AS
DECLARE @event_type varchar(42);
IF EXISTS(SELECT * FROM inserted)
	IF EXISTS(SELECT * FROM deleted)
		SELECT @event_type = 'update';
	ELSE
		SELECT @event_type = 'insert';
ELSE
	IF EXISTS(SELECT * FROM deleted)
		SELECT @event_type = 'delete'; 

INSERT INTO Production.ProductCategoryHst (Action, ModifiedDate, UserName)
VALUES (@event_type, GETDATE(), USER_NAME());
GO

CREATE VIEW ProductCategoryView (
	ProductCategoryID,
	Name,
	rowguid,
	ModifiedDate
)
AS SELECT ProductCategoryID, Name, rowguid, ModifiedDate 
FROM Production.ProductCategory;
GO 

SELECT * FROM ProductCategoryView;
GO

INSERT INTO ProductCategoryView (Name, rowguid, ModifiedDate) 
VALUES ('New category', NEWID(), GETDATE());
GO

UPDATE ProductCategoryView 
SET ModifiedDate = '2019-11-03' 
WHERE Name = 'New category';
GO

DELETE FROM ProductCategoryView 
WHERE Name = 'New category';
GO

SELECT * FROM Production.ProductCategoryHst;
GO

	 

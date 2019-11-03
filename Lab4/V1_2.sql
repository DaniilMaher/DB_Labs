USE AdventureWorks2012;
GO

CREATE VIEW ProductCategoryAndSubcategoryView (
	ProductCategoryID,
	CategoryName,
	CategoryRowid,
	CategoryModifiedDate,
	ProductSubcategoryID,
	SubcategoryName,
	SubcategoryRowguid,
	SubcategoryModifiedDate
)
WITH ENCRYPTION, SCHEMABINDING
AS SELECT 
	C.ProductCategoryID, 
	C.Name,
	C.rowguid,
	C.ModifiedDate,
	SC.ProductSubcategoryID,
	SC.Name,
	SC.rowguid,
	SC.ModifiedDate
FROM Production.ProductCategory AS C 
JOIN Production.ProductSubcategory AS SC 
ON C.ProductCategoryID = SC.ProductCategoryID;
GO 

CREATE UNIQUE CLUSTERED INDEX ProductCategoryAndSubcategoryIDIndex 
ON ProductCategoryAndSubcategoryView(ProductCategoryID, ProductSubcategoryID);
GO

CREATE TRIGGER onProductCategoryAndSubcategoryViewInsert
ON ProductCategoryAndSubcategoryView
INSTEAD OF INSERT 
AS
INSERT INTO Production.ProductCategory (Name, rowguid, ModifiedDate)
SELECT 
	CategoryName, 
	CategoryRowid, 
	CategoryModifiedDate
FROM inserted;
INSERT INTO Production.ProductSubcategory (
	ProductCategoryID, 
	Name, 
	rowguid, 
	ModifiedDate)
SELECT 
	SCOPE_IDENTITY(), 
	SubCategoryName, 
	SubCategoryRowguid, 
	SubCategoryModifiedDate
FROM inserted;
GO

CREATE TRIGGER onProductCategoryAndSubcategoryViewUpdate
ON ProductCategoryAndSubcategoryView
INSTEAD OF UPDATE 
AS 
UPDATE Production.ProductCategory SET
	Name = inserted.CategoryName,
	rowguid = inserted.CategoryRowid,
	ModifiedDate = inserted.CategoryModifiedDate
FROM inserted
WHERE inserted.ProductCategoryID = Production.ProductCategory.ProductCategoryID;
UPDATE Production.ProductSubcategory SET		
	Name = inserted.SubCategoryName,
	rowguid = inserted.SubCategoryRowguid,
	ModifiedDate = inserted.SubCategoryModifiedDate
FROM inserted
WHERE inserted.ProductSubCategoryID = Production.ProductSubcategory.ProductSubcategoryID;
GO

CREATE TRIGGER onProductCategoryAndSubcategoryViewDelete
ON ProductCategoryAndSubcategoryView
INSTEAD OF DELETE 
AS
DELETE FROM Production.ProductSubcategory 
WHERE ProductSubcategoryID 
IN (SELECT ProductSubCategoryID FROM deleted);
DELETE FROM Production.ProductCategory 
WHERE ProductCategoryID 
IN (SELECT ProductCategoryID FROM deleted) 
AND	ProductCategoryID NOT IN (SELECT ProductCategoryID FROM Production.ProductSubcategory);
GO

INSERT INTO ProductCategoryAndSubcategoryView (
	CategoryName, 
	CategoryRowid,
	CategoryModifiedDate, 
	SubcategoryName, 
	SubcategoryRowguid,
	SubcategoryModifiedDate
)
VALUES ('New category', NEWID(), GETDATE(), 'New subcategory', NEWID(), GETDATE());
GO

SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;
GO 

UPDATE ProductCategoryAndSubcategoryView 
SET CategoryModifiedDate = '2019-11-02', 
	SubcategoryModifiedDate = '2019-11-02'
WHERE CategoryName = 'New category' AND SubcategoryName = 'New subcategory';
GO

SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;
GO 

DELETE FROM ProductCategoryAndSubcategoryView 
WHERE CategoryName = 'New category' AND SubcategoryName = 'New subcategory';
GO

SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;
GO 

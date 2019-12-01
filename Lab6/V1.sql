USE AdventureWorks2012;
GO

SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Production.Product;
GO

CREATE PROCEDURE OrdersByYear 
	@years NVARCHAR(50) 
AS
BEGIN
	DECLARE @query AS NVARCHAR(500);
	SET @query = '
		SELECT 
			Name, 
			' + @years + ' 
		FROM (
			SELECT 
				Name, 
				YEAR(OrderDate) AS year, 
				OrderQty 
			FROM Sales.SalesOrderHeader AS SOH
			JOIN Sales.SalesOrderDetail AS SOD
				ON SOD.SalesOrderID = SOH.SalesOrderID
			JOIN Production.Product AS P
				ON P.ProductID = SOD.ProductID
			) 
		AS selected
		PIVOT (  
			SUM(OrderQty) FOR year IN(' + @years + ') 
		) 
		AS result'
    EXECUTE(@query)
END;
GO

EXECUTE dbo.OrdersByYear '[2008], [2007], [2006]';
GO

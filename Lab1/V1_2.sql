RESTORE DATABASE AdventureWorks2012 FROM DISK = 'D:\Универ\БД\AdventureWorks2012-Full_Database_Backup.bak';
GO
  
USE AdventureWorks2012;
GO

SELECT * FROM HumanResources.Employee WHERE JobTitle IN ('Accounts Manager', 'Benefits Specialist', 'Engineering Manager', 'Finance Manager', 'Maintenance Supervisor', 'Master Scheduler', 'Network Manager');
GO

SELECT COUNT(BusinessEntityID) AS EmpCount FROM HumanResources.Employee WHERE HireDate >= '2004';
GO

SELECT TOP(5) * FROM HumanResources.Employee WHERE MaritalStatus = 'M' AND YEAR(HireDate) = 2004 ORDER BY BirthDate DESC
GO
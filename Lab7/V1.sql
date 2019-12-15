USE AdventureWorks2012;
GO

DECLARE @employeesXML XML;

SET @employeesXML =
(
    SELECT
        BusinessEntityID AS '@ID',
        NationalIDNumber AS 'NationalIDNumber',
        JobTitle AS 'JobTitle'
    FROM
        HumanResources.Employee
    FOR XML
        PATH ('Employee'),
        ROOT ('Employees')
);

--SELECT @employeesXML;

SELECT
    BusinessEntityID = node.value('@ID', 'INT'),
    NationalIDNumber = node.value('NationalIDNumber[1]', 'NVARCHAR(15)'),
    JobTitle = node.value('JobTitle[1]', 'NVARCHAR(50)')
INTO
    #Employee
FROM
    @employeesXML.nodes('/Employees/Employee') AS XML(node);

SELECT * FROM #Employee;
GO

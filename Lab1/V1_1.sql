	CREATE DATABASE Daniil_Maher;
	GO

	USE Daniil_Maher;
	GO

	CREATE SCHEMA sales;
	GO

	CREATE SCHEMA persons;
	GO

	CREATE TABLE sales.Orders (OrderNum INT NULL);
	GO

	BACKUP DATABASE Daniil_Maher TO DISK='D:\Универ\БД\Lab1\Daniil_Maher.bak';
	GO

	USE master
	DROP DATABASE Daniil_Maher;
	GO

	RESTORE DATABASE Daniil_Maher FROM DISK='D:\Универ\БД\Lab1\Daniil_Maher.bak';
	GO
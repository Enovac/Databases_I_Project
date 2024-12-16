--2.2
-- A)
CREATE DATABASE Supermarket_Team_10;
USE Supermarket_Team_10;
--=================================Procedures===========================================
-- B) Stored Procedure to Create All Tables
CREATE PROCEDURE createAllTables
AS
BEGIN
    -- Employee Table 
    CREATE TABLE Employee (
        EID INT IDENTITY(1,1) PRIMARY KEY,
        HireDate DATE NOT NULL,
        Salary DECIMAL(10,2) NOT NULL,
        Name VARCHAR(100) NOT NULL,
        Position VARCHAR(50) NOT NULL
    );

    -- CustomerProfile Table
    CREATE TABLE CustomerProfile (
        ShoppingCardNum INT PRIMARY KEY,
        DoB DATE NOT NULL,
        FirstName VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        PhoneNumber VARCHAR(15),
        Email VARCHAR(100),
        Address VARCHAR(255)
    );

    -- Transactions Table
    CREATE TABLE Transactions (
        TID INT IDENTITY(1,1) PRIMARY KEY,
        Date DATE NOT NULL,
        Amount DECIMAL(10,2) NOT NULL,
        EmpID INT NOT NULL,
        ShoppingCardNum INT NOT NULL,
        FOREIGN KEY (EmpID) REFERENCES Employee(EID),
        FOREIGN KEY (ShoppingCardNum) REFERENCES CustomerProfile(ShoppingCardNum)
    );

    -- CustomerAccount Table
    CREATE TABLE CustomerAccount (
        Status VARCHAR(20) NOT NULL,
        ShoppingCardNum INT NOT NULL,
        AccountStartDate DATE NOT NULL,
        Type VARCHAR(20) NOT NULL,
        TotalPoints INT NOT NULL,
        PRIMARY KEY (ShoppingCardNum),
        FOREIGN KEY (ShoppingCardNum) REFERENCES CustomerProfile(ShoppingCardNum)
    );

    -- CustomerCardPoints Table
    CREATE TABLE CustomerCardPoints (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        ShoppingCardNum INT NOT NULL,
        Amount INT NOT NULL,
        FOREIGN KEY (ShoppingCardNum) REFERENCES CustomerProfile(ShoppingCardNum)
    );

    -- Promotions Table
    CREATE TABLE Promotions (
        PID INT IDENTITY(1,1) PRIMARY KEY,
        Type VARCHAR(50) NOT NULL,
        Description VARCHAR(255),
        Status VARCHAR(20) NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        ShoppingCardNum INT,
        TID INT,
        FOREIGN KEY (ShoppingCardNum) REFERENCES CustomerProfile(ShoppingCardNum),
        FOREIGN KEY (TID) REFERENCES Transactions(TID)
    );

    -- ProductInfo Table
    CREATE TABLE ProductInfo (
        PID INT IDENTITY(1,1) PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Brand VARCHAR(50),
        Quality VARCHAR(20),
        Category VARCHAR(50),
        StockQuality INT NOT NULL,
        SalePrice DECIMAL(10,2) NOT NULL
    );

    -- Supplier Table
    CREATE TABLE Supplier (
        SID INT IDENTITY(1,1) PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Contact VARCHAR(100),
        Address VARCHAR(255)
    );

    -- ProductSupplier Table
    CREATE TABLE ProductSupplier (
        PID INT NOT NULL,
        SID INT NOT NULL,
        LeadTime INT NOT NULL,
        SupplyPrice DECIMAL(10,2) NOT NULL,
        PRIMARY KEY (PID, SID),
        FOREIGN KEY (PID) REFERENCES ProductInfo(PID),
        FOREIGN KEY (SID) REFERENCES Supplier(SID)
    );

    -- PaymentInfo Table
    CREATE TABLE PaymentInfo (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        DateOfPayment DATE NOT NULL,
        Method VARCHAR(50) NOT NULL,
        Status VARCHAR(20) NOT NULL,
        ShoppingCardNum INT NOT NULL,
        TID INT,
        FOREIGN KEY (ShoppingCardNum) REFERENCES CustomerProfile(ShoppingCardNum),
        FOREIGN KEY (TID) REFERENCES Transactions(TID)
    );

    -- ProductTransaction Table
    CREATE TABLE ProductTransaction (
        TID INT NOT NULL,
        PID INT NOT NULL,
        Quantity INT NOT NULL,
        PRIMARY KEY (TID, PID),
        FOREIGN KEY (TID) REFERENCES Transactions(TID),
        FOREIGN KEY (PID) REFERENCES ProductInfo(PID)
    );
END;
GO

-- C) Stored Procedure to Drop All Tables
CREATE PROCEDURE dropAllTables
AS
BEGIN
    DROP TABLE IF EXISTS ProductTransaction;
    DROP TABLE IF EXISTS PaymentInfo;
    DROP TABLE IF EXISTS ProductSupplier;
    DROP TABLE IF EXISTS Supplier;
    DROP TABLE IF EXISTS ProductInfo;
    DROP TABLE IF EXISTS Promotions;
    DROP TABLE IF EXISTS CustomerCardPoints;
    DROP TABLE IF EXISTS CustomerAccount;
    DROP TABLE IF EXISTS Transactions;
    DROP TABLE IF EXISTS CustomerProfile;
    DROP TABLE IF EXISTS Employee;
END;
GO

-- D) Stored Procedure to Drop All Procedures, Functions, and Views
CREATE PROCEDURE dropAllProceduresFunctionsViews
AS
BEGIN
    DROP PROCEDURE IF EXISTS createAllTables;
    DROP PROCEDURE IF EXISTS dropAllTables;
    DROP PROCEDURE IF EXISTS clearAllTables;
    DROP VIEW IF EXISTS allCustomerAccounts;
    DROP VIEW IF EXISTS allEmployeeInformation;
    DROP VIEW IF EXISTS allProducts;
    DROP VIEW IF EXISTS allSupplierInformation;
    DROP VIEW IF EXISTS allPaymentInformation;
    DROP VIEW IF EXISTS allPromotions;
    DROP VIEW IF EXISTS allSalesInformation;
    DROP VIEW IF EXISTS Num_of_transactions;
END;
GO

-- E) Stored Procedure to Clear All Tables
CREATE PROCEDURE clearAllTables
AS
BEGIN
    DELETE FROM ProductTransaction;
    DELETE FROM PaymentInfo;
    DELETE FROM ProductSupplier;
    DELETE FROM Supplier;
    DELETE FROM ProductInfo;
    DELETE FROM Promotions;
    DELETE FROM CustomerCardPoints;
    DELETE FROM CustomerAccount;
    DELETE FROM Transactions;
    DELETE FROM CustomerProfile;
    DELETE FROM Employee;
END;
GO
--=================================Views===========================================

-- View: All Customer Accounts
CREATE VIEW allCustomerAccounts AS
SELECT 
    CP.ShoppingCardNum,
    CP.FirstName,
    CP.LastName,
    CA.Status,
    CA.AccountStartDate,
    CA.Type,
    CA.TotalPoints
FROM CustomerProfile CP
JOIN CustomerAccount CA ON CP.ShoppingCardNum = CA.ShoppingCardNum;
GO

-- View: All Employee Information 
CREATE VIEW allEmployeeInformation AS
SELECT *
FROM Employee;
GO

-- View: All Products
CREATE VIEW allProducts AS
SELECT PID, Name, Brand, SalePrice
FROM ProductInfo;
GO

-- View: All Supplier Information
CREATE VIEW allSupplierInformation AS
SELECT *
FROM Supplier;
GO

-- View: All Payment Information
CREATE VIEW allPaymentInformation AS
SELECT 
    MAX(Amount) AS HighestPayment,
    AVG(Amount) AS AveragePayment
FROM PaymentInfo;
GO

-- View: All Promotions
CREATE VIEW allPromotions AS
SELECT *
FROM Promotions;
GO

-- View: All Sales Information
CREATE VIEW allSalesInformation AS
SELECT 
    AVG(T.Amount) AS AverageTransaction,
    MAX(T.Amount) AS HighestTransaction
FROM Transactions T;
GO

-- View: Number of Transactions per Customer
CREATE VIEW Num_of_transactions AS
SELECT 
    ShoppingCardNum,
    COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY ShoppingCardNum;
GO

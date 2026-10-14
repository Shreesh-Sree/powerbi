-- Q2 Banking Customer Account Analysis
CREATE DATABASE BankDB; GO
USE BankDB; GO
CREATE TABLE Branch (
  BranchID INT IDENTITY PRIMARY KEY, BranchName VARCHAR(60) NOT NULL UNIQUE,
  City VARCHAR(50) NOT NULL, Region VARCHAR(30) NOT NULL);
CREATE TABLE Customer (
  CustomerID INT IDENTITY PRIMARY KEY, CustomerName VARCHAR(80) NOT NULL,
  Phone VARCHAR(15) UNIQUE, City VARCHAR(50), JoinDate DATE NOT NULL DEFAULT GETDATE());
CREATE TABLE Account (
  AccountID INT IDENTITY(1000,1) PRIMARY KEY,
  CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
  BranchID INT NOT NULL REFERENCES Branch(BranchID),
  AccountType VARCHAR(10) NOT NULL CHECK (AccountType IN ('Savings','Current','FD')),
  Balance DECIMAL(14,2) NOT NULL DEFAULT 0 CHECK (Balance >= 0),
  OpenDate DATE NOT NULL DEFAULT GETDATE());
CREATE TABLE [Transaction] (
  TxnID INT IDENTITY PRIMARY KEY,
  AccountID INT NOT NULL REFERENCES Account(AccountID),
  TxnDate DATE NOT NULL, SettlementDate DATE NOT NULL,
  TxnType VARCHAR(10) NOT NULL CHECK (TxnType IN ('Deposit','Withdraw','Transfer')),
  Amount DECIMAL(12,2) NOT NULL CHECK (Amount > 0));

INSERT Branch VALUES ('T Nagar','Chennai','South'),('Anna Nagar','Chennai','South'),('MG Road','Bengaluru','South'),('Andheri','Mumbai','West');
INSERT Customer(CustomerName,Phone,City) VALUES ('Arjun','8000000001','Chennai'),('Priya','8000000002','Bengaluru'),('Karthik','8000000003','Mumbai'),('Divya','8000000004','Chennai');
INSERT Account(CustomerID,BranchID,AccountType,Balance) VALUES (1,1,'Savings',85000),(1,2,'FD',500000),(2,3,'Savings',12000),(3,4,'Current',250000),(4,1,'Savings',3000);
INSERT [Transaction](AccountID,TxnDate,SettlementDate,TxnType,Amount) VALUES
 (1000,'2025-01-05','2025-01-06','Deposit',20000),(1000,'2025-01-20','2025-01-20','Withdraw',5000),
 (1002,'2025-02-02','2025-02-04','Deposit',8000),(1003,'2025-02-15','2025-02-16','Transfer',60000),
 (1004,'2025-03-01','2025-03-01','Deposit',1500);

-- Task 2: balance filters
SELECT * FROM Account WHERE Balance > 100000;
SELECT * FROM Account WHERE Balance < 10000;
SELECT AccountType, COUNT(*) Accounts, AVG(Balance) AvgBal FROM Account GROUP BY AccountType;
SELECT * FROM Account WHERE Balance > (SELECT AVG(Balance) FROM Account);

-- Task 3: branch-wise stats
SELECT b.BranchName, COUNT(a.AccountID) AS Accounts, SUM(a.Balance) AS TotalBalance,
       AVG(a.Balance) AS AvgBalance, MAX(a.Balance) AS MaxBalance
FROM Branch b LEFT JOIN Account a ON a.BranchID=b.BranchID
GROUP BY b.BranchName HAVING COUNT(a.AccountID) >= 1 ORDER BY TotalBalance DESC;
SELECT b.BranchName, SUM(a.Balance) TotalBalance FROM Branch b JOIN Account a ON a.BranchID=b.BranchID
GROUP BY b.BranchName HAVING SUM(a.Balance) > 100000;

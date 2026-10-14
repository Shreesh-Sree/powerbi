-- SD0107 Set B: run this whole file in SSMS (New Query > paste > Execute). Safe to re-run: it drops and recreates the databases.

-- ===== q01_ecommerce_sales_db.sql =====
-- Q1 E-Commerce Sales Database
IF DB_ID('EcomDB') IS NOT NULL BEGIN ALTER DATABASE EcomDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE EcomDB; END
GO
CREATE DATABASE EcomDB;
GO
USE EcomDB; GO
CREATE TABLE Customer (CustomerID INT IDENTITY PRIMARY KEY, CustomerName VARCHAR(80) NOT NULL, Email VARCHAR(100) UNIQUE NOT NULL,
  City VARCHAR(50), Region VARCHAR(20) NOT NULL DEFAULT 'South', JoinDate DATE NOT NULL DEFAULT GETDATE());
CREATE TABLE Product (ProductID INT IDENTITY PRIMARY KEY, ProductName VARCHAR(80) NOT NULL, Category VARCHAR(40) NOT NULL,
  UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0));
CREATE TABLE Orders (OrderID INT IDENTITY PRIMARY KEY, CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
  OrderDate DATE NOT NULL DEFAULT GETDATE(), DeliveryDate DATE, Status VARCHAR(12) NOT NULL DEFAULT 'Placed' CHECK (Status IN ('Placed','Shipped','Delivered','Cancelled')));
CREATE TABLE Sales (SaleID INT IDENTITY PRIMARY KEY, OrderID INT NOT NULL REFERENCES Orders(OrderID),
  ProductID INT NOT NULL REFERENCES Product(ProductID), Quantity INT NOT NULL CHECK (Quantity > 0),
  Amount DECIMAL(12,2) NOT NULL CHECK (Amount >= 0));
INSERT Customer(CustomerName,Email,City,Region) VALUES ('Arjun','arjun@x.com','Chennai','South'),('Priya','priya@x.com','Mumbai','West'),('Karthik','karthik@x.com','Delhi','North'),('Divya','divya@x.com','Chennai','South');
INSERT Product(ProductName,Category,UnitPrice) VALUES ('Laptop','Electronics',55000),('Phone','Electronics',20000),('Desk','Furniture',8000),('Headphones','Electronics',3000),('Chair','Furniture',5000);
INSERT Orders(CustomerID,OrderDate,DeliveryDate,Status) VALUES (1,'2025-01-05','2025-01-09','Delivered'),(2,'2025-02-11','2025-02-15','Delivered'),(3,'2025-02-20','2025-02-26','Delivered'),(1,'2025-03-02','2025-03-05','Delivered'),(4,'2025-03-15',NULL,'Shipped');
INSERT Sales(OrderID,ProductID,Quantity,Amount) VALUES (1,1,1,55000),(1,4,2,6000),(2,2,1,20000),(3,3,2,16000),(4,5,4,20000),(5,4,1,3000);
-- Task 2
SELECT * FROM Customer WHERE CustomerName LIKE '%a%';
SELECT DISTINCT Category FROM Product ORDER BY Category;
SELECT * FROM Product WHERE Category IN ('Electronics','Furniture') AND UnitPrice BETWEEN 3000 AND 25000 ORDER BY UnitPrice DESC;
SELECT * FROM Orders WHERE OrderDate BETWEEN '2025-02-01' AND '2025-03-31';
-- Task 3
SELECT SUM(Amount) TotalSales, COUNT(*) Lines, AVG(Amount) AvgSale, MIN(Amount) MinSale, MAX(Amount) MaxSale FROM Sales;
SELECT p.Category, SUM(s.Amount) TotalSales, COUNT(*) Lines FROM Sales s JOIN Product p ON p.ProductID=s.ProductID
GROUP BY p.Category HAVING SUM(s.Amount) > 20000 ORDER BY TotalSales DESC;
SELECT c.Region, SUM(s.Amount) Sales FROM Sales s JOIN Orders o ON o.OrderID=s.OrderID JOIN Customer c ON c.CustomerID=o.CustomerID GROUP BY c.Region HAVING COUNT(*)>=1;

GO

-- ===== q02_employee_payroll.sql =====
-- Q2 Employee Payroll Analysis
IF DB_ID('PayrollDB') IS NOT NULL BEGIN ALTER DATABASE PayrollDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE PayrollDB; END
GO
CREATE DATABASE PayrollDB;
GO
USE PayrollDB; GO
CREATE TABLE Department (DeptID INT PRIMARY KEY, DeptName VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE Employee (EmpID INT PRIMARY KEY, EmpName VARCHAR(80) NOT NULL, Designation VARCHAR(50) NOT NULL,
  Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0), JoiningDate DATE NOT NULL DEFAULT GETDATE(), DeptID INT NOT NULL REFERENCES Department(DeptID));
INSERT Department VALUES (1,'IT'),(2,'HR'),(3,'Finance'),(4,'Sales');
INSERT Employee VALUES (1,'Arjun','Developer',60000,'2022-01-10',1),(2,'Priya','Tester',45000,'2023-03-15',1),(3,'Karthik','HR Executive',38000,'2021-07-01',2),
 (4,'Divya','Accountant',52000,'2020-11-20',3),(5,'Nithya','Sales Manager',75000,'2019-05-05',4),(6,'Ravi','Sales Rep',30000,'2024-02-12',4);
SELECT * FROM Employee WHERE Salary > 50000;
SELECT * FROM Employee WHERE Salary < 40000;
SELECT * FROM Employee WHERE Salary > (SELECT AVG(Salary) FROM Employee);
SELECT d.DeptName, COUNT(*) Employees, SUM(Salary) TotalPay, AVG(Salary) AvgPay, MIN(Salary) MinPay, MAX(Salary) MaxPay
FROM Employee e JOIN Department d ON d.DeptID=e.DeptID GROUP BY d.DeptName HAVING AVG(Salary) > 40000 ORDER BY AvgPay DESC;

GO

-- ===== q03_customer_orders.sql =====
-- Q3 Customer Order Management (uses EcomDB from Q1)
USE EcomDB; GO
SELECT c.CustomerName, o.OrderID, p.ProductName, s.Amount                -- INNER
FROM Customer c JOIN Orders o ON o.CustomerID=c.CustomerID JOIN Sales s ON s.OrderID=o.OrderID JOIN Product p ON p.ProductID=s.ProductID;
SELECT c.CustomerName, o.OrderID FROM Customer c LEFT JOIN Orders o ON o.CustomerID=c.CustomerID;          -- LEFT
SELECT p.ProductName, s.SaleID FROM Sales s RIGHT JOIN Product p ON p.ProductID=s.ProductID;                -- RIGHT
SELECT c.CustomerName, o.OrderID FROM Customer c FULL JOIN Orders o ON o.CustomerID=c.CustomerID;           -- FULL
-- high value customers (subquery)
SELECT CustomerName FROM Customer WHERE CustomerID IN (
  SELECT o.CustomerID FROM Orders o JOIN Sales s ON s.OrderID=o.OrderID GROUP BY o.CustomerID HAVING SUM(s.Amount) > 30000);
SELECT * FROM Orders WHERE OrderID IN (SELECT OrderID FROM Sales WHERE Amount > 15000);
-- IN, EXISTS, ANY, ALL
SELECT * FROM Customer WHERE City IN ('Chennai','Mumbai');
SELECT * FROM Customer c WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID=c.CustomerID);
SELECT * FROM Customer c WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID=c.CustomerID);
SELECT * FROM Sales WHERE Amount > ANY (SELECT Amount FROM Sales WHERE ProductID=4);
SELECT * FROM Sales WHERE Amount > ALL (SELECT Amount FROM Sales WHERE ProductID=4);

GO

-- ===== q04_student_academic.sql =====
-- Q4 Student Academic Database
IF DB_ID('CollegeDB') IS NOT NULL BEGIN ALTER DATABASE CollegeDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE CollegeDB; END
GO
CREATE DATABASE CollegeDB;
GO
USE CollegeDB; GO
CREATE TABLE Student (StudentID INT PRIMARY KEY, StudentName VARCHAR(80) NOT NULL, Dept VARCHAR(30) NOT NULL);
CREATE TABLE Course (CourseID INT PRIMARY KEY, CourseName VARCHAR(60) NOT NULL UNIQUE);
CREATE TABLE Marks (MarkID INT PRIMARY KEY, StudentID INT REFERENCES Student(StudentID), CourseID INT REFERENCES Course(CourseID),
  Semester INT NOT NULL, Marks INT NOT NULL CHECK (Marks BETWEEN 0 AND 100));
INSERT Student VALUES (1,'Arjun','CSE'),(2,'Priya','CSE'),(3,'Karthik','AIML'),(4,'Divya','AIML');
INSERT Course VALUES (1,'DBMS'),(2,'ML');
INSERT Marks VALUES (1,1,1,1,78),(2,2,1,1,91),(3,3,1,1,85),(4,4,1,1,91),(5,1,2,2,82),(6,2,2,2,88),(7,3,2,2,70),(8,4,2,2,95);
SELECT StudentID FROM Marks WHERE CourseID=1 AND Marks>=80 UNION SELECT StudentID FROM Marks WHERE CourseID=2 AND Marks>=80;
SELECT StudentID FROM Marks WHERE CourseID=1 AND Marks>=80 INTERSECT SELECT StudentID FROM Marks WHERE CourseID=2 AND Marks>=80;
SELECT StudentID FROM Marks WHERE CourseID=1 EXCEPT SELECT StudentID FROM Marks WHERE Marks<75;
SELECT s.StudentName, c.CourseName, m.Semester, m.Marks,
  ROW_NUMBER() OVER (PARTITION BY m.CourseID ORDER BY m.Marks DESC) RowNo,
  RANK() OVER (PARTITION BY m.CourseID ORDER BY m.Marks DESC) Rnk,
  LAG(m.Marks) OVER (PARTITION BY m.StudentID ORDER BY m.Semester) PrevMarks,
  LEAD(m.Marks) OVER (PARTITION BY m.StudentID ORDER BY m.Semester) NextMarks
FROM Marks m JOIN Student s ON s.StudentID=m.StudentID JOIN Course c ON c.CourseID=m.CourseID;

GO

-- ===== q05_sales_trend_dates.sql =====
-- Q5 Sales Trend and Date Analysis (uses EcomDB)
USE EcomDB; GO
SELECT o.OrderID, o.OrderDate, YEAR(o.OrderDate) Yr, MONTH(o.OrderDate) Mth, DAY(o.OrderDate) Dy,
  DATENAME(WEEKDAY,o.OrderDate) Weekday, DATEPART(QUARTER,o.OrderDate) Qtr, DATEDIFF(DAY,o.OrderDate,o.DeliveryDate) DeliveryDays FROM Orders o;
SELECT YEAR(o.OrderDate) Yr, MONTH(o.OrderDate) Mth, SUM(s.Amount) Sales FROM Orders o JOIN Sales s ON s.OrderID=o.OrderID GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate) ORDER BY Yr, Mth;
SELECT YEAR(o.OrderDate) Yr, SUM(s.Amount) Sales FROM Orders o JOIN Sales s ON s.OrderID=o.OrderID GROUP BY YEAR(o.OrderDate);
SELECT UPPER(CustomerName) UName, LEN(CustomerName) NameLen, LEFT(Email, CHARINDEX('@',Email)-1) UserPart, CONCAT(CustomerName,' - ',City) Label FROM Customer;
SELECT ProductName, REPLACE(ProductName,' ','_') Slug, SUBSTRING(ProductName,1,3) Code, UPPER(LEFT(Category,3)) CatCode FROM Product;

GO

-- ===== q06_reporting_view_proc.sql =====
-- Q6 SQL Server Reporting Database (uses EcomDB)
USE EcomDB; GO
SELECT c.CustomerName, p.Category, s.Amount,
  SUM(s.Amount) OVER (PARTITION BY c.CustomerID) CustomerTotal,
  RANK() OVER (ORDER BY s.Amount DESC) AmountRank
FROM Sales s JOIN Orders o ON o.OrderID=s.OrderID JOIN Customer c ON c.CustomerID=o.CustomerID JOIN Product p ON p.ProductID=s.ProductID
WHERE s.Amount > (SELECT AVG(Amount) FROM Sales);
GO
CREATE OR ALTER VIEW vw_SalesSummary AS
SELECT c.Region, p.Category, YEAR(o.OrderDate) Yr, SUM(s.Amount) TotalSales, SUM(s.Quantity) Units
FROM Sales s JOIN Orders o ON o.OrderID=s.OrderID JOIN Customer c ON c.CustomerID=o.CustomerID JOIN Product p ON p.ProductID=s.ProductID
GROUP BY c.Region, p.Category, YEAR(o.OrderDate);
GO
CREATE OR ALTER PROCEDURE usp_SalesReport @Region VARCHAR(20)=NULL, @FromDate DATE, @ToDate DATE
AS BEGIN
  SET NOCOUNT ON;
  SELECT o.OrderID, o.OrderDate, c.CustomerName, c.Region, p.ProductName, s.Quantity, s.Amount
  FROM Sales s JOIN Orders o ON o.OrderID=s.OrderID JOIN Customer c ON c.CustomerID=o.CustomerID JOIN Product p ON p.ProductID=s.ProductID
  WHERE o.OrderDate BETWEEN @FromDate AND @ToDate AND (@Region IS NULL OR c.Region=@Region) ORDER BY o.OrderDate;
END;
GO
EXEC usp_SalesReport @Region='South', @FromDate='2025-01-01', @ToDate='2025-03-31';
SELECT * FROM vw_SalesSummary;

GO

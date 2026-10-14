-- SD0107 Set A: run this whole file in SSMS (New Query > paste > Execute). Safe to re-run: it drops and recreates the databases.

-- ===== q01_hospital_patient_db.sql =====
-- Q1 Hospital Patient Management Database (SQL Server)
IF DB_ID('HospitalDB') IS NOT NULL BEGIN ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE HospitalDB; END
GO
CREATE DATABASE HospitalDB;
GO
USE HospitalDB; GO

CREATE TABLE Department (
  DeptID INT IDENTITY(1,1) PRIMARY KEY,
  DeptName VARCHAR(60) NOT NULL UNIQUE,
  Floor INT NOT NULL DEFAULT 1 CHECK (Floor BETWEEN 0 AND 20)
);
CREATE TABLE Doctor (
  DoctorID INT IDENTITY(1,1) PRIMARY KEY,
  DoctorName VARCHAR(80) NOT NULL,
  Specialization VARCHAR(60) NOT NULL,
  Phone VARCHAR(15) UNIQUE,
  DeptID INT NOT NULL REFERENCES Department(DeptID)
);
CREATE TABLE Patient (
  PatientID INT IDENTITY(1,1) PRIMARY KEY,
  PatientName VARCHAR(80) NOT NULL,
  Gender CHAR(1) NOT NULL CHECK (Gender IN ('M','F','O')),
  DOB DATE NOT NULL CHECK (DOB <= GETDATE()),
  Phone VARCHAR(15) UNIQUE,
  City VARCHAR(50),
  RegDate DATE NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Appointment (
  AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
  PatientID INT NOT NULL REFERENCES Patient(PatientID),
  DoctorID INT NOT NULL REFERENCES Doctor(DoctorID),
  AppointmentDate DATE NOT NULL,
  Status VARCHAR(15) NOT NULL DEFAULT 'Scheduled'
    CHECK (Status IN ('Scheduled','Completed','Cancelled'))
);
CREATE TABLE Billing (
  BillID INT IDENTITY(1,1) PRIMARY KEY,
  AppointmentID INT NOT NULL UNIQUE REFERENCES Appointment(AppointmentID),
  Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
  PaymentStatus VARCHAR(10) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending','Paid')),
  BillDate DATE NOT NULL DEFAULT GETDATE()
);

-- Sample data
INSERT Department(DeptName,Floor) VALUES ('Cardiology',2),('Orthopedics',1),('Neurology',3),('Pediatrics',1);
INSERT Doctor VALUES ('Dr. Anand','Cardiologist','9000000001',1),('Dr. Meera','Orthopedic Surgeon','9000000002',2),
 ('Dr. Ravi','Neurologist','9000000003',3),('Dr. Sneha','Pediatrician','9000000004',4);
INSERT Patient(PatientName,Gender,DOB,Phone,City,RegDate) VALUES
 ('Arjun Kumar','M','1985-04-12','8000000001','Chennai','2025-01-10'),
 ('Priya Sharma','F','1992-09-30','8000000002','Madurai','2025-02-14'),
 ('Karthik Raj','M','1978-12-01','8000000003','Chennai','2025-03-03'),
 ('Anitha Devi','F','2015-06-21','8000000004','Coimbatore','2025-03-20'),
 ('Suresh Babu','M','1960-01-15','8000000005','Salem','2025-04-05');
INSERT Appointment(PatientID,DoctorID,AppointmentDate,Status) VALUES
 (1,1,'2025-01-15','Completed'),(2,2,'2025-02-20','Completed'),(3,3,'2025-03-10','Completed'),
 (4,4,'2025-04-01','Completed'),(5,1,'2025-04-12','Scheduled'),(1,3,'2025-05-02','Cancelled');
INSERT Billing(AppointmentID,Amount,PaymentStatus) VALUES (1,1500,'Paid'),(2,3200,'Paid'),(3,2800,'Pending'),(4,600,'Paid');

-- Task 2: retrieval queries
SELECT * FROM Patient WHERE PatientName LIKE 'A%';
SELECT DISTINCT City FROM Patient ORDER BY City;
SELECT * FROM Patient WHERE City IN ('Chennai','Madurai');
SELECT * FROM Appointment WHERE AppointmentDate BETWEEN '2025-02-01' AND '2025-04-30' ORDER BY AppointmentDate;
SELECT p.PatientName, d.DoctorName, a.AppointmentDate, a.Status
FROM Appointment a JOIN Patient p ON p.PatientID=a.PatientID JOIN Doctor d ON d.DoctorID=a.DoctorID
WHERE a.Status = 'Completed' ORDER BY a.AppointmentDate DESC;

-- Task 3: aggregates
SELECT SUM(Amount) AS TotalBilling, AVG(Amount) AS AvgBilling,
       MIN(Amount) AS MinBilling, MAX(Amount) AS MaxBilling FROM Billing;
SELECT dp.DeptName, COUNT(DISTINCT a.PatientID) AS Patients, SUM(b.Amount) AS Revenue
FROM Billing b JOIN Appointment a ON a.AppointmentID=b.AppointmentID
JOIN Doctor d ON d.DoctorID=a.DoctorID JOIN Department dp ON dp.DeptID=d.DeptID
GROUP BY dp.DeptName HAVING SUM(b.Amount) > 1000 ORDER BY Revenue DESC;
SELECT City, COUNT(*) AS PatientCount FROM Patient GROUP BY City HAVING COUNT(*) >= 1;

GO

-- ===== q02_banking_account_analysis.sql =====
-- Q2 Banking Customer Account Analysis
IF DB_ID('BankDB') IS NOT NULL BEGIN ALTER DATABASE BankDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE BankDB; END
GO
CREATE DATABASE BankDB;
GO
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

GO

-- ===== q03_insurance_joins.sql =====
-- Q3 Insurance Policy Management
IF DB_ID('InsuranceDB') IS NOT NULL BEGIN ALTER DATABASE InsuranceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE InsuranceDB; END
GO
CREATE DATABASE InsuranceDB;
GO
USE InsuranceDB; GO
CREATE TABLE PolicyType (TypeID INT PRIMARY KEY, TypeName VARCHAR(40) NOT NULL UNIQUE);
CREATE TABLE Customer (CustomerID INT PRIMARY KEY, CustomerName VARCHAR(80) NOT NULL, City VARCHAR(50));
CREATE TABLE Policy (
  PolicyID INT PRIMARY KEY, CustomerID INT REFERENCES Customer(CustomerID),
  TypeID INT REFERENCES PolicyType(TypeID), Premium DECIMAL(10,2) CHECK (Premium>0), StartDate DATE);
CREATE TABLE Claim (
  ClaimID INT PRIMARY KEY, PolicyID INT REFERENCES Policy(PolicyID),
  ClaimAmount DECIMAL(12,2) CHECK (ClaimAmount>0), ClaimDate DATE);
INSERT PolicyType VALUES (1,'Health'),(2,'Life'),(3,'Motor'),(4,'Travel');
INSERT Customer VALUES (1,'Arjun','Chennai'),(2,'Priya','Madurai'),(3,'Karthik','Salem'),(4,'Divya','Trichy'),(5,'Nithya','Chennai');
INSERT Policy VALUES (101,1,1,12000,'2024-01-01'),(102,1,3,8000,'2024-03-01'),(103,2,2,25000,'2024-02-01'),(104,3,1,11000,'2024-05-01'),(105,4,3,7000,'2024-06-01');
INSERT Claim VALUES (1,101,40000,'2025-01-10'),(2,101,25000,'2025-02-10'),(3,103,150000,'2025-03-05'),(4,104,9000,'2025-03-20');

-- Task 1: joins
SELECT c.CustomerName, p.PolicyID, t.TypeName, cl.ClaimAmount        -- INNER
FROM Customer c JOIN Policy p ON p.CustomerID=c.CustomerID
JOIN PolicyType t ON t.TypeID=p.TypeID JOIN Claim cl ON cl.PolicyID=p.PolicyID;
SELECT c.CustomerName, p.PolicyID, cl.ClaimAmount                    -- LEFT (customers w/o policy or claim too)
FROM Customer c LEFT JOIN Policy p ON p.CustomerID=c.CustomerID LEFT JOIN Claim cl ON cl.PolicyID=p.PolicyID;
SELECT t.TypeName, p.PolicyID FROM Policy p RIGHT JOIN PolicyType t ON t.TypeID=p.TypeID; -- RIGHT (types with no policy)
SELECT c.CustomerName, p.PolicyID FROM Customer c FULL JOIN Policy p ON p.CustomerID=c.CustomerID; -- FULL

-- Task 2: customers whose total claims exceed a value (subquery)
SELECT CustomerName FROM Customer WHERE CustomerID IN (
  SELECT p.CustomerID FROM Policy p JOIN Claim cl ON cl.PolicyID=p.PolicyID
  GROUP BY p.CustomerID HAVING SUM(cl.ClaimAmount) > 50000);

-- Task 3: IN, EXISTS, ANY, ALL
SELECT * FROM Customer WHERE CustomerID IN (SELECT CustomerID FROM Policy WHERE TypeID=1);
SELECT * FROM Customer c WHERE EXISTS (SELECT 1 FROM Policy p WHERE p.CustomerID=c.CustomerID);
SELECT * FROM Customer c WHERE NOT EXISTS (SELECT 1 FROM Policy p WHERE p.CustomerID=c.CustomerID);
SELECT * FROM Policy WHERE Premium > ANY (SELECT Premium FROM Policy WHERE TypeID=3);
SELECT * FROM Policy WHERE Premium > ALL (SELECT Premium FROM Policy WHERE TypeID=3);

GO

-- ===== q04_university_performance.sql =====
-- Q4 University Course Performance
IF DB_ID('UniversityDB') IS NOT NULL BEGIN ALTER DATABASE UniversityDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE UniversityDB; END
GO
CREATE DATABASE UniversityDB;
GO
USE UniversityDB; GO
CREATE TABLE Faculty (FacultyID INT PRIMARY KEY, FacultyName VARCHAR(80) NOT NULL);
CREATE TABLE Student (StudentID INT PRIMARY KEY, StudentName VARCHAR(80) NOT NULL, Dept VARCHAR(30) NOT NULL);
CREATE TABLE Course (CourseID INT PRIMARY KEY, CourseName VARCHAR(60) NOT NULL UNIQUE, FacultyID INT REFERENCES Faculty(FacultyID), Credits INT DEFAULT 3 CHECK (Credits BETWEEN 1 AND 6));
CREATE TABLE Enrollment (EnrollID INT PRIMARY KEY, StudentID INT REFERENCES Student(StudentID), CourseID INT REFERENCES Course(CourseID), Semester INT NOT NULL, UNIQUE(StudentID,CourseID,Semester));
CREATE TABLE Examination (ExamID INT PRIMARY KEY, EnrollID INT REFERENCES Enrollment(EnrollID), Marks INT CHECK (Marks BETWEEN 0 AND 100));
INSERT Faculty VALUES (1,'Dr. Rao'),(2,'Dr. Lakshmi');
INSERT Student VALUES (1,'Arjun','CSE'),(2,'Priya','CSE'),(3,'Karthik','AIML'),(4,'Divya','AIML');
INSERT Course VALUES (10,'DBMS',1,4),(20,'Machine Learning',2,4);
INSERT Enrollment VALUES (1,1,10,1),(2,2,10,1),(3,3,10,1),(4,4,10,1),(5,1,20,2),(6,2,20,2),(7,3,20,2),(8,4,20,2);
INSERT Examination VALUES (1,1,78),(2,2,91),(3,3,85),(4,4,91),(5,5,82),(6,6,88),(7,7,70),(8,8,95);

-- Task 2: set operators
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=10 AND x.Marks>=80
UNION
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=20 AND x.Marks>=80;   -- scored 80+ in either
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=10 AND x.Marks>=80
INTERSECT
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=20 AND x.Marks>=80;   -- both
SELECT StudentName FROM Student
EXCEPT
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE x.Marks<75;                      -- never below 75
-- UNION ALL keeps duplicates; UNION removes them.

-- Task 3: window functions
WITH M AS (
  SELECT s.StudentName, c.CourseName, e.Semester, x.Marks
  FROM Examination x JOIN Enrollment e ON e.EnrollID=x.EnrollID
  JOIN Student s ON s.StudentID=e.StudentID JOIN Course c ON c.CourseID=e.CourseID)
SELECT StudentName, CourseName, Semester, Marks,
  ROW_NUMBER() OVER (PARTITION BY CourseName ORDER BY Marks DESC) AS RowNo,
  RANK()       OVER (PARTITION BY CourseName ORDER BY Marks DESC) AS Rnk,
  DENSE_RANK() OVER (PARTITION BY CourseName ORDER BY Marks DESC) AS DenseRnk,
  LAG(Marks)   OVER (PARTITION BY StudentName ORDER BY Semester)  AS PrevMarks,
  LEAD(Marks)  OVER (PARTITION BY StudentName ORDER BY Semester)  AS NextMarks,
  Marks - LAG(Marks) OVER (PARTITION BY StudentName ORDER BY Semester) AS Trend
FROM M ORDER BY CourseName, Rnk;

GO

-- ===== q05_appointment_dates.sql =====
-- Q5 Hospital Appointment Date Analysis (uses HospitalDB from Q1)
USE HospitalDB; GO
-- Task 1: date parts
SELECT AppointmentID, AppointmentDate,
  YEAR(AppointmentDate) AS Yr, MONTH(AppointmentDate) AS Mth, DAY(AppointmentDate) AS Dy,
  DATENAME(WEEKDAY, AppointmentDate) AS WeekdayName, DATEPART(QUARTER, AppointmentDate) AS Qtr,
  DATENAME(MONTH, AppointmentDate) AS MonthName, EOMONTH(AppointmentDate) AS MonthEnd
FROM Appointment;
SELECT p.PatientName, p.RegDate, a.AppointmentDate,
  DATEDIFF(DAY, p.RegDate, a.AppointmentDate) AS DaysSinceReg
FROM Appointment a JOIN Patient p ON p.PatientID=a.PatientID;

-- Task 2: trends
SELECT YEAR(AppointmentDate) Yr, MONTH(AppointmentDate) Mth, COUNT(*) Appointments
FROM Appointment GROUP BY YEAR(AppointmentDate), MONTH(AppointmentDate) ORDER BY Yr, Mth;
SELECT YEAR(AppointmentDate) Yr, DATEPART(QUARTER,AppointmentDate) Qtr, COUNT(*) Appointments
FROM Appointment GROUP BY YEAR(AppointmentDate), DATEPART(QUARTER,AppointmentDate) ORDER BY Yr, Qtr;
SELECT YEAR(AppointmentDate) Yr, COUNT(*) Appointments FROM Appointment GROUP BY YEAR(AppointmentDate);
SELECT DATEADD(DAY,7,GETDATE()) AS NextWeek;

-- Task 3: string functions
SELECT UPPER(PatientName) AS UpperName, LOWER(City) AS LowerCity, LEN(PatientName) AS NameLen,
  LEFT(PatientName, CHARINDEX(' ',PatientName+' ')-1) AS FirstName,
  LTRIM(SUBSTRING(PatientName, CHARINDEX(' ',PatientName+' '), 50)) AS LastName,
  CONCAT(PatientName,' (',City,')') AS Label
FROM Patient;
SELECT REPLACE(DoctorName,'Dr. ','') AS DoctorShort, CONCAT(DoctorName,' - ',Specialization) AS DoctorInfo FROM Doctor;
SELECT dp.DeptName, STRING_AGG(d.DoctorName, ', ') AS Doctors FROM Department dp JOIN Doctor d ON d.DeptID=dp.DeptID GROUP BY dp.DeptName;

GO

-- ===== q06_banking_reporting_view_proc.sql =====
-- Q6 Banking Management Reporting (uses BankDB from Q2)
USE BankDB; GO
-- Task 1: joins + subquery + aggregation + window
SELECT c.CustomerName, b.BranchName, a.AccountType, a.Balance,
  RANK() OVER (PARTITION BY b.BranchName ORDER BY a.Balance DESC) AS BranchRank,
  SUM(a.Balance) OVER (PARTITION BY b.BranchName) AS BranchTotal,
  a.Balance * 100.0 / SUM(a.Balance) OVER (PARTITION BY b.BranchName) AS PctOfBranch
FROM Account a JOIN Customer c ON c.CustomerID=a.CustomerID JOIN Branch b ON b.BranchID=a.BranchID
WHERE a.Balance > (SELECT AVG(Balance) FROM Account);
GO
-- Task 2: view
CREATE OR ALTER VIEW vw_BranchPerformance AS
SELECT b.BranchID, b.BranchName, b.Region,
  COUNT(DISTINCT a.AccountID) AS TotalAccounts,
  ISNULL(SUM(a.Balance),0) AS TotalBalance,
  (SELECT ISNULL(SUM(t.Amount),0) FROM [Transaction] t JOIN Account a2 ON a2.AccountID=t.AccountID
    WHERE a2.BranchID=b.BranchID AND t.TxnType='Deposit') AS TotalDeposits
FROM Branch b LEFT JOIN Account a ON a.BranchID=b.BranchID
GROUP BY b.BranchID, b.BranchName, b.Region;
GO
SELECT * FROM vw_BranchPerformance ORDER BY TotalBalance DESC;
GO
-- Task 3: stored procedure
CREATE OR ALTER PROCEDURE usp_BranchTransactionReport
  @BranchName VARCHAR(60) = NULL, @FromDate DATE, @ToDate DATE
AS
BEGIN
  SET NOCOUNT ON;
  SELECT b.BranchName, t.TxnID, t.TxnDate, t.TxnType, t.Amount, c.CustomerName
  FROM [Transaction] t JOIN Account a ON a.AccountID=t.AccountID
  JOIN Branch b ON b.BranchID=a.BranchID JOIN Customer c ON c.CustomerID=a.CustomerID
  WHERE t.TxnDate BETWEEN @FromDate AND @ToDate
    AND (@BranchName IS NULL OR b.BranchName=@BranchName)
  ORDER BY t.TxnDate;
END;
GO
EXEC usp_BranchTransactionReport @BranchName='T Nagar', @FromDate='2025-01-01', @ToDate='2025-03-31';

GO

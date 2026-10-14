-- Q2 Employee Payroll Analysis
CREATE DATABASE PayrollDB; GO
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

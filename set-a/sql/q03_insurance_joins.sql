-- Q3 Insurance Policy Management
CREATE DATABASE InsuranceDB; GO
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

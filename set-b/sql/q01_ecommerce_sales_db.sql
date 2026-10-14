-- Q1 E-Commerce Sales Database
CREATE DATABASE EcomDB; GO
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

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

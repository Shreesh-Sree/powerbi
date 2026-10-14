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

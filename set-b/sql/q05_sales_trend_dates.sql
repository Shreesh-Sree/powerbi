-- Q5 Sales Trend and Date Analysis (uses EcomDB)
USE EcomDB; GO
SELECT o.OrderID, o.OrderDate, YEAR(o.OrderDate) Yr, MONTH(o.OrderDate) Mth, DAY(o.OrderDate) Dy,
  DATENAME(WEEKDAY,o.OrderDate) Weekday, DATEPART(QUARTER,o.OrderDate) Qtr, DATEDIFF(DAY,o.OrderDate,o.DeliveryDate) DeliveryDays FROM Orders o;
SELECT YEAR(o.OrderDate) Yr, MONTH(o.OrderDate) Mth, SUM(s.Amount) Sales FROM Orders o JOIN Sales s ON s.OrderID=o.OrderID GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate) ORDER BY Yr, Mth;
SELECT YEAR(o.OrderDate) Yr, SUM(s.Amount) Sales FROM Orders o JOIN Sales s ON s.OrderID=o.OrderID GROUP BY YEAR(o.OrderDate);
SELECT UPPER(CustomerName) UName, LEN(CustomerName) NameLen, LEFT(Email, CHARINDEX('@',Email)-1) UserPart, CONCAT(CustomerName,' - ',City) Label FROM Customer;
SELECT ProductName, REPLACE(ProductName,' ','_') Slug, SUBSTRING(ProductName,1,3) Code, UPPER(LEFT(Category,3)) CatCode FROM Product;

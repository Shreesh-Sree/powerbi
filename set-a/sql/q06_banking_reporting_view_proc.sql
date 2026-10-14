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

# Q8 Banking SQL Server to Power BI
## 1. Import mode
Home > Get Data > SQL Server > Server: `localhost` (or `.\SQLEXPRESS`), Database: `BankDB` > **Import** > select Customer, Account, Branch, Transaction > Transform Data.

## 2. Power Query steps (per table)
- Transaction: set TxnDate/SettlementDate to Date, Amount to Fixed decimal; filter `Amount > 0`; remove unused columns.
- Customer: Trim + Capitalize Each Word on CustomerName; Remove Duplicates on CustomerID.
- Account: Replace null Balance with 0; add custom column `BalanceBand = if [Balance] >= 100000 then "High" else if [Balance] >= 10000 then "Medium" else "Low"`.
- Close & Apply. Check View > Column quality / profile.
```m
let Source = Sql.Database("localhost","BankDB"),
    Txn = Source{[Schema="dbo",Item="Transaction"]}[Data],
    Filtered = Table.SelectRows(Txn, each [Amount] > 0)
in Filtered
```
## 3. DirectQuery
Get Data > SQL Server > same server/db > **DirectQuery**. (Import and DirectQuery tables can coexist = Composite model.)

| Aspect | Import | DirectQuery |
|---|---|---|
| Performance | Fast, in-memory VertiPaq | Slower, every visual sends SQL to the source |
| Refresh | Needs manual/scheduled refresh (max 8/day Pro) | No refresh, always live |
| Data freshness | As of last refresh | Real time |
| Size limit | 1 GB (Pro) compressed | No dataset size limit |
| DAX / Power Query | Full support | Limited (some functions, transformations that cannot fold) |
| Source load | Only at refresh | On every interaction |
| Use when | Most reports | Huge or near real-time data |

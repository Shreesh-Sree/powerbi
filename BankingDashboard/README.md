# Banking Dashboard (Power BI Project)

A Power BI Project (`.pbip`) built for the SD0107 banking questions. It is a text-based version of a `.pbix`: Power BI Desktop opens it like a normal report.

## How to use
1. **Install** the latest Power BI Desktop (Windows, from the Microsoft Store).
2. **Enable the project format**: File > Options and settings > Options > Preview features > tick **Power BI Project (.pbip) save option** and **Store semantic model using TMDL format** > OK > restart Desktop.
3. **Download the repo** (Code > Download ZIP on GitHub, or `git clone https://github.com/Shreesh-Sree/powerbi`).
4. **Open** `BankingDashboard/BankingDashboard.pbip` (File > Open report > Browse, or double-click).
5. Click **Refresh** on the Home tab if visuals are blank. The data is embedded in the model, so no SQL Server or Excel file is needed.
6. **Make a real .pbix**: File > Save As > choose `.pbix`. Use this file for publishing and submission.
7. **Publish** (Q25): Home > Publish > pick a workspace. Then do Q26-Q30 (refresh, RLS, app, pipeline, governance) in the Service using the guides in `set-a/power-bi-guides/`.

## What is inside
- **Tables**: Branch (with Country > State > City > BranchName hierarchy), Customer, Account (BalanceBand calculated column), Transactions, Date.
- **Relationships**: Account to Customer and Branch, Transactions to Account, Date to Transactions on TxnDate (active) and SettlementDate (inactive).
- **Measures** (grouped in display folders): base totals, CALCULATE/ALL region measures, TOTALYTD/MTD/QTD and SAMEPERIODLASTYEAR, USERELATIONSHIP settlement measures, SELECTEDVALUE dynamic title.
- **Page 1 "Overview"**: title card, region and year slicers, 4 cards, bar, line, donut, matrix, table.
- **Page 2 "Time and Settlement"**: YTD/MTD/YoY cards, transaction vs settlement date columns, YTD line, country/quarter matrix.

Covers Q8, Q11-style tables, Q12 star schema, Q14, Q16, Q17 (title), Q18, Q19-Q20 (hierarchy), partly Q21.

## Still to do by hand (needs Desktop)
- Q20 drill through page, Q22 bookmarks and buttons, Q23 tooltip page, Q24 mobile layout, Q27 RLS roles: follow `set-a/power-bi-guides/`.
- Data is sample data (900 transactions, 60 customers). Replace the table queries with your SQL Server source if needed (Home > Transform data > Advanced Editor).

## If Desktop shows an error on open
Send me the exact message and I will fix the file. The files were validated against Microsoft's PBIR schemas but not opened in Desktop.

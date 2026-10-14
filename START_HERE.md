# SD0107 Complete Guide: Data Analytics with Power BI and SQL Server

Follow this top to bottom. Every file you need is in this repo. Download everything with **Code > Download ZIP** on GitHub and unzip it (example: `C:\SD0107`).

## 0. What is in this repo
| Folder / file | What it is |
|---|---|
| `mcq/answers.md` | Answers for the 50 MCQs |
| `sql-run-all/run_all_set_a.sql`, `run_all_set_b.sql` | One-click SQL for Q1-Q6 (creates all databases, tables, data, queries, view, procedure) |
| `BankingDashboard/BankingDashboard.pbip` | Ready Power BI project (model, DAX, 2 report pages) |
| `data/banking/*.csv` + `measures.dax` | Same banking data as CSV, plus all DAX measures, as a backup if the .pbip will not open |
| `sample-data/*.xlsx` | Messy Excel files for Q7, Q9, Q10 (Power Query practice) |
| `set-a/`, `set-b/` | Per-question solutions: `sql/`, `power-query/`, `dax/`, `power-bi-guides/` |

## 1. One-time setup (30 minutes)
1. Install **SQL Server Developer** or **Express** and **SSMS** (both free from Microsoft).
2. Install **Power BI Desktop** (Windows, Microsoft Store).
3. In Power BI Desktop: File > Options and settings > Options > Preview features > tick **Power BI Project (.pbip) save option** and **Store semantic model using TMDL format**. Restart Desktop. (If these options are not listed, your version already has them on.)
4. Create a free Power BI account with your college email to use Power BI Service (app.powerbi.com).
5. Copy `sample-data` to `C:\Data` (the Power Query scripts expect `C:\Data\Attendance.xlsx` and so on).

## 2. Q1-Q6: SQL Server (about 20 minutes)
1. Open SSMS, connect to your server (`localhost` or `.\SQLEXPRESS`).
2. File > Open > File > `sql-run-all/run_all_set_a.sql` (or `set_b`, whichever set you are assessed on). Click **Execute** (F5).
3. For evidence, run the individual query blocks from `set-a/sql/q01...q06` one at a time and screenshot each result grid. Show the Messages tab for table creation.
Note: I could not run SQL Server here, so if a statement errors, read the error, fix that line, and re-run (the script is safe to re-run).

## 3. Q7-Q24: Power BI Desktop
### Quick path: open the ready project (Q8, Q12, Q14, Q16, Q17, Q18, Q19, Q20 partly)
1. Open `BankingDashboard/BankingDashboard.pbip` in Power BI Desktop. If a yellow bar appears, click **Refresh**.
2. Explore Model view (relationships, hierarchy), Data view, and the two report pages.
3. **File > Save As > .pbix** and keep this file as your main deliverable.
### Backup path if the .pbip will not open (15 minutes)
1. New Power BI Desktop file > Get Data > Text/CSV: load the four CSVs in `data/banking`. Close & Apply.
2. Open `data/banking/measures.dax` and paste the Date table, the BalanceBand column and the measures as the file says.
3. Model view: relate Account[CustomerID]->Customer, Account[BranchID]->Branch, Transactions[AccountID]->Account, Date[Date]->Transactions[TxnDate]; add Date[Date]->Transactions[SettlementDate] and untick "Make this relationship active". Mark Date as date table.
4. Build visuals from `set-a/power-bi-guides/q19_...md`.
### Questions the project does not cover (do them in the same file)
| Question | What to do | Guide |
|---|---|---|
| Q7 | Load `Attendance.xlsx`, apply the steps | `set-a/power-query/q07_attendance_cleaning.pq` |
| Q9 | Load the 3 Patient files and `Appointments_Billing.xlsx`, append and merge | `q09_hospital_append_merge.pq` |
| Q10 | Load `Budget.xlsx`, unpivot and pivot | `q10_budget_pivot_unpivot.pq` |
| Q11 | Add the MinTxnAmount parameter to the Transactions query | `q11_min_amount_parameter.pq` |
| Q13, Q15 | Hospital or attendance measures (use the Excel samples) | `set-a/dax/q13...q15` |
| Q20 drill through, Q21, Q22, Q23, Q24 | Build in Desktop by clicks | `set-a/power-bi-guides/q20...q24` |
Tip: do Q7, Q9, Q10 in a separate small .pbix so the banking file stays clean.

## 4. Q25-Q30: Power BI Service
Publish the .pbix (Home > Publish), then follow `set-a/power-bi-guides/q25...q30`. Q29 needs a Premium/Fabric workspace; if you do not have one, explain the steps and screenshot what you can.

## 5. Evidence checklist (what examiners usually want)
- Q1-Q6: screenshot of the script and the result grid
- Q7-Q12: screenshot of Applied Steps in Power Query, before/after table
- Q13-Q18: screenshot of the measure formula and the visual using it
- Q19-Q24: screenshot of each dashboard page; for bookmarks/drill-through show the working navigation
- Q25-Q30: screenshot of the workspace, schedule refresh page, RLS roles, app, pipeline stages

## 6. If something fails
| Problem | Fix |
|---|---|
| .pbip will not open or shows an error | Use the backup path above, and send me the exact error text |
| Visuals empty | Home > Refresh |
| SQL error on a line | Run the file again after fixing; databases are dropped and recreated |
| Date relationship ambiguity warning | Make sure only the TxnDate relationship is active |
| Cannot publish | Sign in with a work/school/college account (personal Gmail is not accepted) |

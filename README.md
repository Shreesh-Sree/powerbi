# SD0107: Data Analytics with Power BI and SQL Server (EEC Course)

Answers, scripts, sample data and a ready Power BI project for the EEC course question paper. This page explains everything from zero. You do not need any prior experience.

> **Honest note:** the SQL, Power Query, DAX and Power BI project files were written and checked against Microsoft's file schemas, but they were not run on a real SQL Server or opened in Power BI Desktop by the author. If something errors, the fixes are in [Section 9](#9-if-something-goes-wrong). Always test before you submit.

---

## Contents
1. [What this repository is](#1-what-this-repository-is)
2. [What the exam paper contains](#2-what-the-exam-paper-contains)
3. [Folder map: what is where](#3-folder-map-what-is-where)
4. [Download the repository](#4-download-the-repository)
5. [Install the software (free)](#5-install-the-software-free)
6. [Step by step: MCQs](#6-step-by-step-mcqs)
7. [Step by step: practical questions](#7-step-by-step-practical-questions)
8. [Which set am I doing, and what do I submit?](#8-which-set-am-i-doing-and-what-do-i-submit)
9. [If something goes wrong](#9-if-something-goes-wrong)
10. [Glossary for beginners](#10-glossary-for-beginners)

---

## 1. What this repository is
- It is a folder of files hosted on GitHub. You can download it all as one ZIP.
- It holds the **answers to the 50 MCQs** and **solutions for all 60 practical questions** (30 in Set A and 30 in Set B).
- It also holds sample data, one-click SQL scripts and a ready-made Power BI dashboard project, so you can practise without creating data yourself.
- Use it to learn the method, run it yourself, and take your own screenshots as evidence. Do not submit it unchanged without understanding it.

## 2. What the exam paper contains
| Part | Questions | Topic | Tool you use |
|---|---|---|---|
| MCQs | 50 | Power BI, DAX, Power Query concepts | None (read and answer) |
| Set A | Q1 to Q30 | Hospital, banking, insurance, university, call center | SQL Server, Power BI |
| Set B | Q1 to Q30 | E-commerce, payroll, retail sales | SQL Server, Power BI |

The 30 practical questions in each set follow the same pattern:

| Questions | Skill | Tool |
|---|---|---|
| Q1 to Q6 | SQL (tables, joins, subqueries, windows, view, stored procedure) | SQL Server + SSMS |
| Q7 to Q12 | Cleaning and shaping data | Power BI Desktop, **Power Query** |
| Q13 to Q18 | Calculations and time intelligence | Power BI Desktop, **DAX** |
| Q19 to Q24 | Dashboards, drill down, bookmarks, tooltips, mobile layout | Power BI Desktop |
| Q25 to Q30 | Publishing, refresh, security, apps, pipelines, governance | **Power BI Service** (website) |

## 3. Folder map: what is where
```
README.md                  <- you are here
START_HERE.md              <- short checklist version of this guide
mcq/
  answers.md               <- all 50 MCQs, each with options and the correct answer
sql-run-all/
  run_all_set_a.sql        <- ONE file that builds every Set A database (Q1 to Q6)
  run_all_set_b.sql        <- same for Set B
set-a/  and  set-b/        <- per-question solutions (same layout in both)
  sql/                     <- Q1 to Q6 SQL, one file per question
  power-query/             <- Q7 to Q12 (.pq = Power Query M code, .md = steps)
  dax/                     <- Q13 to Q18 DAX formulas
  power-bi-guides/         <- Q19 to Q30 click-by-click guides
sample-data/               <- practice Excel files for Q7, Q9, Q10
data/banking/              <- banking data as CSV + measures.dax (backup for the project)
BankingDashboard/          <- ready Power BI Project (open the .pbip file)
```

## 4. Download the repository
**Easiest way (no tools needed):**
1. Open the repository page on GitHub: <https://github.com/Shreesh-Sree/powerbi>
2. Click the green **Code** button, then **Download ZIP**.
3. Right-click the ZIP and choose **Extract All**. Put the folder somewhere simple, for example `C:\SD0107`.

**If you know Git:** `git clone https://github.com/Shreesh-Sree/powerbi.git`

## 5. Install the software (free)
Do these once. Allow about 30 to 60 minutes for downloads.

| # | Software | Why | Where |
|---|---|---|---|
| 1 | **SQL Server** (Developer or Express edition) | The database for Q1 to Q6 | Microsoft SQL Server downloads page |
| 2 | **SSMS** (SQL Server Management Studio) | The window where you type and run SQL | Microsoft, search "Download SSMS" |
| 3 | **Power BI Desktop** | Build reports (Q7 to Q24) | Microsoft Store, search "Power BI Desktop" |
| 4 | **Power BI Service account** | Publish and share (Q25 to Q30) | <https://app.powerbi.com> using your **college or work email** (personal Gmail is usually rejected) |

Both SQL Server and Power BI Desktop need **Windows**. On Mac or Linux use a Windows PC, a college lab computer or a Windows virtual machine.

**Turn on the project format (one time, for the ready dashboard):**
Power BI Desktop > File > Options and settings > Options > Preview features > tick **Power BI Project (.pbip) save option** and **Store semantic model using TMDL format** > OK > restart Power BI Desktop. If those options are not listed, your version already has them.

**Put the sample Excel files where the scripts expect them:** create the folder `C:\Data` and copy everything from `sample-data` into it.

## 6. Step by step: MCQs
1. Open `mcq/answers.md` (click it on GitHub, or open it in Notepad).
2. Each question shows the four options, then the correct answer in bold.
3. Do not just memorise. For wrong guesses, read the option you picked and ask why it is wrong. Most MCQs are about: DAX versus M versus SQL, Power Query steps (Append, Merge, Unpivot, Group By), visuals, and Service features.

## 7. Step by step: practical questions

### Part 1: SQL (Q1 to Q6)
1. Open **SSMS** and connect (server name is usually `localhost` or `.\SQLEXPRESS`, Windows Authentication).
2. Choose File > Open > File and pick `sql-run-all/run_all_set_a.sql` (or `run_all_set_b.sql`).
3. Click **Execute** (or press F5). This creates every database, table, sample row, the view and the stored procedure. It is safe to run again: it deletes and rebuilds the databases.
4. For your evidence, open the single files in `set-a/sql/` (for example `q01_hospital_patient_db.sql`), run **one query at a time** (select it, press F5) and screenshot the result grid.
5. Q5 uses the Q1 database and Q6 uses the Q2 database, so run Q1 and Q2 first.

### Part 2: Power Query (Q7 to Q12)
Power Query is the "Transform data" window in Power BI. It cleans data before it loads.
1. Open Power BI Desktop. Choose **Get data > Excel workbook** and pick a file from `C:\Data` (for example `Attendance.xlsx` for Q7).
2. Click **Transform Data**. The Power Query window opens.
3. Open the matching file in `set-a/power-query/` (or `set-b/`). Files ending `.pq` hold the whole script: in Power Query go to **Home > Advanced Editor**, paste the script, fix the file path if needed, click **Done**.
4. Check the **Applied Steps** panel on the right. Screenshot it, plus the table before and after cleaning.
5. Files ending `.md` (Q8 and Q12) are written steps, not scripts.
6. Tip: use a separate small `.pbix` for Q7, Q9 and Q10 so your main dashboard file stays clean.

### Part 3: DAX (Q13 to Q18)
DAX is the formula language for calculations.
1. Load your tables (see the dashboard section below) and open **Report view**.
2. Right-click a table in the Data pane > **New measure** (or **New column** where the question says calculated column).
3. Paste one formula from the matching file in `dax/`. Press Enter.
4. Drag the new measure onto a visual (a Card, Table or chart) and screenshot the formula bar and the visual.
5. Q16 and Q18 need a **Date table** and relationships. The file shows the formula. In **Model view** drag the Date column onto the date column of the data table. For the inactive relationship (Q18) double-click the line and **untick "Make this relationship active"**.

### Part 4: Dashboard (Q19 to Q24)
**Fast route, banking dashboard already built:**
1. In the extracted folder open `BankingDashboard/BankingDashboard.pbip` with Power BI Desktop.
2. If the visuals are blank click **Refresh** on the Home tab. The data is stored inside the project, so no database or Excel file is needed.
3. Look around: **Report view** (two pages), **Data view** (tables) and **Model view** (relationships and the Geography hierarchy).
4. Choose **File > Save As** and save as a `.pbix`. That is the file you publish and submit.

**Backup route if the project will not open (about 15 minutes):**
1. New Power BI file > **Get data > Text/CSV** and load the four CSV files in `data/banking`. Click **Close and Apply**.
2. Open `data/banking/measures.dax`. It tells you exactly what to paste: the Date table, the BalanceBand column, then every measure.
3. In **Model view** create these relationships (drag from one column to the other): Account to Customer, Account to Branch, Transactions to Account, Date to Transactions (TxnDate, active) and Date to Transactions (SettlementDate, inactive). Mark Date as a date table.
4. Build visuals by following `set-a/power-bi-guides/q19_...md`.

**Things you must still build by hand** (they need clicks in Desktop; each guide explains how): bookmarks and buttons (Q22), tooltip page (Q23), drill-through page (Q20 and Q23), mobile layout (Q24), slicer syncing and conditional formatting (Q21).

**The project is for banking.** The hospital, call-center and retail dashboards follow the same steps with your own data. Use the guide for your question.

### Part 5: Power BI Service (Q25 to Q30)
These are done in your web browser at <https://app.powerbi.com>.
1. In Desktop click **Home > Publish** and choose a workspace (Q25).
2. Follow the matching guide: `power-bi-guides/q25...` to `q30...`: pin a dashboard (Q25), set scheduled refresh (Q26), row-level security (Q27), create an app (Q28), deployment pipeline (Q29), governance write-up (Q30).
3. Notes: Q26 needs the on-premises data gateway only if your data is on your own PC. Q29 needs a Premium, PPU or Fabric workspace. If you do not have that licence, write the steps and screenshot what you can.

## 8. Which set am I doing, and what do I submit?
- **Which set:** ask your faculty. Set A uses hospital, banking and insurance themes. Set B uses retail and employee themes. The method is the same. Use the folder that matches your paper.
- **What to submit** is decided by your institution. A common safe bundle:
  - The `.sql` files and screenshots of their results (Q1 to Q6)
  - Screenshots of Power Query **Applied Steps** (Q7 to Q12)
  - Screenshots of DAX formulas and visuals (Q13 to Q18)
  - Your `.pbix` and screenshots of every dashboard page (Q19 to Q24)
  - Screenshots from the Service: workspace, refresh schedule, RLS roles, app, pipeline (Q25 to Q30)
- Ask whether it is a screenshot submission or a **live demo**. For a live demo, practise opening your `.pbix` and explaining each visual.

## 9. If something goes wrong
| Problem | What to do |
|---|---|
| `.pbip` will not open | Make sure the preview features in Section 5 are on, then use the backup route. If an error message appears, copy its exact text and ask for help |
| Visuals are empty | Home > **Refresh** |
| SQL error on one line | Read the error, fix that line, run the whole file again (it rebuilds cleanly) |
| Cannot connect to SQL Server | Check the server name in SSMS. Make sure the SQL Server service is running (Windows Services) |
| Excel path error in Power Query | Copy the files to `C:\Data`, or edit the path inside the script |
| Two relationships to the Date table warn about ambiguity | Only one may be active. Make the SettlementDate one inactive |
| Cannot sign in to Power BI Service | Use a college or work email. Personal Gmail is usually not accepted |
| Cannot publish or create a pipeline | Pipelines need a Premium, PPU or Fabric workspace. Explain the steps and screenshot what is available |

## 10. Glossary for beginners
- **SQL Server:** a database program. **SSMS:** the window used to talk to it.
- **Power BI Desktop:** the Windows app where you build reports. **Power BI Service:** the website where you share them.
- **Power Query (M):** the cleaning tool. Steps are recorded in "Applied Steps".
- **DAX:** the formula language for calculations. A **measure** is recalculated for whatever the visual shows. A **calculated column** is computed once per row.
- **Fact table:** rows of events and numbers (transactions). **Dimension table:** descriptive lists (customers, branches). Together they form a **star schema**.
- **Relationship:** a link between two tables on a shared column.
- **Import vs DirectQuery:** Import copies the data into the file (fast). DirectQuery asks the source each time (always current, slower).
- **.pbix:** a Power BI report file. **.pbip:** the same report saved as a folder of text files.
- **RLS (Row-Level Security):** rules that limit which rows each user can see.
- **Workspace:** a shared folder in the Service. **App:** a packaged set of reports for end users.
- **Gateway:** software that lets the Service reach data on your own PC or server.

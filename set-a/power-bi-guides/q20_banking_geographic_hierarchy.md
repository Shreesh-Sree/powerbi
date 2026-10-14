# Q20 Banking Geographic Hierarchy
1. Data pane > right-click `Country` in Branch table > **Create hierarchy**. Drag State, City, BranchName under it. Rename hierarchy `Geography`.
2. **Drill down**: add a Bar chart, Axis = Geography hierarchy, Values = Total Deposits. Turn on Drill mode (down-arrow icon), use "Go to next level" (forked arrows) to expand all, or click a bar when drill-mode is on.
3. **Drill through**: create page `Branch Detail`; add Branch[BranchName] to the Drill-through fields well (Keep all filters on); add cards (Deposits, Customers, Transactions) and a transaction table. Back button is added automatically. On the main page right-click a branch bar > Drill through > Branch Detail.
4. Visuals per level: Map or filled map (Country/State, Size = Deposits), Bar chart (City), Table (Branch with Customers = DISTINCTCOUNT(Account[CustomerID]) and Transactions = COUNTROWS(Transaction)), Card totals.

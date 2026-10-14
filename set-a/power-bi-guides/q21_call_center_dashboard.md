# Q21 Call Center Performance Dashboard
**Measures**: `Calls Handled = SUM(Calls[CallsHandled])`, `Resolution Rate = DIVIDE(SUM(Calls[Resolved]),[Calls Handled])`, `Avg CSAT = AVERAGE(Calls[CSAT])`, `CSAT Target = 4.2`.
1. **Visuals**: KPI (Value Avg CSAT, Target CSAT Target, Trend axis Month), Cards for calls and resolution rate, Matrix (Rows Agent, Values the three measures), Clustered bar (Agent vs Calls Handled), Line chart (Resolution Rate by Month).
2. **Conditional formatting**: Matrix > Format > Cell elements > select field > fx. Rules: Resolution Rate >= 0.9 green, < 0.7 red. Also try data bars on Calls Handled and icons (up/down) on CSAT.
3. **Slicers**: Team, Month, Shift. View > **Sync slicers** pane: tick Sync and Visible for each report page, or use the same slicer copied to page 2. Create page 2 (Agent Detail) and verify the filter carries over.

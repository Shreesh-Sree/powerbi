# Q8 SQL Server to Power BI Analysis
1. **Import**: Home > Get Data > SQL Server > Server `localhost`, Database `EcomDB` > Import > pick Customer, Product, Orders, Sales > Transform Data.
2. **Transform**: set types, trim text, remove duplicates on keys, filter `Quantity > 0`, add `Sales Amount` custom column, disable load on staging queries. Close & Apply.
3. **DirectQuery**: Get Data > SQL Server > choose **DirectQuery**.

| | Import | DirectQuery |
|---|---|---|
| Speed | Fast (in-memory) | Slower, sends SQL per visual |
| Data freshness | Until next refresh | Always current |
| Refresh | Scheduled (8/day Pro) | Not needed |
| Size | Limited (1 GB Pro) | Source holds data |
| Features | Full DAX, all Power Query | Some DAX/M limits |
| Source load | At refresh only | Every interaction |

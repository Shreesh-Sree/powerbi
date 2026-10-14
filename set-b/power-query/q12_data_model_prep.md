# Q12 Data Model Preparation
1. Clean Customer, Product, Date, Sales in Power Query (types, trim, nulls, duplicates, errors).
2. **Dimensions**: DimCustomer (CustomerID, Name, City, Region), DimProduct (ProductID, Name, Category, UnitPrice), DimDate (generated calendar with Year, Month, MonthNo, Quarter). **Fact**: FactSales (SaleID, OrderID, CustomerID, ProductID, OrderDateKey, Quantity, Amount, SalesAmount = Quantity*UnitPrice).
3. **Keys**: unique, non-null primary keys on each dimension (Remove Duplicates, verify with Column distribution). Foreign keys in fact must exist in dimension (check with Merge > Left Anti).
4. Relationships in Model view: DimCustomer[CustomerID]->FactSales[CustomerID], DimProduct[ProductID]->FactSales[ProductID], DimDate[Date]->FactSales[OrderDate]; all one-to-many, single direction. Mark DimDate as date table.
```m
let Dates = List.Dates(#date(2024,1,1), 1096, #duration(1,0,0,0)),
 T = Table.TransformColumnTypes(Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}),{{"Date", type date}}),
 Y = Table.AddColumn(T,"Year", each Date.Year([Date]), Int64.Type),
 M = Table.AddColumn(Y,"Month", each Date.MonthName([Date]), type text),
 MN = Table.AddColumn(M,"MonthNo", each Date.Month([Date]), Int64.Type)
in MN
```

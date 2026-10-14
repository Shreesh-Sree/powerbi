// Q11 Parameter-Based Power Query
// Home > Manage Parameters > New: Name MinSalesAmount, Type Decimal Number, Current value 10000
let
  Source = Sql.Database("localhost","EcomDB"),
  Sales = Source{[Schema="dbo",Item="Sales"]}[Data],
  Filtered = Table.SelectRows(Sales, each [Amount] >= MinSalesAmount)
in Filtered
// Change MinSalesAmount to 20000 > Close & Apply > rows and totals shrink. Document before/after.

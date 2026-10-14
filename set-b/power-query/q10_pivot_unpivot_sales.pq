// Q10 Pivot and Unpivot Sales Data (Product, Category, Jan..Dec)
let
  Source = Excel.Workbook(File.Contents("C:\Data\MonthlySales.xlsx"), null, true){[Item="Sales",Kind="Sheet"]}[Data],
  Promoted = Table.PromoteHeaders(Source),
  Unpivot = Table.UnpivotOtherColumns(Promoted, {"Product","Category"}, "Month", "Sales"),
  Typed = Table.TransformColumnTypes(Unpivot, {{"Month", type text},{"Sales", Currency.Type}}),
  Pivot = Table.Pivot(Typed, List.Distinct(Typed[Category]), "Category", "Sales", List.Sum)
in Pivot
// Validate: 12 distinct Month values, no null/error rows, total Sales equals the original grid total.

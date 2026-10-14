// Q10 Monthly Budget Transformation (columns: Department, Category, Jan..Dec)
let
  Source = Excel.Workbook(File.Contents("C:\Data\Budget.xlsx"), null, true){[Item="Budget",Kind="Sheet"]}[Data],
  Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
  // Task 1: Unpivot (select Department + Category > right click > Unpivot Other Columns)
  Unpivoted = Table.UnpivotOtherColumns(Promoted, {"Department","Category"}, "Month", "Budget"),
  Typed = Table.TransformColumnTypes(Unpivoted, {{"Department", type text},{"Category", type text},{"Month", type text},{"Budget", Currency.Type}}),
  NoNulls = Table.ReplaceValue(Typed, null, 0, Replacer.ReplaceValue, {"Budget"}),
  // Task 2: Pivot back to summarise by department (Category as columns, sum of Budget)
  Pivoted = Table.Pivot(NoNulls, List.Distinct(NoNulls[Category]), "Category", "Budget", List.Sum),
  // Task 3: validation
  RowCheck = Table.RowCount(NoNulls)   // expect Departments x Categories x 12
in
  Pivoted
// Validate: View > Column Profile (distinct Month = 12, no errors); compare SUM(Budget) before and after unpivot.

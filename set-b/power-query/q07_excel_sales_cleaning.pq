// Q7 Excel Sales Data Transformation
let
  Source = Excel.Workbook(File.Contents("C:\Data\Sales.xlsx"), null, true){[Item="Sales",Kind="Sheet"]}[Data],
  Promoted = Table.PromoteHeaders(Table.Skip(Source,1), [PromoteAllScalars=true]),
  RemovedCols = Table.RemoveColumns(Promoted, {"Remarks","Column10"}, MissingField.Ignore),
  NoBlank = Table.SelectRows(RemovedCols, each [OrderID] <> null and [OrderID] <> ""),
  Typed = Table.TransformColumnTypes(NoBlank, {{"OrderID", Int64.Type},{"OrderDate", type date},{"CustomerName", type text},{"Product", type text},{"Quantity", Int64.Type},{"UnitPrice", Currency.Type},{"Region", type text}}, "en-US"),
  NoErrors = Table.RemoveRowsWithErrors(Typed),
  FillNulls = Table.ReplaceValue(Table.ReplaceValue(NoErrors, null, 0, Replacer.ReplaceValue, {"Quantity"}), null, "Unknown", Replacer.ReplaceValue, {"Region"}),
  Clean = Table.TransformColumns(FillNulls, {{"CustomerName", each Text.Proper(Text.Trim(_)), type text}}),
  Split = Table.SplitColumn(Clean, "CustomerName", Splitter.SplitTextByDelimiter(" "), {"FirstName","LastName"}),
  Merged = Table.AddColumn(Split, "Product Key", each [Product] & "-" & [Region], type text),
  Sales = Table.AddColumn(Merged, "Sales Amount", each [Quantity]*[UnitPrice], Currency.Type),
  Renamed = Table.RenameColumns(Sales, {{"OrderID","Order ID"},{"OrderDate","Order Date"}})
in Renamed

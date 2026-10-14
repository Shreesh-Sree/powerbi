// Q7 Employee Attendance Data Transformation (Home > Get Data > Excel > Attendance.xlsx > Transform Data)
let
  Source = Excel.Workbook(File.Contents("C:\Data\Attendance.xlsx"), null, true),
  Sheet = Source{[Item="Attendance",Kind="Sheet"]}[Data],
  // Task 1: remove junk rows/columns
  SkipTop = Table.Skip(Sheet, 2),
  Promoted = Table.PromoteHeaders(SkipTop, [PromoteAllScalars=true]),
  RemovedCols = Table.RemoveColumns(Promoted, {"Notes","Column9"}, MissingField.Ignore),
  NoBlankRows = Table.SelectRows(RemovedCols, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
  // Task 2: types, nulls, errors, duplicates
  Typed = Table.TransformColumnTypes(NoBlankRows, {{"EmpID", Int64.Type}, {"EmpName", type text}, {"Date", type date}, {"InTime", type time}, {"OutTime", type time}, {"Department", type text}}, "en-GB"),
  NoErrors = Table.RemoveRowsWithErrors(Typed, {"Date","InTime","OutTime"}),
  FilledDept = Table.ReplaceValue(NoErrors, null, "Unknown", Replacer.ReplaceValue, {"Department"}),
  NoNullIDs = Table.SelectRows(FilledDept, each [EmpID] <> null),
  Deduped = Table.Distinct(NoNullIDs, {"EmpID","Date"}),
  // Task 3: split / merge / rename / derive
  Trimmed = Table.TransformColumns(Deduped, {{"EmpName", Text.Trim, type text}, {"Department", Text.Proper, type text}}),
  SplitName = Table.SplitColumn(Trimmed, "EmpName", Splitter.SplitTextByDelimiter(" ", QuoteStyle.Csv), {"FirstName","LastName"}),
  Merged = Table.AddColumn(SplitName, "EmpLabel", each Text.From([EmpID]) & " - " & [FirstName], type text),
  Hours = Table.AddColumn(Merged, "WorkHours", each if [OutTime] <> null and [InTime] <> null then Duration.TotalHours([OutTime]-[InTime]) else 0, type number),
  Renamed = Table.RenameColumns(Hours, {{"EmpID","Employee ID"},{"InTime","Check In"},{"OutTime","Check Out"}})
in
  Renamed

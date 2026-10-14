// Q9 Append and Merge Customer Data
let
  // Folder approach: Get Data > Folder > Combine & Transform; or Append Queries
  Appended = Table.Combine({Customers_Jan, Customers_Feb, Customers_Mar}),
  Deduped = Table.Distinct(Appended, {"CustomerID"}),
  Merge = Table.NestedJoin(Deduped, {"CustomerID"}, Transactions, {"CustomerID"}, "Txn", JoinKind.LeftOuter),
  Expand = Table.ExpandTableColumn(Merge, "Txn", {"TransactionID","Amount","TxnDate"}),
  FillNull = Table.ReplaceValue(Expand, null, 0, Replacer.ReplaceValue, {"Amount"}),
  NoErrors = Table.RemoveRowsWithErrors(FillNull)
in NoErrors
// Unmatched customers: JoinKind.LeftAnti. Orphan transactions: JoinKind.RightAnti.

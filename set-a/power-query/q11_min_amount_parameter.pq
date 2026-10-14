// Q11 Dynamic Banking Parameter
// Task 1: Home > Manage Parameters > New Parameter
//   Name: MinTxnAmount | Type: Decimal Number | Suggested values: Any value | Current Value: 5000
// It creates this query:
//   MinTxnAmount = 5000 meta [IsParameterQuery=true, Type="Number", IsParameterQueryRequired=true]

// Task 2: apply parameter in Transaction query
let
  Source = Sql.Database("localhost","BankDB"),
  Txn = Source{[Schema="dbo",Item="Transaction"]}[Data],
  Filtered = Table.SelectRows(Txn, each [Amount] >= MinTxnAmount)
in
  Filtered

// Task 3: change the value (Home > Manage Parameters, or Transform data > Edit Parameters), set 20000,
// Close & Apply, and verify: row count and SUM(Amount) drop. Record before/after counts as evidence.

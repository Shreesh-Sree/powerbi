// Q9 Monthly Hospital Patient Data: Append + Merge
// Queries: Patients_Jan, Patients_Feb, Patients_Mar (same columns), Appointments, Billing
let
  // Task 1: Append (or Home > Append Queries as New > Three or more tables)
  AllPatients = Table.Combine({Patients_Jan, Patients_Feb, Patients_Mar}),
  Deduped = Table.Distinct(AllPatients, {"PatientID"}),
  NoNullID = Table.SelectRows(Deduped, each [PatientID] <> null),
  // Task 2: Merge with appointments then billing on PatientID / AppointmentID
  MergeAppt = Table.NestedJoin(NoNullID, {"PatientID"}, Appointments, {"PatientID"}, "Appt", JoinKind.LeftOuter),
  ExpandAppt = Table.ExpandTableColumn(MergeAppt, "Appt", {"AppointmentID","DoctorID","AppointmentDate"}),
  MergeBill = Table.NestedJoin(ExpandAppt, {"AppointmentID"}, Billing, {"AppointmentID"}, "Bill", JoinKind.LeftOuter),
  ExpandBill = Table.ExpandTableColumn(MergeBill, "Bill", {"Amount","PaymentStatus"}),
  // Task 3: unmatched, nulls, errors
  Unmatched = Table.SelectRows(ExpandBill, each [AppointmentID] = null),   // patients with no appointment (use JoinKind.LeftAnti for a separate query)
  FillAmount = Table.ReplaceValue(ExpandBill, null, 0, Replacer.ReplaceValue, {"Amount"}),
  FillStatus = Table.ReplaceValue(FillAmount, null, "No Bill", Replacer.ReplaceValue, {"PaymentStatus"}),
  Clean = Table.RemoveRowsWithErrors(FillStatus)
in
  Clean
// Anti-join checks: JoinKind.LeftAnti = patients without appointments, JoinKind.RightAnti = orphan appointments.

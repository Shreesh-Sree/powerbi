# Q12 Healthcare Data Model (Star Schema)
## 1. Clean every source in Power Query
Trim/Clean text, set data types, remove duplicates on each key, replace nulls, remove errors, promote headers.

## 2. Fact and dimension tables
- **Fact tables**: `FactAppointment` (AppointmentID, PatientKey, DoctorKey, DeptKey, DateKey, Status), `FactBilling` (BillID, AppointmentID, PatientKey, DateKey, Amount, PaymentStatus).
- **Dimensions**: `DimPatient`, `DimDoctor`, `DimDepartment`, `DimDate`.
Create dimensions by Reference of source > Remove Other Columns > Remove Duplicates. Build the fact by merging with dimensions and keeping only keys + numeric columns.

## 3. Keys + relationships
```m
// DimDate
let Start=#date(2024,1,1), End=#date(2026,12,31),
 Dates=List.Dates(Start, Duration.Days(End-Start)+1, #duration(1,0,0,0)),
 T=Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}),
 Typed=Table.TransformColumnTypes(T,{{"Date",type date}}),
 Key=Table.AddColumn(Typed,"DateKey",each Date.Year([Date])*10000+Date.Month([Date])*100+Date.Day([Date]),Int64.Type),
 Year=Table.AddColumn(Key,"Year",each Date.Year([Date]),Int64.Type),
 Month=Table.AddColumn(Year,"Month",each Date.MonthName([Date]),type text),
 MonthNo=Table.AddColumn(Month,"MonthNo",each Date.Month([Date]),Int64.Type),
 Qtr=Table.AddColumn(MonthNo,"Quarter",each "Q"&Text.From(Date.QuarterOfYear([Date])),type text)
in Qtr
```
Model view: one-to-many, single direction, dimension (1) to fact (*):
DimPatient[PatientID]->FactAppointment[PatientID]; DimDoctor[DoctorID]->FactAppointment[DoctorID]; DimDepartment[DeptID]->DimDoctor[DeptID] (snowflake) or into the fact; DimDate[Date]->FactAppointment[AppointmentDate]; FactAppointment[AppointmentID]->FactBilling[AppointmentID]. Mark DimDate as date table. Hide key columns on fact tables.

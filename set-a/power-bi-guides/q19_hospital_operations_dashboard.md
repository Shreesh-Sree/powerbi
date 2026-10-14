# Q19 Hospital Operations Dashboard
**Model**: Patient, Doctor, Department, Date, Appointment, Billing (star schema from Q12).
**Measures**: `Total Patients = DISTINCTCOUNT(FactAppointment[PatientID])`, `Treatment Revenue = SUM(FactBilling[Amount])`, `Total Appointments = COUNTROWS(FactAppointment)`, `Revenue per Doctor = DIVIDE([Treatment Revenue],DISTINCTCOUNT(DimDoctor[DoctorID]))`.
**Visuals (Report view > Visualizations pane)**
1. Cards: Total Patients, Treatment Revenue, Total Appointments.
2. Bar chart: Axis DimDoctor[DoctorName], Values Treatment Revenue (doctor performance).
3. Line chart: Axis DimDate[Month], Values Total Appointments.
4. Donut: Legend DimDepartment[DeptName], Values Treatment Revenue.
5. Pie: Legend DimPatient[PatientType], Values Total Patients.
6. Table: Doctor, Department, Appointments, Revenue.
7. Matrix: Rows Department > Doctor, Columns Year, Values Revenue (department statistics).
**Slicers**: Department, Doctor, Patient Type, Date (Between style). Format > Edit interactions to control cross-filtering. Apply a theme and align visuals with Format > Align.

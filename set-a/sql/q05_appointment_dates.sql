-- Q5 Hospital Appointment Date Analysis (uses HospitalDB from Q1)
USE HospitalDB; GO
-- Task 1: date parts
SELECT AppointmentID, AppointmentDate,
  YEAR(AppointmentDate) AS Yr, MONTH(AppointmentDate) AS Mth, DAY(AppointmentDate) AS Dy,
  DATENAME(WEEKDAY, AppointmentDate) AS WeekdayName, DATEPART(QUARTER, AppointmentDate) AS Qtr,
  DATENAME(MONTH, AppointmentDate) AS MonthName, EOMONTH(AppointmentDate) AS MonthEnd
FROM Appointment;
SELECT p.PatientName, p.RegDate, a.AppointmentDate,
  DATEDIFF(DAY, p.RegDate, a.AppointmentDate) AS DaysSinceReg
FROM Appointment a JOIN Patient p ON p.PatientID=a.PatientID;

-- Task 2: trends
SELECT YEAR(AppointmentDate) Yr, MONTH(AppointmentDate) Mth, COUNT(*) Appointments
FROM Appointment GROUP BY YEAR(AppointmentDate), MONTH(AppointmentDate) ORDER BY Yr, Mth;
SELECT YEAR(AppointmentDate) Yr, DATEPART(QUARTER,AppointmentDate) Qtr, COUNT(*) Appointments
FROM Appointment GROUP BY YEAR(AppointmentDate), DATEPART(QUARTER,AppointmentDate) ORDER BY Yr, Qtr;
SELECT YEAR(AppointmentDate) Yr, COUNT(*) Appointments FROM Appointment GROUP BY YEAR(AppointmentDate);
SELECT DATEADD(DAY,7,GETDATE()) AS NextWeek;

-- Task 3: string functions
SELECT UPPER(PatientName) AS UpperName, LOWER(City) AS LowerCity, LEN(PatientName) AS NameLen,
  LEFT(PatientName, CHARINDEX(' ',PatientName+' ')-1) AS FirstName,
  LTRIM(SUBSTRING(PatientName, CHARINDEX(' ',PatientName+' '), 50)) AS LastName,
  CONCAT(PatientName,' (',City,')') AS Label
FROM Patient;
SELECT REPLACE(DoctorName,'Dr. ','') AS DoctorShort, CONCAT(DoctorName,' - ',Specialization) AS DoctorInfo FROM Doctor;
SELECT dp.DeptName, STRING_AGG(d.DoctorName, ', ') AS Doctors FROM Department dp JOIN Doctor d ON d.DeptID=dp.DeptID GROUP BY dp.DeptName;

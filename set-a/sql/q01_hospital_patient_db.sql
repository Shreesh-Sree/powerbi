-- Q1 Hospital Patient Management Database (SQL Server)
CREATE DATABASE HospitalDB; GO
USE HospitalDB; GO

CREATE TABLE Department (
  DeptID INT IDENTITY(1,1) PRIMARY KEY,
  DeptName VARCHAR(60) NOT NULL UNIQUE,
  Floor INT NOT NULL DEFAULT 1 CHECK (Floor BETWEEN 0 AND 20)
);
CREATE TABLE Doctor (
  DoctorID INT IDENTITY(1,1) PRIMARY KEY,
  DoctorName VARCHAR(80) NOT NULL,
  Specialization VARCHAR(60) NOT NULL,
  Phone VARCHAR(15) UNIQUE,
  DeptID INT NOT NULL REFERENCES Department(DeptID)
);
CREATE TABLE Patient (
  PatientID INT IDENTITY(1,1) PRIMARY KEY,
  PatientName VARCHAR(80) NOT NULL,
  Gender CHAR(1) NOT NULL CHECK (Gender IN ('M','F','O')),
  DOB DATE NOT NULL CHECK (DOB <= GETDATE()),
  Phone VARCHAR(15) UNIQUE,
  City VARCHAR(50),
  RegDate DATE NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Appointment (
  AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
  PatientID INT NOT NULL REFERENCES Patient(PatientID),
  DoctorID INT NOT NULL REFERENCES Doctor(DoctorID),
  AppointmentDate DATE NOT NULL,
  Status VARCHAR(15) NOT NULL DEFAULT 'Scheduled'
    CHECK (Status IN ('Scheduled','Completed','Cancelled'))
);
CREATE TABLE Billing (
  BillID INT IDENTITY(1,1) PRIMARY KEY,
  AppointmentID INT NOT NULL UNIQUE REFERENCES Appointment(AppointmentID),
  Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
  PaymentStatus VARCHAR(10) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending','Paid')),
  BillDate DATE NOT NULL DEFAULT GETDATE()
);

-- Sample data
INSERT Department(DeptName,Floor) VALUES ('Cardiology',2),('Orthopedics',1),('Neurology',3),('Pediatrics',1);
INSERT Doctor VALUES ('Dr. Anand','Cardiologist','9000000001',1),('Dr. Meera','Orthopedic Surgeon','9000000002',2),
 ('Dr. Ravi','Neurologist','9000000003',3),('Dr. Sneha','Pediatrician','9000000004',4);
INSERT Patient(PatientName,Gender,DOB,Phone,City,RegDate) VALUES
 ('Arjun Kumar','M','1985-04-12','8000000001','Chennai','2025-01-10'),
 ('Priya Sharma','F','1992-09-30','8000000002','Madurai','2025-02-14'),
 ('Karthik Raj','M','1978-12-01','8000000003','Chennai','2025-03-03'),
 ('Anitha Devi','F','2015-06-21','8000000004','Coimbatore','2025-03-20'),
 ('Suresh Babu','M','1960-01-15','8000000005','Salem','2025-04-05');
INSERT Appointment(PatientID,DoctorID,AppointmentDate,Status) VALUES
 (1,1,'2025-01-15','Completed'),(2,2,'2025-02-20','Completed'),(3,3,'2025-03-10','Completed'),
 (4,4,'2025-04-01','Completed'),(5,1,'2025-04-12','Scheduled'),(1,3,'2025-05-02','Cancelled');
INSERT Billing(AppointmentID,Amount,PaymentStatus) VALUES (1,1500,'Paid'),(2,3200,'Paid'),(3,2800,'Pending'),(4,600,'Paid');

-- Task 2: retrieval queries
SELECT * FROM Patient WHERE PatientName LIKE 'A%';
SELECT DISTINCT City FROM Patient ORDER BY City;
SELECT * FROM Patient WHERE City IN ('Chennai','Madurai');
SELECT * FROM Appointment WHERE AppointmentDate BETWEEN '2025-02-01' AND '2025-04-30' ORDER BY AppointmentDate;
SELECT p.PatientName, d.DoctorName, a.AppointmentDate, a.Status
FROM Appointment a JOIN Patient p ON p.PatientID=a.PatientID JOIN Doctor d ON d.DoctorID=a.DoctorID
WHERE a.Status = 'Completed' ORDER BY a.AppointmentDate DESC;

-- Task 3: aggregates
SELECT SUM(Amount) AS TotalBilling, AVG(Amount) AS AvgBilling,
       MIN(Amount) AS MinBilling, MAX(Amount) AS MaxBilling FROM Billing;
SELECT dp.DeptName, COUNT(DISTINCT a.PatientID) AS Patients, SUM(b.Amount) AS Revenue
FROM Billing b JOIN Appointment a ON a.AppointmentID=b.AppointmentID
JOIN Doctor d ON d.DoctorID=a.DoctorID JOIN Department dp ON dp.DeptID=d.DeptID
GROUP BY dp.DeptName HAVING SUM(b.Amount) > 1000 ORDER BY Revenue DESC;
SELECT City, COUNT(*) AS PatientCount FROM Patient GROUP BY City HAVING COUNT(*) >= 1;

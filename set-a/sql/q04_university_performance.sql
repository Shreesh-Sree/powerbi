-- Q4 University Course Performance
CREATE DATABASE UniversityDB; GO
USE UniversityDB; GO
CREATE TABLE Faculty (FacultyID INT PRIMARY KEY, FacultyName VARCHAR(80) NOT NULL);
CREATE TABLE Student (StudentID INT PRIMARY KEY, StudentName VARCHAR(80) NOT NULL, Dept VARCHAR(30) NOT NULL);
CREATE TABLE Course (CourseID INT PRIMARY KEY, CourseName VARCHAR(60) NOT NULL UNIQUE, FacultyID INT REFERENCES Faculty(FacultyID), Credits INT DEFAULT 3 CHECK (Credits BETWEEN 1 AND 6));
CREATE TABLE Enrollment (EnrollID INT PRIMARY KEY, StudentID INT REFERENCES Student(StudentID), CourseID INT REFERENCES Course(CourseID), Semester INT NOT NULL, UNIQUE(StudentID,CourseID,Semester));
CREATE TABLE Examination (ExamID INT PRIMARY KEY, EnrollID INT REFERENCES Enrollment(EnrollID), Marks INT CHECK (Marks BETWEEN 0 AND 100));
INSERT Faculty VALUES (1,'Dr. Rao'),(2,'Dr. Lakshmi');
INSERT Student VALUES (1,'Arjun','CSE'),(2,'Priya','CSE'),(3,'Karthik','AIML'),(4,'Divya','AIML');
INSERT Course VALUES (10,'DBMS',1,4),(20,'Machine Learning',2,4);
INSERT Enrollment VALUES (1,1,10,1),(2,2,10,1),(3,3,10,1),(4,4,10,1),(5,1,20,2),(6,2,20,2),(7,3,20,2),(8,4,20,2);
INSERT Examination VALUES (1,1,78),(2,2,91),(3,3,85),(4,4,91),(5,5,82),(6,6,88),(7,7,70),(8,8,95);

-- Task 2: set operators
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=10 AND x.Marks>=80
UNION
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=20 AND x.Marks>=80;   -- scored 80+ in either
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=10 AND x.Marks>=80
INTERSECT
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE e.CourseID=20 AND x.Marks>=80;   -- both
SELECT StudentName FROM Student
EXCEPT
SELECT s.StudentName FROM Student s JOIN Enrollment e ON e.StudentID=s.StudentID JOIN Examination x ON x.EnrollID=e.EnrollID WHERE x.Marks<75;                      -- never below 75
-- UNION ALL keeps duplicates; UNION removes them.

-- Task 3: window functions
WITH M AS (
  SELECT s.StudentName, c.CourseName, e.Semester, x.Marks
  FROM Examination x JOIN Enrollment e ON e.EnrollID=x.EnrollID
  JOIN Student s ON s.StudentID=e.StudentID JOIN Course c ON c.CourseID=e.CourseID)
SELECT StudentName, CourseName, Semester, Marks,
  ROW_NUMBER() OVER (PARTITION BY CourseName ORDER BY Marks DESC) AS RowNo,
  RANK()       OVER (PARTITION BY CourseName ORDER BY Marks DESC) AS Rnk,
  DENSE_RANK() OVER (PARTITION BY CourseName ORDER BY Marks DESC) AS DenseRnk,
  LAG(Marks)   OVER (PARTITION BY StudentName ORDER BY Semester)  AS PrevMarks,
  LEAD(Marks)  OVER (PARTITION BY StudentName ORDER BY Semester)  AS NextMarks,
  Marks - LAG(Marks) OVER (PARTITION BY StudentName ORDER BY Semester) AS Trend
FROM M ORDER BY CourseName, Rnk;

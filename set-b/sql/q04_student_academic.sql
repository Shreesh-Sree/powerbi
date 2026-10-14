-- Q4 Student Academic Database
CREATE DATABASE CollegeDB; GO
USE CollegeDB; GO
CREATE TABLE Student (StudentID INT PRIMARY KEY, StudentName VARCHAR(80) NOT NULL, Dept VARCHAR(30) NOT NULL);
CREATE TABLE Course (CourseID INT PRIMARY KEY, CourseName VARCHAR(60) NOT NULL UNIQUE);
CREATE TABLE Marks (MarkID INT PRIMARY KEY, StudentID INT REFERENCES Student(StudentID), CourseID INT REFERENCES Course(CourseID),
  Semester INT NOT NULL, Marks INT NOT NULL CHECK (Marks BETWEEN 0 AND 100));
INSERT Student VALUES (1,'Arjun','CSE'),(2,'Priya','CSE'),(3,'Karthik','AIML'),(4,'Divya','AIML');
INSERT Course VALUES (1,'DBMS'),(2,'ML');
INSERT Marks VALUES (1,1,1,1,78),(2,2,1,1,91),(3,3,1,1,85),(4,4,1,1,91),(5,1,2,2,82),(6,2,2,2,88),(7,3,2,2,70),(8,4,2,2,95);
SELECT StudentID FROM Marks WHERE CourseID=1 AND Marks>=80 UNION SELECT StudentID FROM Marks WHERE CourseID=2 AND Marks>=80;
SELECT StudentID FROM Marks WHERE CourseID=1 AND Marks>=80 INTERSECT SELECT StudentID FROM Marks WHERE CourseID=2 AND Marks>=80;
SELECT StudentID FROM Marks WHERE CourseID=1 EXCEPT SELECT StudentID FROM Marks WHERE Marks<75;
SELECT s.StudentName, c.CourseName, m.Semester, m.Marks,
  ROW_NUMBER() OVER (PARTITION BY m.CourseID ORDER BY m.Marks DESC) RowNo,
  RANK() OVER (PARTITION BY m.CourseID ORDER BY m.Marks DESC) Rnk,
  LAG(m.Marks) OVER (PARTITION BY m.StudentID ORDER BY m.Semester) PrevMarks,
  LEAD(m.Marks) OVER (PARTITION BY m.StudentID ORDER BY m.Semester) NextMarks
FROM Marks m JOIN Student s ON s.StudentID=m.StudentID JOIN Course c ON c.CourseID=m.CourseID;

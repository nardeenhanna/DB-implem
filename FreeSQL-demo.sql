
CREATE DATABASE Horizon_University;

CREATE TABLE Campus (
    Campus_ID SERIAL PRIMARY KEY,
    Campus_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);


-- DEPARTMENT

CREATE TABLE Department (
    Department_ID SERIAL PRIMARY KEY,
    Department_Code VARCHAR(20) NOT NULL UNIQUE,
    Department_Name VARCHAR(100) NOT NULL,
    Campus_ID INT NOT NULL,

    FOREIGN KEY (Campus_ID)
    REFERENCES Campus(Campus_ID)
);


-- FACULTY

CREATE TABLE Faculty (
    Faculty_ID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Faculty_Rank VARCHAR(50) NOT NULL,
    Department_ID INT NOT NULL,

    FOREIGN KEY (Department_ID)
    REFERENCES Department(Department_ID)
);


-- ADD HEAD OF DEPARTMENT

ALTER TABLE Department
ADD COLUMN Head_Faculty_ID INT;

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Head
FOREIGN KEY (Head_Faculty_ID)
REFERENCES Faculty(Faculty_ID);


-- PROGRAM

CREATE TABLE Program (
    Program_ID SERIAL PRIMARY KEY,
    Program_Name VARCHAR(100) NOT NULL,
    Degree_Level VARCHAR(30) NOT NULL,
    Department_ID INT NOT NULL,

    FOREIGN KEY (Department_ID)
    REFERENCES Department(Department_ID)
);


-- STUDENT

CREATE TABLE Student (
    Student_ID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Date_of_Birth DATE,
    Enrollment_Date DATE NOT NULL,
    Program_ID INT NOT NULL,
    Advisor_ID INT,

    FOREIGN KEY (Program_ID)
    REFERENCES Program(Program_ID),

    FOREIGN KEY (Advisor_ID)
    REFERENCES Faculty(Faculty_ID)
);


-- STUDENT CAMPUS HISTORY

CREATE TABLE Student_Campus_History (
    Student_ID INT NOT NULL,
    Campus_ID INT NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,

    PRIMARY KEY (Student_ID, Campus_ID, Start_Date),

    FOREIGN KEY (Student_ID)
    REFERENCES Student(Student_ID),

    FOREIGN KEY (Campus_ID)
    REFERENCES Campus(Campus_ID)
);


-- COURSE

CREATE TABLE Course (
    Course_ID SERIAL PRIMARY KEY,
    Course_Code VARCHAR(20) NOT NULL UNIQUE,
    Course_Title VARCHAR(100) NOT NULL,
    Credit_Hours INT NOT NULL CHECK (Credit_Hours > 0),
    Course_Level VARCHAR(30) NOT NULL,
    Department_ID INT NOT NULL,

    FOREIGN KEY (Department_ID)
    REFERENCES Department(Department_ID)
);


-- PROGRAM COURSE
-- MANY TO MANY RELATIONSHIP

CREATE TABLE Program_Course (
    Program_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    Required_Optional VARCHAR(20) NOT NULL,

    PRIMARY KEY (Program_ID, Course_ID),

    FOREIGN KEY (Program_ID)
    REFERENCES Program(Program_ID),

    FOREIGN KEY (Course_ID)
    REFERENCES Course(Course_ID)
);


-- PREREQUISITE
-- RECURSIVE MANY TO MANY RELATIONSHIP

CREATE TABLE Prerequisite (
    Course_ID INT NOT NULL,
    Prerequisite_Course_ID INT NOT NULL,

    PRIMARY KEY (Course_ID, Prerequisite_Course_ID),

    FOREIGN KEY (Course_ID)
    REFERENCES Course(Course_ID),

    FOREIGN KEY (Prerequisite_Course_ID)
    REFERENCES Course(Course_ID),

    CHECK (Course_ID <> Prerequisite_Course_ID)
);


-- SEMESTER

CREATE TABLE Semester (
    Semester_ID SERIAL PRIMARY KEY,
    Semester_Name VARCHAR(50) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Academic_Year VARCHAR(20) NOT NULL,

    CHECK (End_Date > Start_Date)
);


-- CLASSROOM

CREATE TABLE Classroom (
    Classroom_ID SERIAL PRIMARY KEY,
    Room_Number VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    Classroom_Type VARCHAR(50) NOT NULL,
    Campus_ID INT NOT NULL,

    FOREIGN KEY (Campus_ID)
    REFERENCES Campus(Campus_ID),

    UNIQUE (Campus_ID, Room_Number)
);


-- COURSE OFFERING

CREATE TABLE Course_Offering (
    Offering_ID SERIAL PRIMARY KEY,
    Course_ID INT NOT NULL,
    Campus_ID INT NOT NULL,
    Classroom_ID INT NOT NULL,
    Primary_Faculty_ID INT NOT NULL,
    Semester_ID INT NOT NULL,
    Day VARCHAR(20) NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,

    FOREIGN KEY (Course_ID)
    REFERENCES Course(Course_ID),

    FOREIGN KEY (Campus_ID)
    REFERENCES Campus(Campus_ID),

    FOREIGN KEY (Classroom_ID)
    REFERENCES Classroom(Classroom_ID),

    FOREIGN KEY (Primary_Faculty_ID)
    REFERENCES Faculty(Faculty_ID),

    FOREIGN KEY (Semester_ID)
    REFERENCES Semester(Semester_ID),

    CHECK (End_Time > Start_Time)
);


-- TEACHING ASSISTANT
-- MANY TO MANY RELATIONSHIP

CREATE TABLE Teaching_Assistant (
    Offering_ID INT NOT NULL,
    Faculty_ID INT NOT NULL,

    PRIMARY KEY (Offering_ID, Faculty_ID),

    FOREIGN KEY (Offering_ID)
    REFERENCES Course_Offering(Offering_ID),

    FOREIGN KEY (Faculty_ID)
    REFERENCES Faculty(Faculty_ID)
);


-- ENROLLMENT
-- MANY TO MANY RELATIONSHIP

CREATE TABLE Enrollment (
    Student_ID INT NOT NULL,
    Offering_ID INT NOT NULL,
    Enrollment_Status VARCHAR(20) NOT NULL,
    Final_Grade VARCHAR(5),
    Grade_Recorded_Date DATE,

    PRIMARY KEY (Student_ID, Offering_ID),

    FOREIGN KEY (Student_ID)
    REFERENCES Student(Student_ID),

    FOREIGN KEY (Offering_ID)
    REFERENCES Course_Offering(Offering_ID)
);



-- ============================================
-- 3. INSERT DATA
-- ============================================


-- INSERT CAMPUSES

INSERT INTO Campus (Campus_Name, Location)
VALUES
('Main Campus', 'Cairo'),
('North Campus', 'Alexandria'),
('East Campus', 'Nasr City');


-- INSERT DEPARTMENTS

INSERT INTO Department
(Department_Code, Department_Name, Campus_ID)
VALUES
('CS', 'Computer Science', 1),
('IT', 'Information Technology', 2),
('DS', 'Data Science', 3);


-- INSERT FACULTY

INSERT INTO Faculty
(First_Name, Last_Name, Email, Faculty_Rank, Department_ID)
VALUES
('Ahmed', 'Hassan', 'ahmed.hassan@horizon.edu', 'Professor', 1),
('Sara', 'Mohamed', 'sara.mohamed@horizon.edu', 'Associate Professor', 1),
('Omar', 'Ali', 'omar.ali@horizon.edu', 'Lecturer', 2),
('Mona', 'Samy', 'mona.samy@horizon.edu', 'Assistant Professor', 3);


-- UPDATE DEPARTMENT HEADS

UPDATE Department
SET Head_Faculty_ID = 1
WHERE Department_ID = 1;

UPDATE Department
SET Head_Faculty_ID = 3
WHERE Department_ID = 2;

UPDATE Department
SET Head_Faculty_ID = 4
WHERE Department_ID = 3;


-- INSERT PROGRAMS

INSERT INTO Program
(Program_Name, Degree_Level, Department_ID)
VALUES
('BSc Computer Science', 'Undergraduate', 1),
('BSc Information Technology', 'Undergraduate', 2),
('MSc Data Science', 'Postgraduate', 3);


-- INSERT STUDENTS

INSERT INTO Student
(First_Name, Last_Name, Email, Date_of_Birth,
Enrollment_Date, Program_ID, Advisor_ID)
VALUES
('Merna', 'Raoof', 'merna@example.com',
'2005-05-10', '2024-09-01', 1, 1),

('Nour', 'Ahmed', 'nour@example.com',
'2004-03-15', '2023-09-01', 1, 2),

('Youssef', 'Ali', 'youssef@example.com',
'2003-07-20', '2022-09-01', 2, 3),

('Salma', 'Hassan', 'salma@example.com',
'2002-01-25', '2025-02-01', 3, 4);


-- INSERT STUDENT CAMPUS HISTORY

INSERT INTO Student_Campus_History
(Student_ID, Campus_ID, Start_Date, End_Date)
VALUES
(1, 1, '2024-09-01', NULL),
(2, 1, '2023-09-01', NULL),
(3, 2, '2022-09-01', NULL),
(4, 3, '2025-02-01', NULL);


-- INSERT COURSES

INSERT INTO Course
(Course_Code, Course_Title, Credit_Hours,
Course_Level, Department_ID)
VALUES
('CS101', 'Introduction to Programming', 3,
'Undergraduate', 1),

('CS201', 'Database Systems', 3,
'Undergraduate', 1),

('CS301', 'Data Structures', 3,
'Undergraduate', 1),

('IT101', 'Computer Networks', 3,
'Undergraduate', 2),

('DS501', 'Machine Learning', 3,
'Postgraduate', 3);


-- INSERT PROGRAM COURSES

INSERT INTO Program_Course
(Program_ID, Course_ID, Required_Optional)
VALUES
(1, 1, 'Required'),
(1, 2, 'Required'),
(1, 3, 'Required'),
(2, 4, 'Required'),
(3, 5, 'Required');


-- INSERT PREREQUISITES

INSERT INTO Prerequisite
(Course_ID, Prerequisite_Course_ID)
VALUES
(2, 1),
(3, 1);


-- INSERT SEMESTERS

INSERT INTO Semester
(Semester_Name, Start_Date, End_Date, Academic_Year)
VALUES
('Fall', '2025-09-01', '2026-01-15', '2025/2026'),

('Spring', '2026-02-01', '2026-06-15', '2025/2026');


-- INSERT CLASSROOMS

INSERT INTO Classroom
(Room_Number, Capacity, Classroom_Type, Campus_ID)
VALUES
('A101', 100, 'Lecture Hall', 1),
('Lab201', 30, 'Lab', 1),
('B101', 80, 'Lecture Hall', 2),
('C301', 50, 'Seminar Room', 3);


-- INSERT COURSE OFFERINGS

INSERT INTO Course_Offering
(Course_ID, Campus_ID, Classroom_ID,
Primary_Faculty_ID, Semester_ID,
Day, Start_Time, End_Time)
VALUES
(1, 1, 1, 1, 1,
'Sunday', '09:00', '11:00'),

(2, 1, 2, 2, 1,
'Monday', '10:00', '12:00'),

(3, 1, 1, 1, 2,
'Tuesday', '09:00', '11:00'),

(4, 2, 3, 3, 1,
'Wednesday', '11:00', '13:00'),

(5, 3, 4, 4, 2,
'Thursday', '10:00', '12:00');


-- INSERT TEACHING ASSISTANTS

INSERT INTO Teaching_Assistant
(Offering_ID, Faculty_ID)
VALUES
(1, 2),
(2, 1),
(4, 3);


-- INSERT ENROLLMENTS

INSERT INTO Enrollment
(Student_ID, Offering_ID,
Enrollment_Status, Final_Grade,
Grade_Recorded_Date)
VALUES
(1, 1, 'Completed', 'A', '2026-01-20'),

(1, 2, 'Enrolled', NULL, NULL),

(2, 1, 'Completed', 'B+', '2026-01-20'),

(2, 3, 'Enrolled', NULL, NULL),

(3, 4, 'Completed', 'A-', '2026-01-20'),

(4, 5, 'Enrolled', NULL, NULL);


SELECT * FROM Campus;

SELECT * FROM Student;


SELECT *
FROM Student
WHERE Program_ID = 1;


SELECT Course_Title, Credit_Hours
FROM Course
WHERE Credit_Hours = 3;



SELECT
    s.First_Name,
    s.Last_Name,
    p.Program_Name
FROM Student s

JOIN Program p
ON s.Program_ID = p.Program_ID;


SELECT
    s.First_Name,
    s.Last_Name,
    p.Program_Name,
    d.Department_Name

FROM Student s

JOIN Program p
ON s.Program_ID = p.Program_ID

JOIN Department d
ON p.Department_ID = d.Department_ID;

SELECT
    f.First_Name,
    f.Last_Name,
    f.Faculty_Rank,
    d.Department_Name

FROM Faculty f

JOIN Department d
ON f.Department_ID = d.Department_ID;


SELECT
    c.Course_Code,
    c.Course_Title,
    d.Department_Name

FROM Course c

JOIN Department d
ON c.Department_ID = d.Department_ID;


SELECT
    s.First_Name,
    s.Last_Name,
    c.Course_Title,
    e.Enrollment_Status

FROM Enrollment e

JOIN Student s
ON e.Student_ID = s.Student_ID

JOIN Course_Offering co
ON e.Offering_ID = co.Offering_ID

JOIN Course c
ON co.Course_ID = c.Course_ID;


SELECT
    c.Course_Title,
    ca.Campus_Name,
    cl.Room_Number,

    f.First_Name || ' ' ||
    f.Last_Name AS Professor,

    se.Semester_Name,
    co.Day,
    co.Start_Time,
    co.End_Time

FROM Course_Offering co

JOIN Course c
ON co.Course_ID = c.Course_ID

JOIN Campus ca
ON co.Campus_ID = ca.Campus_ID

JOIN Classroom cl
ON co.Classroom_ID = cl.Classroom_ID

JOIN Faculty f
ON co.Primary_Faculty_ID = f.Faculty_ID

JOIN Semester se
ON co.Semester_ID = se.Semester_ID;


SELECT
    s.First_Name,
    s.Last_Name,
    e.Enrollment_Status

FROM Student s

LEFT JOIN Enrollment e
ON s.Student_ID = e.Student_ID;


SELECT
    p.Program_Name,
    COUNT(s.Student_ID) AS Number_Of_Students

FROM Program p

LEFT JOIN Student s
ON p.Program_ID = s.Program_ID

GROUP BY p.Program_Name;


SELECT
    d.Department_Name,
    AVG(c.Credit_Hours) AS Average_Credit_Hours

FROM Department d

JOIN Course c
ON d.Department_ID = c.Department_ID

GROUP BY d.Department_Name;


SELECT *
FROM Student
ORDER BY First_Name ASC;


UPDATE Enrollment
SET
    Enrollment_Status = 'Completed',
    Final_Grade = 'A',
    Grade_Recorded_Date = '2026-06-20'

WHERE Student_ID = 1
AND Offering_ID = 2;

DELETE FROM Enrollment
WHERE Student_ID = 4
AND Offering_ID = 5;

SELECT
    d.Department_Name,
    COUNT(s.Student_ID) AS Number_Of_Students

FROM Department d

JOIN Program p
ON d.Department_ID = p.Department_ID

LEFT JOIN Student s
ON p.Program_ID = s.Program_ID

GROUP BY d.Department_Name;



-- SHOW STUDENT AND ADVISOR

SELECT
    s.First_Name || ' ' ||
    s.Last_Name AS Student_Name,

    f.First_Name || ' ' ||
    f.Last_Name AS Advisor_Name

FROM Student s

LEFT JOIN Faculty f
ON s.Advisor_ID = f.Faculty_ID;



-- SHOW COURSE PREREQUISITES

SELECT
    c.Course_Title AS Course,
    p.Course_Title AS Prerequisite

FROM Prerequisite pr

JOIN Course c
ON pr.Course_ID = c.Course_ID

JOIN Course p
ON pr.Prerequisite_Course_ID = p.Course_ID;



-- SHOW TEACHING ASSISTANTS

SELECT
    c.Course_Title,

    f.First_Name || ' ' ||
    f.Last_Name AS Teaching_Assistant

FROM Teaching_Assistant ta

JOIN Course_Offering co
ON ta.Offering_ID = co.Offering_ID

JOIN Course c
ON co.Course_ID = c.Course_ID

JOIN Faculty f
ON ta.Faculty_ID = f.Faculty_ID;


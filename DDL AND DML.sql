
--Creating Table 'Student'
CREATE TABLE "Student" (
	"Student_id"	INTEGER,
	"Student_name"	TEXT NOT NULL,
	"Department"	TEXT NOT NULL CHECK(Department IN ('ECE','CSE','AERO','AUTO','MECH')),
	"Phone"	INTEGER NOT NULL UNIQUE,
	"Email"	TEXT NOT NULL UNIQUE,
	"Password"	TEXT NOT NULL,
	"Fine_amount"	NUMERIC DEFAULT 0,
	PRIMARY KEY("Student_id")
);
DROP TABLE Student;
--Creating Table 'Admin'
CREATE TABLE "Admin" (
	"Staff_id"	INTEGER,
	"Staff_name"	TEXT NOT NULL,
	"Phone"	INTEGER NOT NULL UNIQUE,
	"Email"	TEXT NOT NULL UNIQUE,
	"Password"	TEXT NOT NULL,
	PRIMARY KEY("Staff_id")
);
DROP TABLE Admin;
--Creating Table 'Author'
CREATE TABLE "Author" (
	"Author_id"	INTEGER,
	"Author_name"	TEXT NOT NULL,
	PRIMARY KEY("Author_id" AUTOINCREMENT)
);
ALTER TABLE Author AUTO_INCREMENT=4000;
Drop TABLE Author;
--Creating Table 'Books'
CREATE TABLE "Books" (
	"Book_id"	INTEGER,
	"Title"	TEXT NOT NULL,
	"Department"	TEXT NOT NULL CHECK(Department IN('ECE','CSE','MECH','AERO','AUTO')),
	"Author_id"	INTEGER,
	"Publisher"	TEXT,
	"Year"	INTEGER,
	"Availability"	INTEGER NOT NULL,
	PRIMARY KEY("Book_id" AUTOINCREMENT),
	FOREIGN KEY("Author_id") REFERENCES Author(Author_id) ON UPDATE SET NULL ON DELETE SET NULL	
);
DROP TABLE Books;

--Creating Table 'Orders'
CREATE TABLE "Orders" (
	"Student_id"	INTEGER,
	"Book_id"	INTEGER,
	"Issue_date"  TEXT NOT NULL DEFAULT CURRENT_DATE, 
	"Return_date"	TEXT DEFAULT 'Not Returned',
	PRIMARY KEY("Student_id","Book_id"),
	FOREIGN KEY("Book_id") REFERENCES "Books"("Book_id"),
	FOREIGN KEY("Student_id") REFERENCES "Student"("Student_id")
);
DROP TABLE Orders;
--Inserting data into Student Table
INSERT INTO Student(Student_id,Student_name,Department,Phone,Email,Password) VALUES(1001,"Saravanan","CSE",9876543210,"vss@gmail.com","Saro98765");
INSERT INTO Student(Student_id,Student_name,Department,Phone,Email,Password) VALUES(1002,"Keerthivasan","ECE",9894406788,"r.s.keerthivasan18@gmail.com","Keer1234");
INSERT INTO Student(Student_id,Student_name,Department,Phone,Email,Password) VALUES(1003,"Veeman","AUTO",9812345512,"veeman@gmail.com","veeman4321");
INSERT INTO Student(Student_id,Student_name,Department,Phone,Email,Password) VALUES(1004,"Comic","AERO",9157389237,"comic@gmail.com","com123");
INSERT INTO Student(Student_id,Student_name,Department,Phone,Email,Password) VALUES(1005,"Adi","MECH",9852516363,"adi@gmail.com","1234adi");


--Inserting data into Admin Table 
INSERT INTO Admin(Staff_id,Staff_name,Phone,Email,Password) VALUES (2001,"MalaJohn",123456789,"mj@gmail.com","MJss");
INSERT INTO Admin(Staff_id,Staff_name,Phone,Email,Password) VALUES (2002, "Keerthivasan", 9486981229, "r.s.keerthivasan18@gmail.com", "Keerthi989");

--Inserting data into Author TABLE
INSERT INTO Author (Author_id,"Author_name") VALUES (4001,'Kermode A.C');
INSERT INTO Author ("Author_name") VALUES ('Rathakrishnan E');
INSERT INTO Author ("Author_name") VALUES ('Bansal R.K');
INSERT INTO Author ("Author_name") VALUES ('Timoshenko');
INSERT INTO Author ("Author_name") VALUES ('Raghavan V');
INSERT INTO Author ("Author_name") VALUES ('Robert N Brady');
INSERT INTO Author ("Author_name") VALUES ('Heldt.P.M');
INSERT INTO Author ("Author_name") VALUES ('K. K. Ramalingm');
INSERT INTO Author ("Author_name") VALUES ('James E Duffy');
INSERT INTO Author ("Author_name") VALUES ('Rattan S.S');
INSERT INTO Author ("Author_name") VALUES ('Bhandari V');
INSERT INTO Author ("Author_name") VALUES ('James A. Sullivan');
INSERT INTO Author ("Author_name") VALUES ('Bolton W');
INSERT INTO Author ("Author_name") VALUES ('Holman J.P');
INSERT INTO Author ("Author_name") VALUES ('Donald A Neamen');
INSERT INTO Author ("Author_name") VALUES ('Deitel and Deitel');
INSERT INTO Author ("Author_name") VALUES ('M. Morris Mano');
INSERT INTO Author ("Author_name") VALUES ('B. P. Lathi');
INSERT INTO Author ("Author_name") VALUES ('William Stallings');
INSERT INTO Author ("Author_name") VALUES (' Ian Sommerville');

--Inserting data into Books Table
INSERT INTO Books (Book_id,"Title", "Department","Author_id", "Publisher", "Year", "Availability") VALUES (3001,'Flight without Formulae', 'AERO', 4001, 'Pearson Education', '2011', '5');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Fundamentals of Engineering Thermodynamics', 'AERO', 4002, 'Prentice Hall India', '2005', '3');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Fluid Mechanics and Hydraulics Machines', 'AERO', '4003', 'Laxmi Publications (P) Ltd', '2015', '5');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Elements of strength of Materials', 'AERO', '4004', 'Van Nostrand
Reinhold Company', '1968', '4');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Physical Metallurgy', 'AERO', '4005', 'Phi Learning', '2009', '8');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Automotive computers and Digital Instrumentation', 'AUTO', '4006', 'A Reston Book,
Prentice Hill, Eagle Wood Cliffs', '1988', '3');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('High Speed Combustion Engines', 'AUTO', '4007', 'Oxford IBH Publishing Co', '1975', '5');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Internal Combustion Engines', 'AUTO', '4008', 'Scitech publications', '2003', '10');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Body Repair Technology for 4-Wheelers', 'AUTO', '4009', 'Cengage Learning', '2009', '15');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Computer Simulation of spark ignition engine process', 'AUTO', '4008', 'Tata McGraw Hill Publishing Co', '1994', '20');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Theory of Machines', 'MECH', '4010', 'Tata McGraw-Hil', '2009', '18');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Design of Machine Elements', 'MECH', '4011', 'Tata McGraw-Hill Book Co', '2014', '15');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Fluid Power Theory and Applications', 'MECH', '4012', 'Prentice Hall', '1997', '13');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Mechatronics', 'MECH', '4013', 'Pearson Education', '2011', '30');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Thermodynamics', 'MECH', '4014', 'McGraw Hill', '1985', '5');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Heat and Mass Transfe', 'MECH', '4014', 'Tata McGraw Hill', '2010', '18');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Semiconductor Physics and Devices', 'ECE', '4015', 'Tata Mc Graw Hill
 Inc', '2007', '27');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Electronic Circuit Analysis and Design', 'ECE', '4015', 'Tata McGraw Hill', '2010', '14');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('C++, How To Program', 'ECE', '4016', 'Pearson Education', '2005', '45');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Digital Design', 'ECE', '4017', 'Pearson', '2013', '40');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Principles of Linear Systems and Signals', 'ECE', '4018', 'Oxford', '2009', '24');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('ComputerOrganization andArchitecture – Designing for
Performance', 'CSE', '4019', 'Pearson Education', '2003', '35');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Operating Systems: Internals and Design Principles', 'CSE', '4019', 'Prentice Hall', '2011', '44');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Software Engineering', 'CSE', '4020', 'Pearson Education', '2008', '22');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Data and Computer Communications', 'CSE', '4019', 'Pearson Education', '2011', '48');
INSERT INTO Books ("Title", "Department", "Author_id","Publisher", "Year", "Availability") VALUES ('Mobile Design and Development', 'CSE', '4020', 'O’Reily', '2009', '39');

--Inserting data into Orders TABLE
INSERT INTO Orders(Student_id,Book_id) VALUES(1001,3001);
INSERT INTO Orders(Student_id,Book_id) VALUES(1001,3005);

SELECT S.Student_id,S.Student_name,B.Book_id,B.Title,O.Issue_date 
FROM ((Orders O INNER JOIN Student S ON O.Student_id=S.Student_id)
INNER JOIN Books B ON O.Book_id=B.Book_id) WHERE O.Return_date='Not Returned'
UPDATE Orders SET Return_date=date('now') WHERE Student_id=1001 AND Book_id=3001;
SELECT Issue_date,date(Issue_date,'+14 day') as Due_Date FROM Orders;
UPDATE Student SET Fine_amount=Fine_amount+
(CAST((julianday('now','+4 day')-julianday(
(SELECT Issue_date FROM Orders WHERE Student_id=1001 AND Book_id=3001)))as INTEGER)*1.5)
 WHERE Student_id=1002;

SELECT B.Title,A.Author_name,B.Publisher,B.Year,B.Availability FROM Books B,Author A WHERE B.Department='ECE' AND B.Author_id==A.Author_id;

SELECT S.Student_id,S.Student_name,B.Book_id,B.Title,O.Issue_date,
        date(O.Issue_date,'+14 day') as Due_Date FROM ((Orders O INNER JOIN Student S ON O.Student_id=S.Student_id)
        INNER JOIN Books B ON O.Book_id=B.Book_id) WHERE S.Student_id=1001 and O.Return_date='Not Returned';
SELECT * FROM Admin WHERE Staff_id=2003







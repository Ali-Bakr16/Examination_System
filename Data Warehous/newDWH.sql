create database DWH_ITI


create TABLE DimStudent
(
	Student_SK INT IDENTITY(1,1),
	Student_BK CHAR(14),
	StudentFullName VARCHAR(200),
	StudentDOB DATE,
	Gender CHAR(1),
	Faculty VARCHAR(50),
	StudentAddress VARCHAR(20),
	EndDate DATE,
	StartDate DATE DEFAULT(GETDATE()) NOT NULL,
	Is_Current TINYINT,
	SSC TINYINT

	CONSTRAINT DimStudent_PK PRIMARY KEY(Student_SK)
)




CREATE TABLE DimCourse
(
	Course_SK INT IDENTITY(1,1),
	Course_BK INT,
	Course_Name VARCHAR(100),
	EndDate DATE,
	StartDate DATE DEFAULT(GETDATE()) NOT NULL,
	Is_Current TINYINT,
	SSC TINYINT

	CONSTRAINT DimCourse_PK PRIMARY KEY(Course_SK)

)



CREATE TABLE Dim_Branch
(
	Branch_SK INT identity(1,1),
	Branch_ID INT,
	Branch_Name VARCHAR(100),
	Branch_Address VARCHAR(255),
	EndDate Date,
	StartDate DATE DEFAULT(GETDATE()) NOT NULL,
	Is_Current TINYINT,
	SSC TINYINT

	CONSTRAINT DimBranch_PK PRIMARY KEY(Branch_SK)
)





CREATE TABLE Dim_Certification (
   CertificationKey INT IDENTITY(1,1) PRIMARY KEY,
   CertificationID INT,
   Certification_Name NVARCHAR(200),
   Certification_Source NVARCHAR(200),
   Certification_Field NVARCHAR(200),
   Ssc TINYINT NOT NULL,
   Start_Date DATETIME NOT NULL DEFAULT (GETDATE()),
   End_Date DATETIME,
   Is_Current TINYINT NOT NULL DEFAULT(1)
);


CREATE TABLE Dim_Company (
   CompanyKey INT IDENTITY(1,1) PRIMARY KEY,
   CompanyID INT,
   Company_Name nvarchar(220),
   Company_lication nvarchar(220),
   Company_ffeild nvarchar(220),
   Ssc TINYINT NOT NULL,
   Start_Date DATETIME NOT NULL DEFAULT (GETDATE()),
   End_Date DATETIME,
   Is_Current TINYINT NOT NULL DEFAULT(1)
);

alter table Dim_Company
add Company_Type varchar(50)



CREATE TABLE Dim_JOB (
   JOBKey INT IDENTITY(1,1) PRIMARY KEY,
   JOBID INT,
   Job_Website nvarchar(100),
   Job_category nvarchar(100),
   Ssc TINYINT NOT NULL,
   Start_Date DATETIME NOT NULL DEFAULT (GETDATE()),
   End_Date DATETIME,
   Is_Current TINYINT NOT NULL DEFAULT(1)
);


CREATE TABLE Dim_Intake (
   IntakeKey INT IDENTITY(1,1) PRIMARY KEY,
   IntakeID INT,
   Intake_Name VARCHAR(60),
   Ssc TINYINT NOT NULL,
   Start_Date DATETIME NOT NULL DEFAULT (GETDATE()),
   End_Date DATETIME,
   Is_Current TINYINT NOT NULL DEFAULT(1)
);

CREATE TABLE Dim_Track (
   TrackKey INT IDENTITY(1,1) PRIMARY KEY,
   TrackID INT,
   TrackName VARCHAR(120),
   Ssc TINYINT NOT NULL,
   Start_Date DATETIME NOT NULL DEFAULT (GETDATE()),
   End_Date DATETIME,
   Is_Current TINYINT NOT NULL DEFAULT(1)
);


create TABLE Dim_Instructor (
  InstructorKey INT IDENTITY(1,1) PRIMARY KEY,
  InstructorID CHAR(14),
  Instructor_FullName VARCHAR(50),
  Gender VARCHAR(10),
  Status VARCHAR(20),
  Ssc TINYINT NOT NULL,
  Start_Date DATETIME NOT NULL DEFAULT(GETDATE()),
  End_Date DATETIME,
  Is_Current TINYINT NOT NULL DEFAULT(1)
);




CREATE TABLE DimDate
  (
     DateKey            INT NOT NULL,
     Full_Date           DATE NOT NULL,
     calendar_year       INT NOT NULL,
     calendar_quarter    INT NOT NULL,
     calendar_month_num  INT NOT NULL,
     calendar_month_name NVARCHAR(15) NOT NULL
     CONSTRAINT pk_dim_date PRIMARY KEY CLUSTERED (DateKey)
  );

create table DimExam
(
	Exam_SK int identity(1,1) primary key,
	Exam_BK int,
	Exam_Type varchar(50),
	Ssc TINYINT NOT NULL,
    Start_Date DATETIME NOT NULL DEFAULT(GETDATE()),
    End_Date DATETIME,
    Is_Current TINYINT NOT NULL DEFAULT(1)

)





create TABLE ITI_Fact_Student(
	[FactKey] [int] IDENTITY(1,1) NOT NULL,
	student_ID Char(14),
	certificationID int,
	[Student_Age] [int] NULL,
	job_ID int,
	companyID int,
	[Job_Cost] [float] NULL,
	[Job_Feedback] [float] NULL,
	[Student_Salary] [float] NULL,
	[ExamID] [int] NULL,
	[Grade_Course] [float] NULL,
	CertificationHours INT,
	[StudentKey] [int]  NULL, ---student
	[DateKey] [int]  NULL, ----date
	CertificationKey int  null , ---certification
	JobKey int  null, ---job
	CompanyKey int  null ---company


	CONSTRAINT [pk_ITI_fact] PRIMARY KEY(FactKey)
	
	CONSTRAINT DimStudent_FK FOREIGN KEY(StudentKey) REFERENCES DimStudent(Student_SK),
	CONSTRAINT DimCertification_FK FOREIGN KEY(CertificationKey) REFERENCES Dim_Certification(CertificationKey),
	CONSTRAINT DimJob_FK FOREIGN KEY(JobKey) REFERENCES Dim_Job(JobKey),
	CONSTRAINT DimCompany_FK FOREIGN KEY(CompanyKey) REFERENCES Dim_Company(CompanyKey),
	CONSTRAINT DimDate_FK FOREIGN KEY(DateKey) REFERENCES DimDate(DateKey)
)









create TABLE ITI_Fact(
	[FactKey] [int] IDENTITY(1,1) NOT NULL,
	[Student_Age] [int] NULL,
	[Job_Cost] [float] NULL,
	[Job_Feopedback] [float] NULL,
	[Student_Salary] [float] NULL,
	[Insructor_Salary] [decimal](10, 2) NULL,
	[Instructor_exp] [int] NULL,
	[Instructor_Rate] [int] NULL,
	[Course_Rate] [int] NULL,
	[ExamID] [int] NULL,
	[Grade_Course] [float] NULL,
	Inst_HireDate Date,
	InstructorAge INT,
	CourseStartDate Date,
	CourseEndDate DATE,
	CertificationHours INT,
	[StudentKey] [int] NOT NULL, ---student
	[InstructorKey] [int] NOT NULL, ----instructor
	IntakeKey [int] NOT NULL, ---intake
	[DateKey] [int] NOT NULL, ----date
	CourseKey int NOT NULL, ---course
	Track_Key int not null, ---track
	BranchKey int not null, ---branch
	CertificationKey int not null , ---certification
	JobKey int not null, ---job
	CompanyKey int not null ---company


	CONSTRAINT [pk_ITI_fact] PRIMARY KEY(FactKey)
	
	CONSTRAINT DimStudent_FK FOREIGN KEY(StudentKey) REFERENCES DimStudent(Student_SK),
	CONSTRAINT DimInstructor_FK FOREIGN KEY([InstructorKey]) REFERENCES Dim_Instructor(InstructorKey),
	CONSTRAINT DimCourse_FK FOREIGN KEY(CourseKey) REFERENCES DimCourse(Course_SK),
	CONSTRAINT DimIntake_FK FOREIGN KEY(IntakeKey) REFERENCES Dim_Intake(IntakeKey),
	CONSTRAINT DimBranch_FK FOREIGN KEY(BranchKey) REFERENCES Dim_Branch(Branch_SK),
	CONSTRAINT DimTrack_FK FOREIGN KEY(Track_Key) REFERENCES Dim_Track(TrackKey),
	CONSTRAINT DimCertification_FK FOREIGN KEY(CertificationKey) REFERENCES Dim_Certification(CertificationKey),
	CONSTRAINT DimJob_FK FOREIGN KEY(JobKey) REFERENCES Dim_Job(JobKey),
	CONSTRAINT DimCompany_FK FOREIGN KEY(CompanyKey) REFERENCES Dim_Company(CompanyKey),
	CONSTRAINT DimDate_FK FOREIGN KEY(DateKey) REFERENCES DimDate(DateKey)
)






alter table ITI_Fact
add CONSTRAINT DimInstructor_FK FOREIGN KEY(InstructorKey) REFERENCES Dim_Instructor(InstructorKey)






create table Fact_Instructor
(
	instructorFact_Key int identity(1,1),
	instructorID char(14),
	instructorAge int,
	instructorExperience int,
	instructorHireDate Date,
	instructorSalary float,
	CourseRate int,
	instructorRate int,
	courseID int,
	BranchID int, 
	examID int,
	questionID int,
	McqID int,
	TrueFalseID int,
	TextID int,
	branchkey int,
	instructorkey int,
	coursekey int,
	DateKey int,
	ExamKey int,

	constraint instfact_pk primary key(instructorFact_Key),
	constraint brancch_fk foreign key(branchkey) references Dim_Branch(Branch_sk),
	constraint inst_fk foreign key(instructorkey) references Dim_instructor(Instructorkey),
	constraint course_fk foreign key(coursekey) references DimCourse(Course_SK),
	constraint datee_fk foreign key(datekey) references dimDate(Datekey),
	constraint Exammm_fk foreign key(ExamKey) references DimExam(Exam_SK)

)



create table Student_Track_Fact
(
	Student_Track_Key int identity(1,1) primary key,
	studentID char(14),
	intakeID int,
	BranchID int,
	TrackID int,
	ExamID int,
	ExamDate Date,
	StudentKey int,
	intakeKey int,
	trackKey int,
	BranchKey int,
	ExamKey int,
	DateKey int


	constraint stud_fk foreign key(StudentKey) references DimStudent(student_SK),
	constraint int_fk foreign key(intakeKey) references Dim_intake(intakeKey),
	constraint trak_fk foreign key(trackKey) references Dim_Track(trackKey),
	constraint branch_fkkk foreign key (branchKey) references Dim_Branch(Branch_sk),
	constraint Exammm_Fkkk foreign key(examKey) references DimExam(Exam_sk),
	constraint Dateee_fk foreign key(Datekey) references DimDate(DateKey)
)

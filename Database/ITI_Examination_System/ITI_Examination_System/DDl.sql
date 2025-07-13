CREATE DATABASE ITI_Examination_System							
							-----------------------ALY----------------------

-----------------------course table
CREATE TABLE course
(
	CourseID INT IDENTITY(1,1),
	CourseName VARCHAR(20) NOT NULL,
	CourseStartDate DATE,
	CourseEndDate DATE,
	CourseDescription VARCHAR(max)

	CONSTRAINT PK_Course PRIMARY KEY (CourseID)
)



-----------------------Exam table

CREATE TABLE Exam
(
	ExamID INT IDENTITY(1,1),
	ExamStartTime TIME NOT NULL,
	ExamEndTime TIME NOT NULL,
	ExamType VARCHAR(20) NOT NULL,
	ExamDate DATE NOT NULL

	CONSTRAINT PK_Exam PRIMARY KEY (ExamID),
	CONSTRAINT CK_ExamType CHECK (ExamType in ('Corrective','Normal'))
)


-----------------------ExamQuestion table

CREATE TABLE ExamQuestion
(
	ExamID INT,
	QuestID INT,
	Question VARCHAR(MAX) NOT NULL,

	CONSTRAINT FK_ExamQuestion_Exam FOREIGN KEY(ExamID) REFERENCES Exam(ExamID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT PK_ExamQuestion PRIMARY KEY (ExamID, QuestID)
)



-----------------------TrackCourse

CREATE TABLE TrackCourse
(
		CourseID INT,
		TrackID INT,

		CONSTRAINT FK_TrackCourse_Course FOREIGN KEY (CourseID) REFERENCES course(CourseID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		CONSTRAINT FK_TrackCourse_Track FOREIGN KEY (TrackID) REFERENCES Track(TrackID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		CONSTRAINT PK_TrackCourse PRIMARY KEY (CourseID,TrackID)
)



-----------------------Student table

CREATE TABLE Student
(
	StudentID CHAR(14),
	StudentFname VARCHAR(20) NOT NULL,
	StudentLname VARCHAR(20) NOT NULL,
	StudentDOB DATE NOT NULL,
	StudentEmail VARCHAR(70) NOT NULL,
	StudentPhone CHAR(11) NOT NULL,
	StudentAddress VARCHAR(20) NOT NULL,
	TrackID INT,

	CONSTRAINT PK_Student PRIMARY KEY(StudentID),
	CONSTRAINT CK_StudentID CHECK(LEN(StudentID) = 14),
	CONSTRAINT CK_StudentPhone CHECK(LEN(StudentPhone) = 11 AND (LEFT(StudentPhone,3) IN ('010','011','012','015') )),
	CONSTRAINT CK_StudentEmail CHECK(StudentEmail LIKE '_%@_%._%'),
	CONSTRAINT FK_Stuedent_Track FOREIGN KEY(TrackID) REFERENCES Track(TrackID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)

							
							-----------------------RADWA----------------------

-----------------------course table


CREATE TABLE course
(
	CourseID INT IDENTITY(1,1),
	CourseName VARCHAR(20) NOT NULL,
	CourseStartDate DATE,
	CourseEndDate DATE,
	CourseDescription VARCHAR(30)

	CONSTRAINT PK_Course PRIMARY KEY (CourseID)
)


-----------------------TrainingManager table

CREATE TABLE TrainingManager
( 
     ManagerID INT,
	 ManagerFname  VARCHAR(20) NOT NULL,
	 ManagerLname VARCHAR(20) NOT NULL,
	 ManagerEmail VARCHAR(255) NOT NULL ,
	 ManagerPhone CHAR(11)  NOT NULL

	 CONSTRAINT PK_Manager PRIMARY KEY (ManagerID)
)


-----------------------Track table

CREATE TABLE Track
(
	TrackID INT ,
	TrackName VARCHAR(20) NOT NULL,
	DeptID INT

	CONSTRAINT PK_Track PRIMARY KEY (TrackID ),
	CONSTRAINT FK_DeptTrack FOREIGN KEY (DeptID) REFERENCES Department (DeptID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)



-----------------------ExamStudentCourse

CREATE TABLE ExamStudentCourse 
(
    ExamID INT,
    StudentID CHAR(14),
    CourseID INT ,
    Grade FLOAT

	CONSTRAINT FK_Exam FOREIGN KEY(ExamID) REFERENCES Exam(ExamID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_Student FOREIGN KEY(StudentID) REFERENCES Student(StudentID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_Course FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT PK_ExamStudent PRIMARY KEY (ExamID ,StudentID )
)

ALTER TABLE ExamStudentCourse
drop constraint PK_ExamStudent




-----------------------McqQuestion


CREATE TABLE McqQuestion (
    McqID INT,
    Question NVARCHAR(500) NOT NULL,
    CorrectAnswer NVARCHAR(500) NOT NULL,
    Question_ID INT,
    
	CONSTRAINT PK_Mcq PRIMARY KEY (McqID),
	CONSTRAINT FK_Question FOREIGN KEY (Question_ID) REFERENCES Question_Pool (Question_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

-----------------------McqAnswer

CREATE TABLE McqAnswer 
(
	McqID INT,
	AnswerID INT,
	Answer1 VARCHAR(50) NOT NULL,
	Answer2 VARCHAR(50) NOT NULL,
	Answer3 VARCHAR(50) NOT NULL,
	Answer4 VARCHAR(50) NOT NULL

	CONSTRAINT PK_McqAnswer PRIMARY KEY (AnswerID,  McqID),
	CONSTRAINT FK_Mcq FOREIGN KEY ( McqID) REFERENCES McqQuestion (McqID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)


								-------------------SAHER---------------------

-----------------------Branch table

CREATE TABLE branch
(
    Branch_ID int identity(1,1),
    Branch_Name VARCHAR(100),
    Branch_Address VARCHAR(255),
    Branch_Phone char(11) not null,
    CONSTRAINT pk_branch PRIMARY KEY (Branch_ID),
	CONSTRAINT chk_phone_length CHECK (LEN(Branch_Phone) = 11)	
);

ALTER TABLE branch
ADD ManagerID INT;
ALTER TABLE branch
ADD CONSTRAINT FK_trainingMangerbranch_TrainingManager 
FOREIGN KEY (ManagerID) REFERENCES TrainingManager(ManagerID)
ON DELETE CASCADE
ON UPDATE CASCADE;

-----------------------QuestionPool table

CREATE TABLE Question_pool
(
    Question_ID int identity(1,1) primary key,
    Question_Degree int not null
)

-----------------------BracnIntakeTrack table

CREATE TABLE BranchIntakeTrack 
(
    Branch_ID INT NOT NULL,
    intake_id INT NOT NULL,
    TrackID INT ,
    -- Primary Key Constraint
    CONSTRAINT PK_BranchIntakeTrack PRIMARY KEY (Branch_ID, intake_id),
    -- Foreign Key Constraints
    CONSTRAINT FK_BranchIntakeTrack_Branch FOREIGN KEY (Branch_ID)REFERENCES branch(Branch_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_BranchIntakeTrack_Intake FOREIGN KEY (intake_id) REFERENCES intake(intake_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_BranchIntakeTrack_Track FOREIGN KEY (TrackID) REFERENCES Track(TrackID)
       ON DELETE SET NULL
        ON UPDATE CASCADE
);

-----------------------CourseInstructor

CREATE TABLE CourseInstructor
(
    CourseID INT NOT NULL,
    InstructorID INT NOT NULL,
    -- Primary Key Constraint
    CONSTRAINT PK_CourseInstructor PRIMARY KEY (CourseID, InstructorID),
    -- Foreign Key Constraints
    CONSTRAINT FK_CourseInstructor_Course FOREIGN KEY (CourseID)REFERENCES Course(CourseID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_CourseInstructor_Instructor FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

---- create a new column (maked it null to insert data)
alter table CourseInstructor
add IntakeID INT 
--- convert null column to not null 
alter table  CourseInstructor
alter column IntakeID int Not null

alter table CourseInstructor
add Constraint FK_CourseInstructor_Intake FOREIGN KEY(IntakeID) REFERENCES intake(intake_id)

alter table CourseInstructor
drop constraint PK_CourseInstructor

alter table CourseInstructor
add constraint PK_CourseInstructor primary key(CourseID, IntakeID)

-----------------------BranchIntakeTrack

CREATE TABLE BranchIntakeTrack 
(
    Branch_ID INT ,
    intake_id INT,
    TrackID INT ,
    -- Primary Key Constraint
    CONSTRAINT PK_BranchIntakeTrack PRIMARY KEY (Branch_ID, intake_id),
    -- Foreign Key Constraints
    CONSTRAINT FK_BranchIntakeTrack_Branch FOREIGN KEY (Branch_ID)REFERENCES branch(Branch_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_BranchIntakeTrack_Intake FOREIGN KEY (intake_id) REFERENCES intake(intake_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_BranchIntakeTrack_Track FOREIGN KEY (TrackID) REFERENCES Track(TrackID)
       ON DELETE SET NULL
        ON UPDATE CASCADE
);

----------------------- ExamInstructorQuestion

CREATE TABLE ExamInstructorQuestion (
    ExamID INT NOT NULL,
    InstructorID INT NOT NULL,
    QuestionID INT,
    -- Primary Key Constraint
    CONSTRAINT PK_ExamInstructorQuestion PRIMARY KEY (ExamID, InstructorID),
    -- Foreign Key Constraints
    CONSTRAINT FK_ExamInstructorQuestion_Exam FOREIGN KEY (ExamID) REFERENCES Exam(ExamID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_ExamInstructorQuestion_Instructor FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,    
    CONSTRAINT FK_ExamInstructorQuestion_Question FOREIGN KEY (QuestionID) REFERENCES Question_pool(Question_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

						------------------------AMMAR-------------------------


-----------------------Department table

CREATE TABLE Department
(
	DeptID  INT IDENTITY(1, 1) NOT NULL,
	DeptName varchar(50) NOT NULL
	CONSTRAINT Dept_PK PRIMARY KEY (DeptID) 
)



-----------------------Instructor table

CREATE TABLE Instructor
(
	InstructorID  INT IDENTITY(1, 1) NOT NULL,
	InstructorFName varchar(50) NOT NULL ,
	InstructorLName varchar(50) NOT NULL,
	InstructorEmail varchar(100) NOT NULL  unique ,
	HairDate date  default getdate(),
	InstructorPhone char(11) NOT NULL,
	CONSTRAINT check_Email check(InstructorEmail like '(%gmail.com' or InstructorEmail like '(%yahoo.com' ),
	CONSTRAINT CK_Phone CHECK(LEN(InstructorPhone) = 11),
	CONSTRAINT Instructor_PK PRIMARY KEY (InstructorID) 
)



-----------------------TextQuestion table

CREATE  TABLE TextQuestion
(
	TextID  INT IDENTITY(1, 1) NOT NULL,
	Question nvarchar(max) NOT NULL,
	CorrectAnswer nvarchar(max) NULL ,
	Question_ID INT ,
	CONSTRAINT TextQuestion_fK foreign KEY (Question_ID) REFERENCES Question_pool( Question_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT TextQuestion_PK PRIMARY KEY (TextID) 
)



-----------------------ExamStudentAnswer table

CREATE TABLE ExamStudentAnswer
(
	ExamID  INT not null,
	StudentID  char(14) not null ,
	StuAnsID INT not null,
	Grade float(7) not null ,
	CONSTRAINT ExamStudentAnswer_fK1 foreign KEY (ExamID) REFERENCES Exam(ExamID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT ExamStudentAnswer_fK2 foreign KEY (StudentID) REFERENCES Student(StudentID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT ExamStudentAnswer_fK3 foreign KEY (StuAnsID) REFERENCES studentanswer(stuans)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT ExamStudentAnswer_PK PRIMARY KEY (ExamID,StudentID) 
)



-----------------------DepartmentTrack table

CREATE TABLE DepartmentTrack
(
	DeptID  INT not null,
	TrackID  INT not null,
	CONSTRAINT DepartmentTrack_fK1 foreign KEY (DeptID) REFERENCES Department(DeptID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT DepartmentTrack_fK2 foreign KEY (TrackID) REFERENCES Track (TrackID)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	CONSTRAINT  DepartmentTrack_PK PRIMARY KEY (DeptID,TrackID)
)


							----------------MARIEM----------------------


-----------------------Intake table

CREATE TABLE intake
(
	intake_id INT IDENTITY(1,1),
	intake_name VARCHAR(50) NOT NULL,
	intake_start_date DATE NOT NULL,
	intake_end_date DATE NOT NULL 

	CONSTRAINT PK_Intake PRIMARY KEY(intake_id)
);

-----------------------branchintake table
 
CREATE TABLE branchintake
(
	branch_id INT ,
	intake_id INT ,
	CONSTRAINT PK_BranchIntake PRIMARY KEY (branch_id,intake_id),
	CONSTRAINT FK_BranckIntake_Intake FOREIGN KEY (intake_id) REFERENCES intake(intake_id),
	CONSTRAINT FK_BranchIntake_Branch FOREIGN KEY(branch_id) REFERENCES branch(branch_id),
);

-----------------------studentanswer table

CREATE TABLE studentanswer
(
	stuans INT IDENTITY(1,1),
	answer VARCHAR(255),
	iscorrect BIT

	CONSTRAINT PK_Studentanswer PRIMARY KEY(stuans)
);

-----------------------truefalsequestion table

CREATE TABLE truefalsequestion
(
	trfaid INT IDENTITY (1,1),
	question TEXT NOT NULL,
	correctanswer BIT NOT NULL,
	question_id INT,
	CONSTRAINT PK_TrueFalseQuestion PRIMARY KEY(trfaid), 
	CONSTRAINT FK_TrueFalseQuestion_Question FOREIGN KEY(question_id) REFERENCES question_pool(question_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

-----------------------truefalseanswer table

CREATE TABLE truefalseanswer
(
	answerid INT IDENTITY (1,1),
	trfaid INT NOT NULL,
	answer1 BIT,
	answer2 BIT,
	CONSTRAINT PK_TrueFalseAnswer PRIMARY KEY(answerid),
	CONSTRAINT TrueFalseId FOREIGN KEY (trfaid)REFERENCES truefalsequestion(trfaid)
);




 


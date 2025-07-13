create or alter view vvnewFact as
select i.InstructorID, i.inst_DOB, i.inst_exp, i.HairDate, i.Salary,
		cis.CourseRate, cis.InstructorRate,
		c.CourseID,t.TrackID, it.intake_id, b.Branch_ID,s.studentid
from instructor i
join CourseInstructorStudent cis
on i.InstructorID = cis.InstructorID
join course c
on cis.CourseID = c.CourseID
join TrackCourse tc
on c.CourseID = tc.courseid
join Track t
on tc.trackid = t.TrackID
join BranchIntakeTrack bti
on t.TrackID = bti.TrackID
join intake it
on bti.intake_id = it.intake_id
join branch b
on b.Branch_ID = bti.Branch_ID
join branchTracKstudent bts
on b.Branch_ID = bts.BranchID
join student s
on s.studentid = bts.studentid

SELECT count(distinct StudentID), Branch_ID
FROM vvnewFact
group by Branch_ID

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
	TrackID int,
	intakeID int,
	BranchID int, 
	McqID int,
	TrueFalseID int,
	TextID int,
	branchkey int,
	instructorkey int,
	intakekey int,
	trackKey int,
	coursekey int,
	DateKey int

	constraint instfact_pk primary key(instructorFact_Key),
	constraint brancch_fk foreign key(branchkey) references Dim_Branch(Branch_sk),
	constraint inst_fk foreign key(instructorkey) references Dim_instructor(Instructorkey),
	constraint intake_fk foreign key(intakekey) references Dim_intake(intakeKey),
	constraint track_fk foreign key(trackKey) references Dim_track(trackKey),
	constraint course_fk foreign key(coursekey) references DimCourse(Course_SK),
	constraint datee_fk foreign key(datekey) references dimDate(Datekey)

)



select eiq.InstructorID, mcq.McqID, tfq.trfaid, tq.TextID
from examinstructorquestion eiq
join Question_pool qp
on qp.Question_ID = eiq.QuestionID
join McqQuestion mcq
on mcq.Question_ID = qp.Question_ID
join truefalsequestion tfq
on qp.Question_ID = tfq.question_id
join TextQuestion tq
on qp.Question_ID = tq.Question_ID





create table New_Fact_Instructor
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
	TrackID int,
	intakeID int,
	BranchID int, 
	McqID int,
	TrueFalseID int,
	TextID int,
	StudentID char(14),
	branchkey int,
	instructorkey int,
	intakekey int,
	trackKey int,
	coursekey int,
	DateKey int,
	Studentkey int

	constraint instfaact_pk primary key(instructorFact_Key),
	constraint branccch_fk foreign key(branchkey) references Dim_Branch(Branch_sk),
	constraint instt_fk foreign key(instructorkey) references Dim_instructor(Instructorkey),
	constraint intakee_fk foreign key(intakekey) references Dim_intake(intakeKey),
	constraint tracck_fk foreign key(trackKey) references Dim_track(trackKey),
	constraint coursee_fk foreign key(coursekey) references DimCourse(Course_SK),
	constraint dateee_fk foreign key(datekey) references dimDate(Datekey),
	constraint studentdd_fk foreign key(Studentkey) references DimStudent(student_SK)

)



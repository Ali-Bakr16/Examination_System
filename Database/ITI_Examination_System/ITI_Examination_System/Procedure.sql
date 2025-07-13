CREATE OR ALTER PROCEDURE assignExam @studentID CHAR(14), @course varchar(100), @examID INT, @examdate Date,@stime time, @etime time  --ali
AS
BEGIN
	Begin transaction
		Declare @date date
		declare @endtime time
		declare @startiem time
		declare @courseid int

		select @date = ExamDate, @endtime = ExamEndTime, @startiem = ExamStartTime
		from Exam
		where ExamID = @examID
		select @courseid = CourseId
		from course
		where CourseName = @course

		if @date = @examdate and @endtime = @etime and @startiem = @stime
			begin 
				insert into ExamStudentCourse(ExamID,CourseID,StudentID)
				values(@examID, @courseid, @studentID)
				commit
			end
			else
			begin
				rollback
				print'Can not assign Exam'
			end

	
END


-----------------------------------------------------

CREATE OR ALTER PROCEDURE UpdateCourse @courseID INT,@courseStrartdate DATE, @courseEnddate DATE,@instructorID INT, @intakeid INT --ali
AS
BEGIN
	
	UPDATE CourseInstructor
	SET InstructorID = @instructorID
	WHERE CourseID = @courseID and IntakeID = @intakeid
	
	UPDATE course
	SET CourseStartDate = @courseStrartdate, CourseEndDate = @courseEnddate
	WHERE CourseID = @courseID 
END

------------------------------------------------------------

CREATE OR ALTER PROCEDURE CreateExam    --ali
						@InstructorID INT,
						@CourseID INT,
						@textnum INT,
						@mcqnum INT,
						@TFnum INT,
						@ExamType VARCHAR(20),
						@CreateWay VARCHAR(10),
						@StartTime TIME,
						@EndTime TIME,
						@ExamDate DATE
						

AS
BEGIN

 if @StartTime < @EndTime
	begin
	IF @CreateWay = 'manual'
	BEGIN
		SELECT Question
		FROM TextQuestion

		SELECT q.question, a.answer1, a.answer2
		FROM truefalsequestion q
		JOIN truefalseanswer a
		ON q.trfaid = a.trfaid
		
		SELECT q.Question_ID, a.Answer1, a.Answer2, a.Answer3, a. Answer4
		FROM McqQuestion q
		JOIN McqAnswer a
		ON a.McqID = q.McqID
	END

	ELSE IF @CreateWay = 'random'
	BEGIN
		
		
		
		INSERT INTO Exam (ExamStartTime,ExamEndTime,ExamDate,ExamType)
		VALUES (@StartTime, @EndTime,@ExamDate,@ExamType)

		declare @ExamID INT
		
		select @ExamID = ExamID
		FROM Exam 
		WHERE ExamStartTime = @StartTime and ExamEndTime = @EndTime and ExamDate = @ExamDate

		INSERT INTO ExamQuestion (Question,QuestID,ExamID)
		SELECT TOP(@textnum) Question, Question_ID, @ExamID
		FROM TextQuestion
		ORDER BY NEWID()
		INSERT INTO ExamQuestion (Question, QuestID, ExamID)
		SELECT TOP(@mcqnum) Question, Question_ID,@ExamID
		FROM McqQuestion
		ORDER BY NEWID()
		INSERT INTO ExamQuestion (Question, QuestID,ExamID)
		SELECT TOP(@TFnum) question,question_id, @ExamID
		FROM truefalsequestion
		ORDER BY NEWID()

		INSERT INTO ExamInstructorQuestion(InstructorID, ExamID)
		VALUES(@InstructorID, @ExamID)

		PRINT 'Exam Is Created Sccussfuly'
	END
	End
Else
	print 'Unvalid Time'

END

select * from ExamQuestion
-----------------------------------------------------------------

CREATE OR ALTER PROCEDURE UpdateStudentDetails  --radwa
    @StudentID CHAR(14),
    @NewStudentFname VARCHAR(50),
    @NewStudentLname VARCHAR(50),
    @NewStudentEmail VARCHAR(100),
    @NewStudentPhone VARCHAR(15),
	@NewDateofBirth DATE,
	@NewAddress VARCHAR(50)
AS
BEGIN
    

    UPDATE Student
    SET 
        StudentFname = @NewStudentFname,
        StudentLname = @NewStudentLname,
        StudentEmail = @NewStudentEmail,
        StudentPhone = @NewStudentPhone,
		StudentAddress = @NewAddress,
		StudentDOB = @NewDateofBirth
    WHERE StudentID = @StudentID;
END

----------------------------------------------------------------

CREATE or ALTER PROCEDURE CalculateTotalGrade  --radwa
    @StudentID CHAR(14)
AS
BEGIN
    DECLARE @total_grade FLOAT 

    SELECT @total_grade = SUM(Grade)
    FROM ExamStudentAnswer
    WHERE StudentID = @StudentID;

    SELECT @total_grade AS TotalGrade;
END;


 ---------------------------------------------------------


create or alter procedure insertstudent   --mariam
@studentid char(14),@firstname varchar(20) , @lastname varchar(20),@dateofbirth date,@email varchar(70),
@phone char(11),@address varchar(20),@track int,@intacke int,@branch varchar(50)
as
begin
insert into Student(StudentID,StudentFname,StudentLname,StudentDOB,StudentEmail,StudentPhone,StudentAddress,TrackID)
values(@studentid,@firstname, @lastname ,@dateofbirth,@email,@phone,@address,@track)
declare @branchid int
select @branchid = Branch_ID 
from branch
where Branch_Name = @branch

insert into BranchIntakeTrack(Branch_ID,intake_id,TrackID)
values(@branchid,@intacke,@track)
print'Student Inserted Successfuly'
end;


----------------------------------------------------------------

CREATE PROCEDURE PS_UpdateExamSchedule  --saher
    @ExamID INT,
    @NewExamDate DATE,
    @NewStartTime TIME,
    @NewEndTime TIME
AS
BEGIN
    UPDATE Exam
    SET 
        ExamDate = @NewExamDate,
        ExamStartTime = @NewStartTime,
       ExamEndTime = @NewEndTime
    WHERE ExamID = @ExamID
END


-----------------------------------------------------------------------------


CREATE OR ALTER PROCEDURE assignExamcorrective @studentID CHAR(14), @course varchar(100), @examID INT, @examdate Date,@stime time, @etime time  --ali
AS
BEGIN
	Begin transaction
		Declare @date date
		declare @endtime time
		declare @startiem time
		declare @courseid int
		declare @ctype varchar(20)

		select @date = ExamDate, @endtime = ExamEndTime, @startiem = ExamStartTime, @ctype = ExamType
		from Exam
		where ExamID = @examID
		select @courseid = CourseId
		from course
		where CourseName = @course
		if @studentID in (select StudentID  from ExamStudentCourse)
		begin
			if @date = @examdate and @endtime = @etime and @startiem = @stime and @ctype = 'normal'
				begin 
					insert into ExamStudentCourse(ExamID,CourseID,StudentID)
					values(@examID, @courseid, @studentID)
					commit
				end
			else 
				begin
					rollback
					print'Can not assign Exam'
				end
		end
	
END


create or alter procedure viewstudentgrads @coursename varchar(100)
as
begin
	
	select CONCAT(s.StudentFname, ' ' , s.StudentLname) 'Student Name', c.CourseName, esc.Grade
	from Student s
	join ExamStudentCourse esc
	on esc.StudentID = s.StudentID
	join course c
	on c.CourseId = esc.CourseID
	where c.CourseName = @coursename

end

 

 ------------------------------------------------------------------------------------

 CREATE OR ALTER PROCEDURE CreateSelectedExamWithMCQandText
    @exam_Id INT,
    @NumberOfQuestions INT,
    @min_degree INT,
    @max_degree INT,
    @exam_state VARCHAR(50),
    @exam_Type VARCHAR(50),
    @allowance_option VARCHAR(50),
    @start_time TIME,
    @end_time TIME,
    @exam_Date DATE,
    @duration TIME,
    @PoolID INT,
    @SelectedQuestionIds VARCHAR(MAX) -- e.g., '101,105,203'
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Preview questions
    PRINT '------ Available Questions in Pool ------';
    SELECT * FROM View_AllQuestions WHERE PoolID = @PoolID;

    -- 2. Insert new exam
    INSERT INTO Exam (
        exam_Id,
        NumberOfQuestions,
        exam_state,
        min_degree,
        max_degree,
        exam_Type,
        allowance_option,
        end_time,
        start_time,
        exam_Date,
        duration,
        PoolID
    )
    VALUES (
        @exam_Id,
        @NumberOfQuestions,
        @exam_state,
        @min_degree,
        @max_degree,
        @exam_Type,
        @allowance_option,
        @end_time,
        @start_time,
        @exam_Date,
        @duration,
        @PoolID
    );

  
    DECLARE @xml XML
    SET @xml = CAST('<i>' + REPLACE(@SelectedQuestionIds, ',', '</i><i>') + '</i>' AS XML)

    INSERT INTO ExamQ (ExamID, Qid)
    SELECT @exam_Id, x.i.value('.', 'INT') AS Qid
    FROM @xml.nodes('/i') AS x(i);

    PRINT 'Selected exam created successfully.';
END;
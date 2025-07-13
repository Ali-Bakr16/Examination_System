---- insert new student

create or alter procedure insertstudent   
@studentid char(14),@firstname varchar(20) , @lastname varchar(20),@dateofbirth date,@email varchar(70),
@phone char(11),@address varchar(20), @gender char(1),@faculty varchar(50),@track varchar(100),@branch varchar(50)
as
begin
insert into Student(StudentID,StudentFname,StudentLname,StudentDOB,StudentEmail,StudentPhone,StudentAddress, Gender, FACULTY)
values(@studentid,@firstname, @lastname ,@dateofbirth,@email,@phone,@address, @gender, @faculty)
declare @branchid int, @trackid int
select @branchid = Branch_ID 
from branch
where Branch_Name = @branch

select @trackid  = TrackID 
from Track 
where TrackName = @track

insert into BranchTrackStudent(BranchID,StudentID,TrackID)
values(@branchid,@studentid,@trackid)
print'Student Inserted Successfuly'
end;



create type intlist as table
(	
	qids int
)

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


------------------Create Exam 






CREATE OR ALTER PROCEDURE CreateExam    --ali
						@examid int,
						@InstructorID INT,
						@CourseID INT,
						@textnum INT,
						@mcqnum INT,
						@TFnum INT,
						@ExamType VARCHAR(20),
						@StartTime TIME,
						@EndTime TIME,
						@ExamDate DATE,
						@maxdegree int
						

AS
BEGIN

 if @StartTime < @EndTime
	begin
	
		
		INSERT INTO Exam (ExamID,ExamStartTime,ExamEndTime,ExamDate,ExamType, MaxDegree)
		VALUES (@examid,@StartTime, @EndTime,@ExamDate,@ExamType, @maxdegree)

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



		PRINT 'Exam Is Created Sccussfuly'
	End
Else
	print 'Unvalid Time'

END


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



---------Assign Exam


CREATE OR ALTER PROCEDURE assignNormalExam @studentID CHAR(14), @course varchar(100), @examID INT, @examdate Date,@stime time, @etime time  --ali
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



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


-----------assign Corrective Exam



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



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


---------correct Text question



CREATE OR ALTER procedure CorrectTextQuestion 
							@ExamID INT, 
							@StenudtID CHAR(14),
							@answerID INT,
							@Answer NVARCHAR(MAX), 
							@grade real

AS
BEGIN
	
	DECLARE @StudentAnswer NVARCHAR(MAX)
	SELECT @StudentAnswer = sa.answer
	FROM ExamStudentAnswer esa
	JOIN studentanswer sa
	ON esa.StuAnsID = sa.stuans
	WHERE esa.ExamID = @ExamID AND esa.StudentID = @StudentID AND esa.StuAnsID = @answerID

	IF @Answer LIKE '%'+@StudentAnswer+ '%'
	BEGIN
		insert into ExamStudentAnswer(ExamID, StudentID, StuAnsID, Grade)
		values (@ExamID, @StudentID, @answerID, @grade)
		print 'correct answer'
	END
	else
	begin
	insert into ExamStudentAnswer(ExamID, StudentID, StuAnsID, Grade)
		values (@ExamID, @StudentID, @answerID, 0)
	print 'wrong answer'
	end
END



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



---- correct MCQ questions

CREATE OR ALTER procedure Correct_Mcq_Question 
							@studentid char(14), 
							@examID int, 
							@QuestionID int, 
							@Studentanswer varchar(100) , 
							@answerid int,
							@grade int

AS
BEGIN
		
		declare @correctAnswer varchar(100)
		select @correctAnswer = CorrectAnswer
		from McqQuestion 
		where Question_ID = @questionID
	
	
		if @correctAnswer = @Studentanswer
		begin 
			insert into ExamStudentAnswer(ExamID, StudentID, StuAnsID, Grade)
			values (@examID, @studentid, @answerid, @grade)

			print 'Corrent Answer'
	
		end
		else
		begin
			
			insert into ExamStudentAnswer(ExamID, StudentID, StuAnsID, Grade)
			values (@examID, @studentid, @answerid, 0)

			print 'Wrong Answer'
		end
END





----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



---- correct True False questions

CREATE OR ALTER procedure Correct_TrueFalse_Question 
							@studentid char(14), 
							@examID int, 
							@QuestionID int, 
							@Studentanswer varchar(100) , 
							@answerid int,
							@grade int

AS
BEGIN
		declare @transformanswer bit
		if @Studentanswer = 'True'
			begin
				set @transformanswer = 1
			end
		else
			begin
				set @transformanswer = 0
			end
		
		declare @correctAnswer bit
		select @correctAnswer = CorrectAnswer
		from truefalsequestion 
		where Question_ID = @questionID
	
	
		if @correctAnswer = @transformanswer
		begin 
			insert into ExamStudentAnswer(ExamID, StudentID, StuAnsID, Grade)
			values (@examID, @studentid, @answerid, @grade)

			print 'Corrent Answer'
	
		end
		else
		begin
			
			insert into ExamStudentAnswer(ExamID, StudentID, StuAnsID, Grade)
			values (@examID, @studentid, @answerid, 0)

			print 'Wrong Answer'
		end
END



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



---- calculate total exam Degree


create or alter procedure calculateTotalDegreePerCourse @studentid char(14), @examid int, @courseid int
as
begin
	
	declare @totalDegree float

	select @totalDegree = sum(Grade)
	from ExamStudentAnswer
	where  ExamID = @examid

	insert into ExamStudentCourse(ExamID, studentID, courseID, Grade)
	values(@examid, @studentid, @courseid, @totalDegree)

	if @totalDegree	>= 50
		print 'Success'
	else
		print 'Fail'

end








CREATE or alter PROCEDURE CreateExamMannually
    @ExamID INT,
    @InstructorID char(14),
    @QuestionIDs NVARCHAR(MAX) 
AS
BEGIN
    SET NOCOUNT ON;

        DECLARE @QuestionIDTable TABLE (QuestionID BIGINT);

    INSERT INTO @QuestionIDTable (QuestionID)
    SELECT value 
    FROM STRING_SPLIT(@QuestionIDs, ',')

    INSERT INTO ExamInstructorQuestion (ExamID, InstructorID, QuestionID)
    SELECT @ExamID, @InstructorID, QuestionID
    FROM @QuestionIDTable

    PRINT 'Exam Created Successfully'
END





















create or alter procedure createExamManually
						@mcqQuestinoIDs intlist,
						@trueFalseQuestionIDS intlist,
						@textQuestionIDs intlist,
						@InstructorID INT,
						@CourseID INT,
						@maxdegree int,
						@ExamType VARCHAR(20),
						@StartTime TIME,
						@EndTime TIME,
						@ExamDate DATE
as
begin
	if @StartTime > @EndTime
	begin

		
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



		insert into Exam(ExamType, ExamDate, ExamEndTime, ExamStartTime, MaxDegree)
		values(@ExamType, @ExamDate, @EndTime, @StartTime,@maxdegree)
		declare @examid int

		select @examid = ExamID
		from Exam
		where ExamDate = @ExamDate and ExamType = @ExamType and ExamStartTime = @StartTime and ExamEndTime = @EndTime

		insert into ExamQuestion(ExamID, QuestID, Question)
		values(@examid,  


		


	end
	else
	begin
		print 'Unvalid Time'
	end


end







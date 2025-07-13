CREATE OR ALTER FUNCTION FN_CalculateExamResult  ---saher
(
    @StudentID char(14),
    @ExamID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT

    SELECT @Result = SUM(esa.Grade)
    FROM ExamStudentAnswer esa
    JOIN StudentAnswer sa ON esa.StuAnsID = esa.StuAnsID
    WHERE esa.StudentID = @StudentID
      AND esa.ExamID = @ExamID
      AND sa.IsCorrect = 1

    RETURN @Result
END


	------------------------------------------------------------------------------


CREATE OR ALTER FUNCTION calculate_student_total_marks (@student_id CHAR(14)) ---radwa
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total_marks DECIMAL(10,2) = 0;

    SELECT @total_ma
    RETURN @total_marksrks = ISNULL(SUM(EXA.Grade), 0)
    FROM studentanswer SA
    JOIN ExamStudentAnswer EXA ON EXA.StuAnsID = SA.stuans
    JOIN Exam E ON E.ExamID = EXA.ExamID

    WHERE EXA.StudentID = @student_id;

END



------------------------------------------------------

create OR ALTER function fn_getotallenrollmentstudent() ---mariam
returns int
as
begin
  declare @total int;
  select @total=count(StudentID)
  from Student;
  return @total;
end;


---------------------------------------------------------

create OR ALTER function fn_truefalsequestions(@questionID int,@UserAnswer bit) --mariam
returns int
as
begin
declare @grade int;
select @grade =
       case
	   WHEN CorrectAnswer = @UserAnswer THEN 1
            ELSE 0
        END
    FROM TrueFalseQuestion
    WHERE question_id = @QuestionID;

    RETURN ISNULL(@Grade, 0); 
END;


---------------------------------------------------------Aly


CREATE OR ALTER FUNCTION Correct_Text_Question(@ExamID INT, @StudentID CHAR(14),@answerID INT,@Answer NVARCHAR(MAX))
RETURNS BIT
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
		RETURN 1
	END
	
	
	RETURN 0
END


-----------------------------------------------------------Ammar

CREATE or alter FUNCTION fn_get_student_rank_in_course
(
    @StudentID CHAR(14),
    @ExamID INT,
    @CourseID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Rank INT;

    WITH Ranked AS (
        SELECT 
            StudentID,
            RANK() OVER (
                PARTITION BY CourseID, ExamID 
                ORDER BY Grade DESC
            ) AS StudentRank
        FROM ExamStudentCourse
        WHERE CourseID = @CourseID AND ExamID = @ExamID
    )
    SELECT @Rank = StudentRank
    FROM Ranked
    WHERE StudentID = @StudentID;

    RETURN @Rank;
END;




CREATE OR ALTER FUNCTION dbo.FUN_QUESTION_TEXT(@QUESTION NVARCHAR(MAX))
RETURNS BIT
AS 
BEGIN
    DECLARE @MINLENGTH INT = 10
    DECLARE @MAXLENGTH INT = 1000

    IF LEN(@QUESTION) < @MINLENGTH RETURN 0
    IF LEN(@QUESTION) > @MAXLENGTH RETURN 0
    IF RIGHT(RTRIM(@QUESTION), 1) NOT IN ('?', '?') RETURN 0
    
    RETURN 1
END
GO

ALTER TABLE TEXTQUESTION
ADD CONSTRAINT QUESTION_TEXT_CHECK
CHECK (dbo.FUN_QUESTION_TEXT(QUESTION) = 1)




CREATE OR ALTER FUNCTION Correct_Mcq_Question(@questionid int ,@answer VARCHAR(50))
RETURNS BIT
AS
BEGIN
		DECLARE @CorrectAnswer VARCHAR(50)

		SELECT @CorrectAnswer = CorrectAnswer
		FROM McqQuestion 
		where McqID = @questionid

		IF @answer = @CorrectAnswer
		BEGIN
			return 1 
		END

		return 0
		
END




CREATE OR ALTER FUNCTION get_student_result_with_name (@student_id char(14))
RETURNS TABLE
AS
RETURN (
    SELECT 
        S.StudentFname,
        S.StudentLname,
        --ISNULL(SUM(EXA.Grade), 0) AS TotalMarks,
		SUM(ISNULL(ESC.Grade,0))AS TotalMarks,
        CASE 
            WHEN SUM(ISNULL(ESC.Grade,0)) >= 50 THEN 'Pass'
            ELSE 'Fail'
        END AS ResultStatus
    FROM 
        Student S  
    LEFT JOIN 
        ExamStudentCourse ESC ON ESC.StudentID = S.StudentID
    WHERE 
        S.StudentID = @student_id
    GROUP BY 
        S.StudentFname, S.StudentLname
);


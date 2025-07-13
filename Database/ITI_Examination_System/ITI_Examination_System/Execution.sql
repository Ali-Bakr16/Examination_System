
					-------------------functions------------------------------

------------- calculate exam result

SELECT dbo.FN_CalculateExamResult('20250000000102',1)

---------create	question  (check by constraint)

select dbo.FUN_QUESTION_TEXT('what is transaction?')

select dbo.FUN_QUESTION_TEXT('what is transaction')

-------------------------get all students

SELECT dbo.fn_getotallenrollmentstudent()

------------------------------check true false question

SELECT dbo.fn_truefalsequestions(1,0)

--------------------------- check text questions

SELECT dbo.Correct_Text_Question(1,'20250000000102',23,'djdjfndjjdPPPPPHJGHGGFieieii')

--------------------------------Get student rank

SELECT dbo.fn_get_student_rank_in_course('20250000000105',1,1)

					-------------------procedures------------------------------
----1
---error
execute assignExam '20250000000103','Data Analysis',2,'2025-06-02','09:00:00','11:00:00'
---correct
execute assignExam '20250000000104','DevOps',2,'2025-05-31','11:00:00','12:30:00'
----correct
execute assignExamcorrective '20250000000104','DevOps',2,'2025-05-31','11:00:00','12:30:00'
----error
execute assignExamcorrective '20250000000104','DevOps',9,'2025-05-22','01:00:00','02:30:00'
----2
EXECUTE UpdateCourse 2,'2025-5-19','2025-5-27',3,5
----3
EXECUTE CreateExam 1,1,2,2,2,'corrective','manual','01:00:00','02:00:00','2025-5-22'

EXECUTE CreateExam 1,1,2,2,2,'corrective','random','01:00:00','02:00:00','2025-5-22'
----4
EXECUTE UpdateStudentDetails '20250000000101','Ali','Bakr','alibakr16220@gmail.com','01027966337','2002-01-16','Minya'

----5

EXECUTE CalculateTotalGrade '20250000000102'

----6

EXECUTE insertstudent '20202020202020','Khaled','Hassan','1995-04-20','hassanKhaled@gmail.com','01020304050','Qena'


----7

EXECUTE PS_UpdateExamSchedule 2,'2025-5-31','11:00:00','12:30:00'


-------------------------------------------------------

			-----------------------------triggers-----------------

-------Previant Daplicate assign course to same student

INSERT INTO ExamStudentCourse
VALUES (1,'20250000000102',1,40)

-------------Prevent Negative Marks

INSERT INTO ExamStudentAnswer
VALUES(3,'20250000000103',26,-2)

-------------- Prevent modification of student answer

UPDATE ExamStudentAnswer
SET Grade = 3 
WHERE ExamID = 1 AND StudentID = '20250000000105'

------------------------ Prevent Duplicate Course

INSERT INTO course(CourseName,CourseStartDate,CourseEndDate,CourseDescription)
VALUES('DevOps','2025-5-10','2025-5-14','Docker,Kubeernetes.CI/CD pipelines')

--------------------------prevent delete student answer

DELETE FROM studentanswer 
WHERE stuans = 25

				-------------------------VIEWS---------------------------


--------------------- View Exam Scheduale

SELECT * FROM ExamSchedule

--------------------- View Student Exam Result

SELECT * FROM studentexamresult

---------------------- View Student Card Info

SELECT * FROM studentcardinfo

-------------------- View Failed Student

SELECT * FROM Failed_Students
---S----Insert new Student 

EXECUTE insertstudent '20251100202020','Mohamed','Hassan','2000-05-08','hassanMohamed000@gmail.com','01054485050','Qena',4,3,'Minia'

--H---Create Correct Question  

select dbo.FUN_QUESTION_TEXT('what is transaction?') 'Question'

--H--- Error At Create Question  

select dbo.FUN_QUESTION_TEXT('what is transaction') 'Question'

--A---- Create Exam Manually  
EXECUTE CreateExam 1,1,2,2,2,'corrective','manual','13:00:00','14:00:00','2025-5-22'

--A--Create Exam Random   

EXECUTE CreateExam 1,1,2,2,2,'normal','random','13:00:00','14:00:00','2025-5-22'

---- Time Validation
EXECUTE CreateExam 1,1,2,2,2,'normal','random','13:00:00','10:00:00','2025-5-22'

---S---Assign Exam To Student

-----Return Error because enter wrong date and time

EXECUTE assignExam '20250000000103','Data Analysis',2,'2025-06-02','09:00:00','11:00:00'

------- Run correct

execute assignExam '20250000000104','DevOps',2,'2025-05-31','11:00:00','12:30:00'

----- Run correct

execute assignExamcorrective '20250000000104','DevOps',2,'2025-05-31','11:00:00','12:30:00'


----Return Error because the student dosen't take normal exam

execute assignExamcorrective '20250000000104','DevOps',9,'2025-05-22','01:00:00','02:30:00'


--M---Update Exam Scheduale

EXECUTE PS_UpdateExamSchedule 2,'2025-5-31','11:00:00','12:30:00'

--M--- Correct True False Answer

SELECT dbo.fn_truefalsequestions(1,0) 'Question Result'


---A------ Correct Text Question

SELECT dbo.Correct_Text_Question(1,'20250000000102',23,'djdjfndjjdPPPPPHJGHGGFieieii') 'Text Question Result'

---R----Correct MCQ Question

---ERROR
SELECT dbo.Correct_Mcq_Question(30,'DHU') 'Check answer'

---Correct 

SELECT dbo.Correct_Mcq_Question(30,'DHU') 'Check answer'

---R---Calculate Exam Result

SELECT dbo.FN_CalculateExamResult('20250000000102',1)


--H---Get Student Ranke 

SELECT dbo.fn_get_student_rank_in_course ('20250000000105',1,1)


---view Students Grads
execute viewstudentgrads 'DevOps'

-- display student status (fail & pass)
select * from get_student_result_with_name('20250000000102')

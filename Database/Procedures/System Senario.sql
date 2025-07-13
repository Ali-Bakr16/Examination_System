---S----Insert new Student 


Execute insertstudent '20202010105050','Aly','Hussien', '2002-04-05', 'aly12hussienaa@gmail.com', '01025536582', 'Minia','M','computers and information','Data Engineer','ITI_Minia'


--A---- Create Exam   
EXECUTE CreateExam 201, 1,1,2,2,2,'corrective','13:00:00','14:00:00','2025-5-22',100

---- Time Validation
EXECUTE CreateExam 202,1,1,2,2,2,'normal','13:00:00','10:00:00','2025-5-22',100

---S---Assign Exam To Student

-----Return Error because enter wrong date and time

EXECUTE assignNormalExam '20250000000103','Data Analysis',2,'2025-06-02','09:00:00','11:00:00'

------- Run correct

execute assignNormalExam '10000000000009','DevOps',56,'2025-02-06','09:00:00','11:00:00'


----- Run correct

execute assignExamcorrective '10000000000009','DevOps',77,'2025-02-27','13:00:00','15:00:00'


----Return Error because the student dosen't take normal exam

execute assignExamcorrective '10000000000100','Database',2,'2025-05-22','01:00:00','02:30:00'





---A------ Correct Text Question

execute CorrectTextQuestion 80,'10000000000881',1239,'Answer 875',2

execute CorrectTextQuestion 88,'10000000000871',1233,'Answer 914',2



---R----Correct MCQ Question

---correct
Execute Correct_Mcq_Question '10000000000971', 69, 793,'histogram',1250,2

---wrong 

Execute Correct_Mcq_Question '10000000000771', 69, 793,'line',1250,2



--M--- Correct True False Answer


Execute Correct_TrueFalse_Question '10000000000891', 77, 833,'False',1250,2

------wrong True false answer

Execute Correct_TrueFalse_Question '10000000000891', 77, 833,'True',1250,2




---------------- calculate total degree

EXECUTE calculateTotalDegreePerCourse  '10000000000217',90, 11











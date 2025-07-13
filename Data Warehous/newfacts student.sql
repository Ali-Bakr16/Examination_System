create or alter view vvv as
select s.StudentID, s.StudentDOB, jf.JobID, co.CompanyID, jf.Job_Cost, jf.Job_Feedback, sco.Salary 'Student Salary' ,
		esc.ExamID, esc.Grade, cer.Certification_Hours,cer.CertificationID
from student s
full join examstudentcourse esc
on s.StudentID = esc.studentID
full join Student_Certification sce
on s.StudentID = sce.StudentID
full join Certification cer
on sce.CertificationID = cer.CertificationID
full join Student_JobFreelance sjf
on s.StudentID = sjf.StudentID
full join Job_Freelance jf
on jf.JobID = sjf.JobID
full join Student_Company sco
on sco.StudentID = s.StudentID
full join Company co
on co.CompanyID = sco.CompanyID
where s.StudentID is not null

select distinct studentid from vvv


select * from ITI_Fact_Student


create or alter view sv as
select s.StudentID, i.intake_id, b.Branch_ID, t.TrackID, e.ExamID, e.ExamDate
from student s
join BranchTrackStudent bts
on s.StudentID = bts.StudentID
join Track t
on t.TrackID = bts.TrackID
join BranchIntakeTrack bti
on bti.TrackID = t.TrackID
join branch b 
on b.Branch_ID = bti.Branch_ID
join branchintake bi
on bi.branch_id = b.Branch_ID
join intake i
on bi.intake_id = i.intake_id
join ExamStudentCourse esc
on esc.studentID = s.StudentID
join Exam e
on e.ExamID = esc.ExamID

select count(distinct StudentID), TrackID
from sv
group by TrackID



create or alter view iviv as
select i.InstructorID , i.HairDate, i.inst_DOB, i.inst_exp, i.Salary 'instructor salary', cis.CourseRate, cis.InstructorRate,
		c.CourseID, qp.Question_ID, mcq.McqID, tf.trfaid, tex.TextID, b.Branch_ID, eiq.ExamID
from Instructor i
 join CourseInstructorStudent cis
on i.InstructorID = cis.InstructorID
 join course c
on cis.CourseID = c.CourseID
 join TrackCourse ts
on ts.courseid = c.CourseID
 join Track t
on t.TrackID = ts.trackid
 join BranchIntakeTrack bti
on t.TrackID = bti.TrackID
 join branch b 
on b.Branch_ID = bti.Branch_ID
 join ExamInstructorQuestion eiq
on i.InstructorID = eiq.InstructorID
 join Question_pool qp
on eiq.QuestionID = qp.Question_ID
 join McqQuestion mcq
on mcq.Question_ID = qp.Question_ID
 join truefalsequestion tf
on tf.question_id = qp.Question_ID
 join TextQuestion tex
on tex.Question_ID = qp.Question_ID


select count(distinct ExamID), Branch_ID 
from iviv
group by Branch_ID






select e.ExamID,
		i.Salary'InstructorSalary', i.HairDate, i.inst_DOB, i.inst_exp,
		cis.CourseRate, cis.InstructorRate,
		c.CourseEndDate, c.CourseStartDate,
		esc.Grade,
		s.StudentDOB,
		jf.Job_Cost, jf.Job_Feedback,
		sco.Salary 'StudentSalary',
		cr.Certification_Hours,
		i.InstructorID, s.StudentID,c.CourseID,jf.JobID, cr.CertificationID,tr.TrackID, b.Branch_ID, it.intake_id, co.CompanyID
from Exam e
join InstructorCourseExam ice
on e.ExamID = ice.ExamID

join Instructor i
on ice.InstructorID = i.InstructorID

join CourseInstructorStudent cis
on i.InstructorID = cis.InstructorID

join course c
on cis.CourseID = c.CourseID

join ExamStudentCourse esc
on c.CourseID = esc.CourseID

join Student s
on esc.StudentID = s.StudentID

join Student_JobFreelance sj
on s.StudentID = sj.StudentID

join Job_Freelance jf
on sj.JobID = jf.JobID

join Student_Company sco
on s.StudentID = sco.StudentID

join Student_Certification sce
on s.StudentID = sce.StudentID
join Certification cr
on sce.CertificationID = cr.CertificationID

join TrackCourse tc
on tc.CourseID = c.CourseID

join Track tr
on tc.TrackID = tr.TrackID

join BranchIntakeTrack bti
on tr.TrackID = bti.TrackID

join branch b
on bti.Branch_ID = b.Branch_ID

join intake it
on bti.intake_id = it.intake_id

join Company co
on co.CompanyID = sco.CompanyID

INSERT INTO TrainingManager (ManagerID, ManagerFname, ManagerLname, ManagerEmail, ManagerPhone)
VALUES
	(1,'omar','Alaa','omaralaa22@gmail.com',01005587930),
	(2,'Hassan','Alaa','hassanlaa22@gmail.com',01004487930),
	(3,'Nada','Hany','nadahany11@gmail.com',01104487930),
    (4, 'Ahmed', 'Mohamed', 'ahmed.mohamed@gmail.com', 01012345678),
    (5, 'Sarah', 'Ali', 'sarah.ali@gmail.com', 01123456789),
    (6, 'Nada', 'Hany', 'nadahany11@gmail.com', 01104487930),
    (7, 'Omar', 'Ibrahim', 'omar.ibrahim@gmail.com', 01234567890),
    (8, 'Laila', 'Mahmoud', 'laila.mahmoud@gmial.com', 01098765432),
    (9, 'Karim', 'Samy', 'karim.samy@gmail.com', 01111223344),
    (10, 'Yara', 'Hassan', 'yara.hassan@gmail.com', 01055667788),
    (11, 'Tarek', 'Nasser', 'tarek.nasser@gmail.com', 01122334455),
    (12, 'Mona', 'Adel', 'mona.adel@example.com', 01233445566),
    (13, 'Hossam', 'Fawzy', 'hossam.fawzy@gmail.com', 01066778899),
    (14, 'Dalia', 'Wael', 'dalia.wael@gmail.com', 01144556677),
    (15, 'Amr', 'Khaled', 'amr.khaled@gmail.com', 01277889900)
 

 ----------------------------------------------------------------

INSERT INTO branch(Branch_Name,Branch_Address, Branch_Phone,ManagerID)
VALUES
	('Alexandria', 'Alexandria', '01000222684', 2),
	('Assuit', 'Assuit', '01000228574', 2),
	('Minia', 'Minia', '01122857711', 1),
    ('Assuit', 'Assuit', '01000228574', 2),
    ('Cairo', 'Downtown Cairo', '01000228575', 3),
    ('Alexandria', 'Al Attarin', '01000228576', 1),
    ('Luxor', 'Karnak', '01000228577', 4),
    ('Aswan', 'Elephantine', '01000228578', 5),
    ('Giza', 'Pyramids District', '01000228579', 6),
    ('Port Said', 'Al Manakh', '01000228580', 7),
    ('Suez', 'Al Arbaeen', '01000228581', 8),
    ('Ismailia', 'Al Qahera', '01000228582', 9),
    ('Mansoura', 'Al Gomhuria', '01000228583', 10),
    ('Tanta', 'Al Mahalla', '01000228584', 11),
    ('Zagazig', 'Al Hussein', '01000228585', 12),
    ('Damietta', 'Al Raswa', '01000228586', 13);


-----------------------------------------------------------------------


INSERT INTO intake(intake_name,intake_start_date,intake_end_date)
VALUES 
	( '40', '2025-01-01', '2025-06-30'),
	( '41', '2025-07-01', '2025-12-31'),
	( '42', '2026-01-01', '2026-06-30'),
    ('25', '2015-01-05', '2015-06-30'),  
    ('26', '2015-07-01', '2015-12-20'),  
    ('27', '2016-01-10', '2016-06-30'),
    ('28', '2016-07-05', '2016-12-15'),   
    ('29', '2017-01-15', '2017-06-25'),
    ('30', '2017-08-01', '2018-01-10'),   
    ('31', '2018-02-01', '2018-07-31'),
    ('32', '2018-09-10', '2019-03-10'), 
    ('33', '2019-04-01', '2019-09-30'),
    ('34', '2019-10-15', '2020-04-15'),  
    ('35', '2020-05-01', '2020-11-30'),   
    ('36', '2021-01-10', '2021-06-30'),   
    ('37', '2021-07-01', '2021-12-31')   


	-------------------------------------------------------------------

INSERT INTO branchintake(branch_id,intake_id)
VALUES
    (3, 5), (3, 6),
    (4, 7), (4, 8),
    (5, 9), (5, 10),
    (6, 11), (6, 12),
    (7, 13), (7, 14),
    (8, 15), (8, 1),
    (9, 2), (9, 3),
    (10, 4), (10, 5),(7, 8);


-----------------------------------------------------------------------
INSERT INTO Department(DeptName)
VALUES ( 'Electrical Engineering'),
    ('Business Administration'),
    ('Mechanical Engineering'),
    ('Computer Science'),
    ('Civil Engineering'),
    ('Information Technology'),
    ('Electronics Engineering'),
    ('Automotive Technology'),
    ('Industrial Maintenance'),
    ('Welding Technology'),
    ('Plumbing Technology'),
    ('HVAC Systems'),
    ('Renewable Energy'),
    ('Mechatronics'),
    ('Telecommunications'),
    ('Construction Management');

	------------------------------------------------------


INSERT INTO Track(TrackID, TrackName, DeptID)
VALUES
    (4, 'Machine Learning', 12),        
    (3, 'Network Security', 13),          
    (6, 'Power Systems', 14),             
    (7, 'Financial Analytics', 7),       
    (8, 'Business Analytics', 10),        
    (9, 'Automotive Robotics', 5),      
    (10, 'Structural Engineering', 6),    
    (11, 'Embedded Systems', 2),          
    (12, 'Electric Vehicle Tech', 8),     
    (13, 'Predictive Maintenance', 9),   
    (14, 'Pipeline Welding', 15),       
    (15, 'Smart Building Systems', 11),
	(1, 'Machine Learning', 3),
	(2, 'Network Security', 2),
	(5, 'Business Analytics', 4)

-------------------------------------------------------------


INSERT INTO DepartmentTrack(DeptID,TrackID)
VALUES(3, 15), (3, 6), 
		(3, 9),(2, 2), 
		(2, 8), (2, 15),  
		(10, 3), (9, 10),          
		(5, 4), (5, 11),           
		(7, 13), (7, 15),
		(2, 5), (3, 1),  
		(4, 2);; 

		------------------------------------------------------------------------

INSERT INTO Course ( CourseName, CourseStartDate,CourseEndDate, CourseDescription)
VALUES
    ( 'Data Analysis', '2025-09-01', '2025-12-01', 'Data manipulation, analysis, and visualization'),
    ( 'Machine Learning', '2025-10-15', '2026-01-15', 'Supervised learning, model evaluation, Python'),
    ( 'Web Development', '2025-08-10', '2025-11-10', 'HTML, CSS, JavaScript, React'),
    ( 'Cybersecurity', '2025-09-20', '2026-02-20', 'Ethical hacking, network security, encryption'),
    ( 'Cloud Computing', '2025-11-01', '2026-02-01', 'AWS, Azure, cloud architecture'),
    ( 'Digital Marketing', '2025-10-01', '2026-01-01', 'SEO, social media, content strategy'),
    ( 'Python Programming', '2025-08-15', '2025-11-15', 'Python basics, OOP, automation'),
    ( 'Data Science', '2025-12-01', '2026-03-01', 'Statistics, SQL, predictive modeling'),
    ( 'UX/UI Design', '2025-09-05', '2025-12-05', 'Figma, wireframing, user research'),
    ( 'Blockchain', '2025-11-10', '2026-04-10', 'Smart contracts, Ethereum, Solidity'),
    ( 'DevOps', '2025-10-20', '2026-01-20', 'Docker, Kubernetes, CI/CD pipelines'),
    ( 'AI Ethics', '2025-09-15', '2025-12-15', 'Bias, fairness, responsible AI'),
    ( 'iOS Development', '2025-08-25', '2025-11-25', 'Swift, Xcode, mobile app design'),
    ( 'Big Data', '2025-12-10', '2026-05-10', 'Hadoop, Spark, data pipelines'),
    ( 'Project Management', '2025-10-05', '2026-01-05', 'Agile, Scrum, risk management');


	------------------------------------------------------------------------------------------
INSERT INTO studentanswer (answer,iscorrect)
VALUES ( 'PPPPPHJGHGGF',1),
    ('ZXCVBNMASDFG', 0),
    ( 'QAZWSXEDCRFV', 1),
    ( 'TGBNHYUJMKIJ', 0),
    ( 'POLKIUJYHTGB', 1),
    ( 'VFRCDEXSWZAQ', 0),
    ( 'MKOLPIJNHUYG', 1),
    ( 'BGTYHNUMJIKO', 0),
    ( 'RFVCDEXSWZAQ', 1),
    ( 'YHNJUMIKOLPQ', 0),
    ( 'WZSXEDCRFVTG', 1),
    ( 'QAZXSWEDCVFR', 0),
    ( 'PLOKMIJNUHBY', 1),
    ( 'GVFCDRESXWAZ', 0),
    ( 'THGYJUMKILOP', 1)


	--------------------------------------------------------------------------------


INSERT INTO ExamQuestion(ExamID,QuestID,Question)
VALUES 
  
     (1, 1, 'What is the purpose of a primary key in a database table?'),
    (1, 2, 'Explain the difference between INNER JOIN and LEFT JOIN.'),
    (1, 3, 'What are ACID properties in database transactions?'),
    
    (2, 1, 'What does HTML stand for?'),
    (2, 2, 'How do you center a div element using CSS?'),
    (2, 3, 'What is the DOM in JavaScript?'),
    
    (3, 1, 'What is the difference between TCP and UDP?'),
    (3, 2, 'Explain what a subnet mask is used for.'),
    (3, 3, 'What port does HTTPS typically use?');


	----------------------------------------------------------------------

INSERT INTO Exam (ExamStartTime, ExamEndTime, ExamType, ExamDate)
VALUES 
( '09:00:00', '11:00:00', 'NORMAL', '2025-06-02'),
( '09:00:00', '11:00:00', 'NORMAL', '2025-06-03'),
( '09:00:00', '11:00:00', 'NORMAL', '2025-06-04'),
( '09:00:00', '11:00:00', 'NORMAL', '2025-06-05');


--------------------------------------------------------------------------

INSERT INTO Instructor (InstructorFname, InstructorLname, InstructorEmail, HairDate, InstructorPhone)
VALUES 
    ('Khaled', 'Omar', 'omar.khaled@gmail.com', '2023-04-05', '01033333333'),
    ('Nour', 'Ibrahim', 'nour.ibrahim@gmail.com', '2023-05-20', '01044444444'),
    ('Hassan', 'Kamal', 'hassan.kamal@gmail.com', '2023-06-15', '01055555555'),
    ('Laila', 'Adel', 'laila.adel@gmail.com', '2023-07-01', '01066666666'),
    ('Omar', 'Fathy', 'omar.fathy@gmail.com', '2023-08-10', '01077777777'),
    ('Dina', 'Mostafa', 'dina.mostafa@gmail.com', '2023-09-25', '01088888888'),
    ('Youssef', 'Mahmoud', 'youssef.mahmoud@gmail.com', '2023-10-30', '01099999999'),
	('Ahmed', 'Yousef', 'ahmed1@gmail.com', '2023-01-01', '01000000000'),
	('Ali', 'Yousef', 'ali2@gmail.com', '2024-03-01', '01000000000'),
	('Saher', 'Ahmed', 'saher3@gmail.com', '2025-04-01', '01000000000'),
	 ('Ali', 'Hassan', 'ali.hassan@gmail.com', '2023-02-15', '01011111111'),
	 ('Sara', 'Mohamed', 'sara.mohamed@gmail.com', '2023-03-10', '01022222222'),
	 ('Khaled', 'Omar', 'khaled.omar@gmail.com', '2023-04-05', '01033333333');


-------------------------------------------------------------------------------

INSERT INTO Question_pool (Question_Degree)
VALUES 
( 5),
( 10),
( 7),(2),(4),(6),(3),(5),(2),(4),(2),(1),(8),(7),(6),(5);

--------------------------------------------------------------------------------

INSERT INTO Student (StudentID, StudentFname, StudentLname, StudentEmail, StudentPhone, StudentDOB, StudentAddress)
VALUES 
('20250123400101', 'Ahmed', 'Mohamed', 'ahmed.mohamed@gamil.com', '01000000001', '2001-01-15', 'Cairo'),
('20250123400102', 'Sara', 'Ali', 'sara.ali@gamil.com', '01000000002', '2000-02-20', 'Giza'),
('20250123400103', 'Youssef', 'Ibrahim', 'youssef.ibrahim@gamil.com', '01000000003', '2002-03-25', 'Alexandria'),
('20250123400104', 'Mona', 'Hassan', 'mona.hassan@gamil.com', '01000000004', '2001-04-10', 'Cairo'),
('20250123400105', 'Omar', 'Tarek', 'omar.tarek@gamil.com', '01000000005', '2000-05-05', 'Mansoura'),
('20250123400106', 'Laila', 'Fathy', 'laila.fathy@gamil.com', '01000000006', '2003-06-30', 'Tanta'),
('20250123400107', 'Hani', 'Sami', 'hani.sami@gamil.com', '01000000007', '2002-07-07', 'Assiut'),
('20250412300108', 'Nada', 'Khaled', 'nada.khaled@gamil.com', '01000000008', '2001-08-18', 'Ismailia'),
('20250123400109', 'Kareem', 'Adel', 'kareem.adel@gamil.com', '01000000009', '2000-09-09', 'Zagazig'),
('20250123400110', 'Rana', 'Mostafa', 'rana.mostafa@gamil.com', '01000000010', '2003-10-12', 'Fayoum'),

('20250123000101', 'Ahmed', 'Mohamed', 'ahmed.mohamed@gamil.com', '01000000001', '2001-01-15', 'Cairo'),
('20250123000102', 'Sara', 'Ali', 'sara.ali@gamil.com', '01000000002', '2000-02-20', 'Giza'),
('20250123000103', 'Youssef', 'Ibrahim', 'youssef.ibrahim@gamil.com', '01000000003', '2002-03-25', 'Alexandria'),
('20250123000104', 'Mona', 'Hassan', 'mona.hassan@gamil.com', '01000000004', '2001-04-10', 'Cairo'),
('20250123000105', 'Omar', 'Tarek', 'omar.tarek@gamil.com', '01000000005', '2000-05-05', 'Mansoura'),
('20250123000106', 'Laila', 'Fathy', 'laila.fathy@gamil.com', '01000000006', '2003-06-30', 'Tanta'),
('20250123000107', 'Hani', 'Sami', 'hani.sami@gamil.com', '01000000007', '2002-07-07', 'Assiut'),
('20250012300108', 'Nada', 'Khaled', 'nada.khaled@gamil.com', '01000000008', '2001-08-18', 'Ismailia'),
('20250123000109', 'Kareem', 'Adel', 'kareem.adel@gamil.com', '01000000009', '2000-09-09', 'Zagazig'),
('20250123000110', 'Rana', 'Mostafa', 'rana.mostafa@gamil.com', '01000000010', '2003-10-12', 'Fayoum'),

('20250000000101', 'Ahmed', 'Mohamed', 'ahmed.mohamed@gamil.com', '01000000001', '2001-01-15', 'Cairo'),
('20250000000102', 'Sara', 'Ali', 'sara.ali@gamil.com', '01000000002', '2000-02-20', 'Giza'),
('20250000000103', 'Youssef', 'Ibrahim', 'youssef.ibrahim@gamil.com', '01000000003', '2002-03-25', 'Alexandria'),
('20250000000104', 'Mona', 'Hassan', 'mona.hassan@gamil.com', '01000000004', '2001-04-10', 'Cairo'),
('20250000000105', 'Omar', 'Tarek', 'omar.tarek@gamil.com', '01000000005', '2000-05-05', 'Mansoura'),
('20250000000106', 'Laila', 'Fathy', 'laila.fathy@gamil.com', '01000000006', '2003-06-30', 'Tanta'),
('20250000000107', 'Hani', 'Sami', 'hani.sami@gamil.com', '01000000007', '2002-07-07', 'Assiut'),
('20250000000108', 'Nada', 'Khaled', 'nada.khaled@gamil.com', '01000000008', '2001-08-18', 'Ismailia'),
('20250000000109', 'Kareem', 'Adel', 'kareem.adel@gamil.com', '01000000009', '2000-09-09', 'Zagazig'),
('20250000000110', 'Rana', 'Mostafa', 'rana.mostafa@gamil.com', '01000000010', '2003-10-12', 'Fayoum');

------------------------------------------------------------------

INSERT INTO MCQQuestion (mcqID, Question, CorrectAnswer, Question_ID)
VALUES
(30, 'Which SQL command is used to retrieve data from a database?', 'SELECT', 1),
(31, 'What does a PRIMARY KEY do in a table?', 'Uniquely identifies each record', 2),
(32, 'Which clause is used to filter results in SQL?', 'WHERE', 3),
(33, 'What is used to combine rows from two or more tables in SQL?', 'JOIN', 4),
(34, 'Which command is used to remove a table in SQL?', 'DROP TABLE', 5),
(35, 'What is the role of a FOREIGN KEY?', 'Links records between tables', 6),
(36, 'What does the acronym SQL stand for?', 'Structured Query Language', 7),
(37, 'Which normal form removes partial dependency?', 'Second Normal Form (2NF)', 8),
(38, 'Which SQL command is used to change existing data?', 'UPDATE', 9),
(39, 'What is a composite key in a relational database?', 'A key made of two or more columns', 10),
(33, 'Which SQL statement is used to update data in a table?', 'UPDATE', 11),
(34, 'What SQL command is used to delete records from a table?', 'DELETE',12),
(35, 'What is the purpose of a FOREIGN KEY in SQL?', 'Establishes relationships between tables', 13),
(36, 'Which SQL command is used to create a new table?', 'CREATE TABLE', 14),
(37, 'Which function returns the number of rows in a query result?', 'COUNT', 15),
(38, 'Which SQL statement is used to insert new data into a table?', 'INSERT', 16),
(39, 'What does the ALTER TABLE command do in SQL?', 'Modifies an existing table structure', 17),
(40, 'Which clause is used to filter aggregated records in SQL?', 'HAVING', 18),
(41, 'What does the ORDER BY clause do?', 'Sorts results based on specified columns', 19),
(42, 'Which keyword is used to eliminate duplicate rows in a query?', 'DISTINCT', 20),
(43, 'Which operator is used for pattern matching in SQL?', 'LIKE', 21),
(44, 'What does the BETWEEN operator do in SQL?', 'Filters results within a specified range', 22),
(45, 'Which SQL keyword is used to combine the results of two queries?', 'UNION', 23),
(46, 'What is the purpose of the TOP clause in SQL Server?', 'Limits the number of rows returned', 24),
(47, 'Which aggregate function calculates the sum of a numeric column?', 'SUM', 25),
(48, 'Which SQL function returns the current date and time?', 'GETDATE()', 26),
(49, 'Which clause is used to group rows that have the same values?', 'GROUP BY', 27),
(50, 'Which SQL operator is used for logical conjunction?', 'AND', 28),
(51, 'Which function returns the maximum value in a column?', 'MAX', 29),
(52, 'Which function returns the minimum value in a column?', 'MIN', 30),
(53, 'Which SQL command is used to remove a table and all its data?', 'DROP TABLE', 31),
(54, 'Which clause is used to join two tables in a query?', 'JOIN', 32),
(55, 'Which join returns all rows from the left table and matching rows from the right table?', 'LEFT JOIN', 33),
(56, 'How do you add a new column to an existing table?', 'ALTER TABLE ADD COLUMN', 34),
(57, 'Which keyword is used to define a temporary table in SQL Server?', 'CREATE TABLE #temp', 35);

----------------------------------------------------------------------------------------------

INSERT INTO McqAnswer(McqID, AnswerID, Answer1, Answer2, Answer3, Answer4)
VALUES 

(30, 30, 'SELECT', 'INSERT', 'DELETE', 'UPDATE'),
(31, 31, 'Stores duplicate rows', 'Increases performance', 'Creates indexes', 'Uniquely identifies each record'),
(32, 32, 'HAVING', 'GROUP BY', 'WHERE', 'ORDER BY'),
(33, 33, 'MERGE', 'JOIN', 'GROUP', 'COMBINE'),
(34, 34, 'DELETE', 'REMOVE', 'DROP TABLE', 'TRUNCATE'),
(35, 35, 'Creates new records', 'Links records between tables', 'Sorts data', 'Indexes columns'),
(36, 36, 'Standard Question Language', 'Simple Query Language', 'Structured Query Language', 'Sequential Query Logic'),
(37, 37, '1NF', '2NF', '3NF', 'BCNF'),
(38, 38, 'SELECT', 'UPDATE', 'ALTER', 'INSERT'),
(39, 39, 'A key made of two or more columns', 'A key with nulls', 'A unique constraint', 'A table constraint'),
(40, 40, 'HAVING', 'WHERE', 'ORDER BY', 'GROUP BY'),
(41, 41, 'Sorts results based on specified columns', 'Filters results', 'Groups rows', 'Joins tables'),
(42, 42, 'DISTINCT', 'UNIQUE', 'ALL', 'GROUP'),
(43, 43, 'LIKE', 'MATCH', 'SIMILAR', 'REGEXP'),
(44, 44, 'Filters results within a specified range', 'Sorts results', 'Joins two ranges', 'Calculates the difference'),
(45, 45, 'UNION', 'JOIN', 'INTERSECT', 'MERGE'),
(46, 46, 'Limits the number of rows returned', 'Specifies the order of rows', 'Filters results', 'Aggregates rows'),
(47, 47, 'SUM', 'COUNT', 'MAX', 'AVG'),
(48, 48, 'GETDATE()', 'CURRENT_TIMESTAMP', 'NOW()', 'SYSDATETIME()'),
(49, 49, 'GROUP BY', 'ORDER BY', 'HAVING', 'PARTITION BY'),
(50, 50, 'AND', 'OR', 'NOT', 'XOR'),
(51, 51, 'MAX', 'MIN', 'SUM', 'AVG'),
(52, 52, 'MIN', 'MAX', 'COUNT', 'SUM'),
(53, 53, 'DROP TABLE', 'DELETE', 'TRUNCATE', 'ALTER TABLE'),
(54, 54, 'JOIN', 'MERGE', 'UNION', 'INTERSECT'),
(55, 55, 'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN', 'INNER JOIN'),
(56, 56, 'ALTER TABLE ADD COLUMN', 'INSERT COLUMN', 'MODIFY TABLE ADD', 'UPDATE TABLE'),
(57, 57, 'CREATE TABLE #temp', 'CREATE TEMPORARY TABLE', 'DECLARE TABLE', 'SELECT INTO #temp');


----------------------------------------------------------------------------------

INSERT INTO TrueFalseQuestion (Question, CorrectAnswer, Question_ID)
VALUES
('A primary key can contain NULL values.', 'False', 1),
('Each table must have a primary key.', 'True', 2),
('A foreign key enforces referential integrity.', 'True', 3),
('SQL stands for Structured Question Language.', 'False', 4),
('Normalization reduces redundancy.', 'True', 5),
('SELECT is used to insert data.', 'False', 6),
('UPDATE modifies records.', 'True', 7),
('A table can have two primary keys.', 'False', 8),
('An index improves retrieval.', 'True', 9),
('A view stores data permanently.', 'False', 10);

---------------------------------------------------------------------------

INSERT INTO TrueFalseAnswer (TrFaID, Answer1, Answer2)
VALUES 
(1, 'True', 'False'),
(2, 'True', 'False'),
(3, 'True', 'False'),
(4, 'True', 'False'),
(5, 'True', 'False'),
(6, 'True', 'False'),
(7,'True', 'False'),
(8,'True', 'False'),
(9,'True', 'False'),
(10, 'True', 'False');

------------------------------------------------------------------

INSERT INTO TextQuestion (Question, CorrectAnswer, Question_id)
VALUES 
('What is the role of a database index?', 'Improves search performance', 1),
('What is database normalization?', 'Process of organizing data to reduce redundancy', 2),
('What is the function of a primary key in a database?', 'Uniquely identifies a record', 3),
('What is the purpose of a foreign key in a database?', 'Ensures referential integrity', 4),
('What does the SQL SELECT statement do?', 'Retrieves data from one or more tables', 5),
('Why is data integrity important in databases?', 'Ensures accuracy and consistency of data', 6),
('What is a composite key in database design?', 'A key made up of two or more columns', 7),
('How does a view differ from a table in SQL?', 'A view is a virtual table based on a query', 8),
('What is a transaction in the context of databases?', 'A sequence of operations performed as a single unit of work', 9),
('What is the purpose of SQL constraints like UNIQUE and NOT NULL?', 'They enforce rules at the column level to ensure valid data', 10);


--------------------------------------------------------------------------------


INSERT INTO CourseInstructor(InstructorID, CourseID)
VALUES
(12,12) ,(15,1) ,(11,4) ,(9,3) ,(12,4) ,(3,2) ,(3,12) 
,(2,2) ,(2,12) ,(15,14) ,(1,15) ,(12,5) ,(9,13) ,(6,6) ,
(1,2),(2,3),(3,5) ,(4,5) ,(2,9) ,(9,8) ,(5,5) ,
(10,8) ,(11,12) ,(3,1) ,(4,9) ,(6,8) ,(10,11) ,(12,10)


---------------------------------------------------------------------------------

INSERT INTO StudentAnswer (Answer, IsCorrect)
VALUES
('Answer B', 0),
('Answer C', 1),
('Answer A', 1),
('Answer C', 1),
('Answer B', 1),
('Answer C', 1),
('Answer A', 1);

----------------------------------------------------------------------------------

INSERT INTO ExamInstructorQuestion (ExamID, InstructorID, QuestionID)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(1, 5, 5),
(2, 6, 6),
(3, 9, 7),
(4, 10, 8),
(1, 11, 9),
(2, 12, 10),
(3, 13, 11),
(4, 14, 12),
(1, 15, 13),
(2, 1, 14),
(3, 2, 15),
(4, 3, 16),
(1, 4, 17),
(2, 5, 18),
(3, 6, 19),
(4, 9, 20),
(1, 10, 21),
(2, 11, 22),
(3, 12, 23),
(4, 13, 24),
(1, 14, 25),
(2, 15, 26),
(3, 1, 27),
(4, 2, 28),
(1, 3, 29),
(2, 4, 30),
(3, 5, 31),
(4, 6, 32),
(2, 10, 34),
(3, 11, 35),
(4, 12, 1),
(1, 13, 2),
(2, 14, 3),
(3, 15, 4),
(4, 1, 5),
(1, 2, 6),
(2, 3, 7),
(3, 4, 8),
(4, 5, 9),
(1, 6, 10),
(2, 9, 11),
(3, 10, 12),
(4, 11, 13),
(1, 12, 14),
(2, 13, 15),
(3, 14, 16),
(4, 15, 17),
(1, 9, 18),


-----------------------------------------------------------------------------------

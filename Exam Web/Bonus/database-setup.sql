-- ITI Examination System Database Setup Script
-- For Microsoft SQL Server

-- Create Database (if not exists)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ITIExaminationDB')
BEGIN
    CREATE DATABASE ITIExaminationDB;
END
GO

USE ITIExaminationDB;
GO

-- Create Users table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
BEGIN
    CREATE TABLE Users (
        UserID INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(255) UNIQUE NOT NULL,
        Password NVARCHAR(255) NOT NULL,
        Name NVARCHAR(255) NOT NULL,
        Role NVARCHAR(50) NOT NULL CHECK (Role IN ('student', 'instructor', 'training-manager')),
        Department NVARCHAR(100),
        CreatedAt DATETIME DEFAULT GETDATE(),
        UpdatedAt DATETIME DEFAULT GETDATE(),
        IsActive BIT DEFAULT 1
    );
END
GO

-- Create Exams table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Exams' AND xtype='U')
BEGIN
    CREATE TABLE Exams (
        ExamID INT IDENTITY(1,1) PRIMARY KEY,
        Title NVARCHAR(255) NOT NULL,
        Subject NVARCHAR(100) NOT NULL,
        Description NVARCHAR(MAX),
        Duration INT NOT NULL, -- in minutes
        Difficulty NVARCHAR(20) CHECK (Difficulty IN ('Beginner', 'Intermediate', 'Advanced')),
        InstructorID INT,
        Status NVARCHAR(20) DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Active', 'Inactive')),
        CreatedAt DATETIME DEFAULT GETDATE(),
        UpdatedAt DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (InstructorID) REFERENCES Users(UserID)
    );
END
GO

-- Create Questions table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Questions' AND xtype='U')
BEGIN
    CREATE TABLE Questions (
        QuestionID INT IDENTITY(1,1) PRIMARY KEY,
        ExamID INT NOT NULL,
        QuestionText NVARCHAR(MAX) NOT NULL,
        QuestionType NVARCHAR(20) NOT NULL CHECK (QuestionType IN ('multiple-choice', 'true-false', 'short-answer')),
        Options NVARCHAR(MAX), -- JSON string for multiple choice options
        CorrectAnswer NVARCHAR(MAX) NOT NULL,
        Points INT DEFAULT 1,
        CreatedAt DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
    );
END
GO

-- Create ExamResults table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ExamResults' AND xtype='U')
BEGIN
    CREATE TABLE ExamResults (
        ResultID INT IDENTITY(1,1) PRIMARY KEY,
        ExamID INT NOT NULL,
        StudentID INT NOT NULL,
        Score DECIMAL(5,2) NOT NULL,
        TotalQuestions INT NOT NULL,
        CorrectAnswers INT NOT NULL,
        TimeTaken INT, -- in minutes
        SubmittedAt DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
        FOREIGN KEY (StudentID) REFERENCES Users(UserID)
    );
END
GO

-- Insert default users (passwords are hashed with PHP password_hash)
-- Note: These are sample hashed passwords. In production, use proper password hashing.

-- Insert Student
IF NOT EXISTS (SELECT * FROM Users WHERE Email = 'student@iti.gov.eg')
BEGIN
    INSERT INTO Users (Email, Password, Name, Role, Department)
    VALUES (
        'student@iti.gov.eg',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: student123
        'Ahmed Student',
        'student',
        'Programming'
    );
END

-- Insert Instructor
IF NOT EXISTS (SELECT * FROM Users WHERE Email = 'instructor@iti.gov.eg')
BEGIN
    INSERT INTO Users (Email, Password, Name, Role, Department)
    VALUES (
        'instructor@iti.gov.eg',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: instructor123
        'Dr. Sarah Instructor',
        'instructor',
        'Programming'
    );
END

-- Insert Training Manager
IF NOT EXISTS (SELECT * FROM Users WHERE Email = 'manager@iti.gov.eg')
BEGIN
    INSERT INTO Users (Email, Password, Name, Role, Department)
    VALUES (
        'manager@iti.gov.eg',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: manager123
        'Mr. Mohamed Manager',
        'training-manager',
        'Management'
    );
END

-- Insert sample exams
IF NOT EXISTS (SELECT * FROM Exams WHERE Title = 'JavaScript Fundamentals')
BEGIN
    INSERT INTO Exams (Title, Subject, Description, Duration, Difficulty, InstructorID, Status)
    VALUES (
        'JavaScript Fundamentals',
        'Programming',
        'Basic JavaScript concepts including variables, functions, and DOM manipulation',
        60,
        'Beginner',
        (SELECT UserID FROM Users WHERE Email = 'instructor@iti.gov.eg'),
        'Active'
    );
END

IF NOT EXISTS (SELECT * FROM Exams WHERE Title = 'Database Management')
BEGIN
    INSERT INTO Exams (Title, Subject, Description, Duration, Difficulty, InstructorID, Status)
    VALUES (
        'Database Management',
        'Database',
        'SQL Server database design and management concepts',
        90,
        'Intermediate',
        (SELECT UserID FROM Users WHERE Email = 'instructor@iti.gov.eg'),
        'Active'
    );
END

-- Insert sample questions
IF NOT EXISTS (SELECT * FROM Questions WHERE QuestionText LIKE '%JavaScript%')
BEGIN
    INSERT INTO Questions (ExamID, QuestionText, QuestionType, Options, CorrectAnswer, Points)
    VALUES 
    (
        (SELECT ExamID FROM Exams WHERE Title = 'JavaScript Fundamentals'),
        'What is the correct way to declare a variable in JavaScript?',
        'multiple-choice',
        '["var x = 5;", "variable x = 5;", "v x = 5;", "declare x = 5;"]',
        'var x = 5;',
        1
    ),
    (
        (SELECT ExamID FROM Exams WHERE Title = 'JavaScript Fundamentals'),
        'JavaScript is a case-sensitive language.',
        'true-false',
        NULL,
        'true',
        1
    );
END

-- Insert sample exam results
IF NOT EXISTS (SELECT * FROM ExamResults WHERE StudentID = (SELECT UserID FROM Users WHERE Email = 'student@iti.gov.eg'))
BEGIN
    INSERT INTO ExamResults (ExamID, StudentID, Score, TotalQuestions, CorrectAnswers, TimeTaken)
    VALUES 
    (
        (SELECT ExamID FROM Exams WHERE Title = 'JavaScript Fundamentals'),
        (SELECT UserID FROM Users WHERE Email = 'student@iti.gov.eg'),
        85.00,
        20,
        17,
        45
    );
END

-- Create indexes for better performance
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Role ON Users(Role);
CREATE INDEX IX_Exams_InstructorID ON Exams(InstructorID);
CREATE INDEX IX_Exams_Status ON Exams(Status);
CREATE INDEX IX_Questions_ExamID ON Questions(ExamID);
CREATE INDEX IX_ExamResults_StudentID ON ExamResults(StudentID);
CREATE INDEX IX_ExamResults_ExamID ON ExamResults(ExamID);

-- Create views for common queries
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_UserSummary' AND xtype='V')
BEGIN
    EXEC('CREATE VIEW vw_UserSummary AS
        SELECT 
            u.UserID,
            u.Name,
            u.Email,
            u.Role,
            u.Department,
            u.CreatedAt,
            u.UpdatedAt,
            CASE 
                WHEN u.Role = ''student'' THEN 
                    (SELECT COUNT(*) FROM ExamResults er WHERE er.StudentID = u.UserID)
                ELSE 0 
            END as ExamsTaken,
            CASE 
                WHEN u.Role = ''student'' THEN 
                    (SELECT AVG(er.Score) FROM ExamResults er WHERE er.StudentID = u.UserID)
                ELSE 0 
            END as AverageScore
        FROM Users u
        WHERE u.IsActive = 1');
END
GO

-- Create stored procedures
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GetUserByEmail' AND xtype='P')
BEGIN
    EXEC('CREATE PROCEDURE sp_GetUserByEmail
        @Email NVARCHAR(255)
    AS
    BEGIN
        SELECT UserID, Email, Password, Name, Role, Department, IsActive
        FROM Users 
        WHERE Email = @Email AND IsActive = 1
    END');
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GetUserExams' AND xtype='P')
BEGIN
    EXEC('CREATE PROCEDURE sp_GetUserExams
        @UserID INT,
        @Role NVARCHAR(50)
    AS
    BEGIN
        IF @Role = ''student''
        BEGIN
            SELECT e.*, er.Score, er.SubmittedAt
            FROM Exams e
            INNER JOIN ExamResults er ON e.ExamID = er.ExamID
            WHERE er.StudentID = @UserID
            ORDER BY er.SubmittedAt DESC
        END
        ELSE IF @Role = ''instructor''
        BEGIN
            SELECT e.*, 
                   (SELECT COUNT(*) FROM ExamResults er WHERE er.ExamID = e.ExamID) as StudentCount,
                   (SELECT AVG(er.Score) FROM ExamResults er WHERE er.ExamID = e.ExamID) as AverageScore
            FROM Exams e
            WHERE e.InstructorID = @UserID
            ORDER BY e.CreatedAt DESC
        END
    END');
END
GO

PRINT 'Database setup completed successfully!';
PRINT 'Default users created:';
PRINT '- student@iti.gov.eg (password: student123)';
PRINT '- instructor@iti.gov.eg (password: instructor123)';
PRINT '- manager@iti.gov.eg (password: manager123)';
GO 
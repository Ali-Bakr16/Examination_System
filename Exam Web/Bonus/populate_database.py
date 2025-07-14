#!/usr/bin/env python3
"""
Script to populate the SQL Server database with questions from CSV file
"""

import csv
import json
from app import app, db, User, Exam, Question
from werkzeug.security import generate_password_hash
import datetime

def populate_database():
    """Populate the database with questions from CSV file"""
    
    with app.app_context():
        print("🚀 Starting database population...")
        
        # Create tables if they don't exist
        db.create_all()
        
        # Insert default users if they don't exist
        default_users = [
            {
                'email': 'student@iti.gov.eg',
                'password': 'student123',
                'name': 'Ahmed Student',
                'role': 'student',
                'department': 'Programming'
            },
            {
                'email': 'instructor@iti.gov.eg',
                'password': 'instructor123',
                'name': 'Dr. Sarah Instructor',
                'role': 'instructor',
                'department': 'Programming'
            },
            {
                'email': 'manager@iti.gov.eg',
                'password': 'manager123',
                'name': 'Mr. Mohamed Manager',
                'role': 'training-manager',
                'department': 'Management'
            }
        ]
        
        print("👥 Creating default users...")
        for user_data in default_users:
            existing_user = User.query.filter_by(Email=user_data['email']).first()
            if not existing_user:
                hashed_password = generate_password_hash(user_data['password'])
                new_user = User(
                    Email=user_data['email'],
                    Password=hashed_password,
                    Name=user_data['name'],
                    Role=user_data['role'],
                    Department=user_data['department']
                )
                db.session.add(new_user)
                print(f"   ✅ Created user: {user_data['email']}")
            else:
                print(f"   ⏭️  User already exists: {user_data['email']}")
        
        db.session.commit()
        
        # Get instructor user for creating exams
        instructor = User.query.filter_by(Email='instructor@iti.gov.eg').first()
        if not instructor:
            print("❌ Instructor user not found. Cannot create exams.")
            return
        
        # Create sample exams if they don't exist
        print("📝 Creating sample exams...")
        
        # Programming MCQ Exam
        programming_exam = Exam.query.filter_by(Title='Programming MCQ Exam').first()
        if not programming_exam:
            programming_exam = Exam(
                Title='Programming MCQ Exam',
                Subject='Programming',
                Description='Comprehensive programming questions covering multiple languages and concepts',
                Duration=60,
                Difficulty='Intermediate',
                InstructorID=instructor.UserID,
                Status='Active'
            )
            db.session.add(programming_exam)
            db.session.flush()  # Get the ExamID
            print("   ✅ Created Programming MCQ Exam")
        else:
            print("   ⏭️  Programming MCQ Exam already exists")
        
        # Database Management Exam
        database_exam = Exam.query.filter_by(Title='Database Management').first()
        if not database_exam:
            database_exam = Exam(
                Title='Database Management',
                Subject='Database',
                Description='SQL Server database design and management concepts',
                Duration=90,
                Difficulty='Intermediate',
                InstructorID=instructor.UserID,
                Status='Active'
            )
            db.session.add(database_exam)
            db.session.flush()  # Get the ExamID
            print("   ✅ Created Database Management Exam")
        else:
            print("   ⏭️  Database Management Exam already exists")
        
        db.session.commit()
        
        # Read questions from CSV file and add to database
        print("📚 Reading questions from CSV file...")
        questions_added = 0
        
        try:
            with open('programming_mcq_questions.csv', newline='', encoding='utf-8') as csvfile:
                reader = csv.DictReader(csvfile)
                
                for row in reader:
                    # Check if question already exists
                    existing_question = Question.query.filter_by(
                        QuestionText=row['Question']
                    ).first()
                    
                    if not existing_question:
                        # Create options array
                        options = [
                            row['OptionA'],
                            row['OptionB'], 
                            row['OptionC'],
                            row['OptionD']
                        ]
                        
                        # Create new question
                        new_question = Question(
                            ExamID=programming_exam.ExamID,
                            QuestionText=row['Question'],
                            QuestionType='multiple-choice',
                            Options=json.dumps(options),
                            CorrectAnswer=row['CorrectAnswer'],
                            Points=1
                        )
                        
                        db.session.add(new_question)
                        questions_added += 1
                        
                        if questions_added % 10 == 0:
                            print(f"   📝 Added {questions_added} questions...")
                
                db.session.commit()
                print(f"   ✅ Successfully added {questions_added} questions to database")
                
        except FileNotFoundError:
            print("❌ CSV file not found: programming_mcq_questions.csv")
            return
        except Exception as e:
            print(f"❌ Error reading CSV file: {str(e)}")
            return
        
        # Add some sample questions for Database Management exam
        print("🗄️  Adding sample database questions...")
        db_questions = [
            {
                'question': 'What is the primary key in a database table?',
                'options': ['A unique identifier for each record', 'The first column in the table', 'A foreign key reference', 'An index on the table'],
                'correct': 'A unique identifier for each record'
            },
            {
                'question': 'Which SQL command is used to create a new table?',
                'options': ['CREATE TABLE', 'BUILD TABLE', 'MAKE TABLE', 'NEW TABLE'],
                'correct': 'CREATE TABLE'
            },
            {
                'question': 'What does ACID stand for in database transactions?',
                'options': ['Atomicity, Consistency, Isolation, Durability', 'Access, Control, Integrity, Data', 'Authentication, Control, Integrity, Durability', 'Atomicity, Control, Isolation, Data'],
                'correct': 'Atomicity, Consistency, Isolation, Durability'
            }
        ]
        
        for q_data in db_questions:
            existing_question = Question.query.filter_by(
                QuestionText=q_data['question']
            ).first()
            
            if not existing_question:
                new_question = Question(
                    ExamID=database_exam.ExamID,
                    QuestionText=q_data['question'],
                    QuestionType='multiple-choice',
                    Options=json.dumps(q_data['options']),
                    CorrectAnswer=q_data['correct'],
                    Points=1
                )
                db.session.add(new_question)
        
        db.session.commit()
        print("   ✅ Added sample database questions")
        
        # Print summary
        total_questions = Question.query.count()
        total_exams = Exam.query.count()
        total_users = User.query.count()
        
        print("\n📊 Database Population Summary:")
        print(f"   👥 Users: {total_users}")
        print(f"   📝 Exams: {total_exams}")
        print(f"   ❓ Questions: {total_questions}")
        print(f"   📚 New questions added: {questions_added}")
        print("\n✅ Database population completed successfully!")

if __name__ == '__main__':
    populate_database() 
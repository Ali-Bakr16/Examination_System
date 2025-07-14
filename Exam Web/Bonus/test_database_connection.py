#!/usr/bin/env python3
"""
Test script to verify SQL Server database connection
"""

from app import app, db
from config import get_config

def test_connection():
    """Test the database connection"""
    
    config = get_config()
    print("🔧 Database Configuration:")
    print(f"   Server: {config.DB_SERVER}")
    print(f"   Database: {config.DB_NAME}")
    print(f"   Username: {config.DB_USERNAME}")
    print(f"   Driver: {config.DB_DRIVER}")
    print()
    
    with app.app_context():
        try:
            # Test basic connection
            result = db.engine.execute('SELECT 1 as test')
            print("✅ Basic connection test: PASSED")
            
            # Test if tables exist
            tables = ['Users', 'Exams', 'Questions', 'ExamResults']
            for table in tables:
                try:
                    result = db.engine.execute(f'SELECT COUNT(*) FROM {table}')
                    count = result.fetchone()[0]
                    print(f"✅ Table '{table}' exists with {count} records")
                except Exception as e:
                    print(f"❌ Table '{table}' error: {str(e)}")
            
            # Test specific queries
            try:
                user_count = db.engine.execute('SELECT COUNT(*) FROM Users').fetchone()[0]
                exam_count = db.engine.execute('SELECT COUNT(*) FROM Exams').fetchone()[0]
                question_count = db.engine.execute('SELECT COUNT(*) FROM Questions').fetchone()[0]
                
                print(f"\n📊 Database Summary:")
                print(f"   Users: {user_count}")
                print(f"   Exams: {exam_count}")
                print(f"   Questions: {question_count}")
                
            except Exception as e:
                print(f"❌ Query test failed: {str(e)}")
            
            print("\n🎉 Database connection test completed successfully!")
            
        except Exception as e:
            print(f"❌ Database connection failed: {str(e)}")
            print("\n🔧 Troubleshooting tips:")
            print("   1. Make sure SQL Server is running")
            print("   2. Check your database credentials in config.py or .env file")
            print("   3. Verify ODBC driver is installed")
            print("   4. Ensure database 'ITIExaminationDB' exists")
            print("   5. Run 'database-setup.sql' to create tables")

if __name__ == '__main__':
    test_connection() 
# SQL Server Database Setup Guide

This guide will help you connect the ITI Examination System to your local SQL Server database.

## Prerequisites

1. **SQL Server** installed and running on your local machine
2. **Python** with required packages (see requirements.txt)
3. **ODBC Driver** for SQL Server

## Step 1: Install Required Python Packages

```bash
pip install -r requirements.txt
```

## Step 2: Configure Database Connection

### Option A: Using Environment Variables (Recommended)

Create a `.env` file in the project root:

```env
# Database Configuration
DB_SERVER=localhost
DB_NAME=ITIExaminationDB
DB_USERNAME=sa
DB_PASSWORD=your_sql_server_password
DB_DRIVER=ODBC+Driver+17+for+SQL+Server

# Flask Configuration
SECRET_KEY=your-secret-key-here
DEBUG=True
```

### Option B: Direct Configuration

Edit `config.py` and update the database settings:

```python
DB_SERVER = 'localhost'
DB_NAME = 'ITIExaminationDB'
DB_USERNAME = 'sa'
DB_PASSWORD = 'your_sql_server_password'
DB_DRIVER = 'ODBC+Driver+17+for+SQL+Server'
```

## Step 3: Create Database

### Option A: Using SQL Server Management Studio (SSMS)

1. Open SSMS and connect to your SQL Server instance
2. Run the `database-setup.sql` script to create the database and tables

### Option B: Using Command Line

```bash
# Connect to SQL Server and run the setup script
sqlcmd -S localhost -U sa -P your_password -i database-setup.sql
```

## Step 4: Install ODBC Driver

### Windows
Download and install the Microsoft ODBC Driver for SQL Server from Microsoft's website.

### Linux (Ubuntu/Debian)
```bash
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql17
```

### macOS
```bash
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
ACCEPT_EULA=Y brew install msodbcsql17
```

## Step 5: Populate Database

Run the database population script to add questions from the CSV file:

```bash
python populate_database.py
```

This script will:
- Create default users (student, instructor, manager)
- Create sample exams
- Import all questions from `programming_mcq_questions.csv`
- Add sample database questions

## Step 6: Test the Connection

Start the Flask application:

```bash
python app.py
```

The application should start without errors and connect to your SQL Server database.

## Step 7: Access the Exam Page

Open your browser and navigate to:
```
http://localhost:5000/exam.html
```

The exam page will now load questions from your SQL Server database instead of the CSV file.

## Troubleshooting

### Common Issues

1. **Connection Error**: Check your SQL Server credentials and make sure the service is running
2. **ODBC Driver Error**: Install the correct ODBC driver for your platform
3. **Database Not Found**: Run the `database-setup.sql` script to create the database
4. **Permission Error**: Make sure your SQL Server user has appropriate permissions

### Test Database Connection

You can test the database connection by running:

```python
from app import app, db
with app.app_context():
    try:
        db.engine.execute('SELECT 1')
        print("✅ Database connection successful!")
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
```

## Database Schema

The system uses the following tables:

- **Users**: User accounts (students, instructors, managers)
- **Exams**: Exam definitions
- **Questions**: Individual questions with options and correct answers
- **ExamResults**: Student exam results and scores

## Security Notes

1. Change default passwords in production
2. Use strong passwords for SQL Server accounts
3. Consider using Windows Authentication for better security
4. Restrict database user permissions to minimum required

## Next Steps

After successful setup:

1. Customize the exam questions in the database
2. Add more users and exams as needed
3. Configure additional security settings
4. Set up backup procedures for the database 
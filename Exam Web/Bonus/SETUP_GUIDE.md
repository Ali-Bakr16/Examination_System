# ITI Examination System - MS SQL Server Setup Guide

This guide will help you connect the ITI Examination System to your Microsoft SQL Server database.

## 📋 Prerequisites

Before starting, ensure you have:

1. **Microsoft SQL Server** (2016 or later)
2. **SQL Server Management Studio (SSMS)** or Azure Data Studio
3. **PHP** (7.4 or later) with SQL Server extensions
4. **Web Server** (Apache, IIS, or XAMPP)
5. **SQL Server Driver for PHP**

## 🗄️ Database Setup

### Step 1: Install SQL Server Driver for PHP

#### For Windows:
1. Download the Microsoft Drivers for PHP for SQL Server from Microsoft's website
2. Install the appropriate version for your PHP installation
3. Enable the `sqlsrv` and `pdo_sqlsrv` extensions in your `php.ini` file

#### For XAMPP:
1. Download the SQL Server drivers for your PHP version
2. Copy `php_sqlsrv.dll` and `php_pdo_sqlsrv.dll` to your PHP extensions directory
3. Add these lines to your `php.ini`:
   ```ini
   extension=php_sqlsrv.dll
   extension=php_pdo_sqlsrv.dll
   ```

### Step 2: Create Database

1. Open **SQL Server Management Studio**
2. Connect to your SQL Server instance
3. Run the `database-setup.sql` script:
   ```sql
   -- Execute the entire database-setup.sql file
   ```

Or manually create the database:
```sql
CREATE DATABASE ITIExaminationDB;
USE ITIExaminationDB;
```

### Step 3: Configure Database Connection

Edit the `config.php` file and update the connection settings:

```php
// Update these values in config.php
private $server = "localhost"; // Your SQL Server instance name
private $database = "ITIExaminationDB"; // Your database name
private $username = "sa"; // Your SQL Server username
private $password = "your_password"; // Your SQL Server password
```

#### Common Server Names:
- **Local SQL Server**: `localhost` or `(local)`
- **Named Instance**: `localhost\SQLEXPRESS`
- **Remote Server**: `server_name` or `IP_address`

## 🔧 Configuration Steps

### Step 1: Update Database Configuration

1. Open `config.php`
2. Update the connection parameters:
   ```php
   private $server = "your_server_name";
   private $database = "ITIExaminationDB";
   private $username = "your_username";
   private $password = "your_password";
   ```

### Step 2: Test Database Connection

Create a test file `test-connection.php`:

```php
<?php
require_once 'config.php';

try {
    $db = $dbConfig->getConnection();
    echo "Database connection successful!";
    
    // Test query
    $stmt = $db->query("SELECT COUNT(*) as count FROM Users");
    $result = $stmt->fetch();
    echo "<br>Users in database: " . $result['count'];
    
} catch (Exception $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>
```

### Step 3: Set Up Web Server

#### For XAMPP:
1. Copy all project files to `C:\xampp\htdocs\iti-examination\`
2. Start Apache in XAMPP Control Panel
3. Access: `http://localhost/iti-examination/demo.html`

#### For IIS:
1. Create a new website in IIS Manager
2. Point to your project directory
3. Configure PHP handler
4. Access: `http://your-domain/demo.html`

#### For Apache:
1. Place files in your web root directory
2. Ensure PHP is configured
3. Access: `http://localhost/demo.html`

## 🔐 Security Configuration

### Step 1: Create SQL Server Login

```sql
-- Create login for the application
CREATE LOGIN iti_app_user WITH PASSWORD = 'StrongPassword123!';

-- Create user in the database
USE ITIExaminationDB;
CREATE USER iti_app_user FOR LOGIN iti_app_user;

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON Users TO iti_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON Exams TO iti_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON Questions TO iti_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ExamResults TO iti_app_user;
```

### Step 2: Update Configuration with New Credentials

```php
// In config.php, use the new credentials
private $username = "iti_app_user";
private $password = "StrongPassword123!";
```

## 🧪 Testing the System

### Step 1: Test Database Connection

1. Open `test-connection.php` in your browser
2. Verify connection is successful
3. Check that default users are created

### Step 2: Test Authentication

1. Open `demo.html` in your browser
2. Try signing in with test credentials:
   - **Student**: `student@iti.gov.eg` / `student123`
   - **Instructor**: `instructor@iti.gov.eg` / `instructor123`
   - **Manager**: `manager@iti.gov.eg` / `manager123`

### Step 3: Test API Endpoints

Test the authentication API:
```bash
curl -X POST http://localhost/iti-examination/auth.php?action=signin \
  -H "Content-Type: application/json" \
  -d '{"email":"student@iti.gov.eg","password":"student123","role":"student"}'
```

## 📊 Database Schema

### Tables Created:

1. **Users** - User accounts and authentication
2. **Exams** - Examination definitions
3. **Questions** - Exam questions and answers
4. **ExamResults** - Student exam results

### Views Created:

1. **vw_UserSummary** - User statistics and performance

### Stored Procedures:

1. **sp_GetUserByEmail** - Get user by email
2. **sp_GetUserExams** - Get exams for user by role

## 🔍 Troubleshooting

### Common Issues:

#### 1. Connection Failed
**Error**: `Connection failed: Login failed for user`
**Solution**: 
- Verify username and password
- Check SQL Server authentication mode
- Ensure user has access to database

#### 2. Driver Not Found
**Error**: `Class 'PDO' not found`
**Solution**:
- Install SQL Server drivers for PHP
- Enable extensions in php.ini
- Restart web server

#### 3. Database Not Found
**Error**: `Database 'ITIExaminationDB' does not exist`
**Solution**:
- Run the database setup script
- Check database name in config.php
- Verify user has access to database

#### 4. Permission Denied
**Error**: `The user does not have permission to perform this action`
**Solution**:
- Grant appropriate permissions to database user
- Check SQL Server login configuration

### Debug Mode

Enable debug mode in `config.php`:

```php
// Add this to see detailed error messages
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

## 📈 Performance Optimization

### 1. Connection Pooling

Enable connection pooling in `config.php`:

```php
$this->connection = new PDO(
    "sqlsrv:Server={$this->server};Database={$this->database};ConnectionPooling=1",
    $this->username,
    $this->password,
    array(
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_PERSISTENT => true
    )
);
```

### 2. Index Optimization

The setup script creates indexes for better performance:
- Email index on Users table
- Role index on Users table
- Foreign key indexes on all tables

### 3. Query Optimization

Use stored procedures for complex queries:
```sql
EXEC sp_GetUserExams @UserID = 1, @Role = 'student'
```

## 🔄 Backup and Maintenance

### 1. Database Backup

```sql
-- Full backup
BACKUP DATABASE ITIExaminationDB 
TO DISK = 'C:\Backups\ITIExaminationDB.bak'
WITH FORMAT, INIT, COMPRESSION;

-- Differential backup
BACKUP DATABASE ITIExaminationDB 
TO DISK = 'C:\Backups\ITIExaminationDB_diff.bak'
WITH DIFFERENTIAL, COMPRESSION;
```

### 2. Regular Maintenance

```sql
-- Update statistics
UPDATE STATISTICS Users;
UPDATE STATISTICS Exams;
UPDATE STATISTICS Questions;
UPDATE STATISTICS ExamResults;

-- Rebuild indexes (run during maintenance window)
ALTER INDEX ALL ON Users REBUILD;
ALTER INDEX ALL ON Exams REBUILD;
```

## 📞 Support

If you encounter issues:

1. Check the error logs in your web server
2. Verify SQL Server error logs
3. Test database connection separately
4. Ensure all prerequisites are installed
5. Check file permissions for web server

## 🎯 Next Steps

After successful setup:

1. **Customize the system** - Modify styles and branding
2. **Add more users** - Create additional student and instructor accounts
3. **Create exams** - Use the instructor dashboard to create exams
4. **Monitor performance** - Use SQL Server Profiler for query optimization
5. **Implement security** - Add SSL certificates and additional security measures

---

**Congratulations!** Your ITI Examination System is now connected to MS SQL Server and ready to use. 
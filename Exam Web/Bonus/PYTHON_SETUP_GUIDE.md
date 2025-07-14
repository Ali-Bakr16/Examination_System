# ITI Examination System - Python Backend Setup Guide

This guide will help you set up the Python Flask backend for the ITI Examination System with SQL Server database integration.

## 📋 Prerequisites

Before starting, ensure you have:

1. **Python** (3.8 or later)
2. **Microsoft SQL Server** (2016 or later)
3. **SQL Server Management Studio (SSMS)** or Azure Data Studio
4. **ODBC Driver for SQL Server** (17 or later)
5. **Git** (optional, for version control)

## 🐍 Python Environment Setup

### Step 1: Install Python

Download and install Python from [python.org](https://www.python.org/downloads/)

### Step 2: Create Virtual Environment

```bash
# Create a virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# On macOS/Linux:
source venv/bin/activate
```

### Step 3: Install Dependencies

```bash
# Install required packages
pip install -r requirements.txt
```

## 🗄️ Database Configuration

### Step 1: Install ODBC Driver

Download and install the Microsoft ODBC Driver for SQL Server:
- [Windows](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server)
- [Linux](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server)

### Step 2: Verify Database Tables

Ensure your SQL Server database has the required tables. If not, run the `database-setup.sql` script:

```sql
-- Execute database-setup.sql in SQL Server Management Studio
-- This will create all necessary tables and sample data
```

### Step 3: Configure Database Connection

1. **Copy environment template**:
   ```bash
   copy env_template.txt .env
   ```

2. **Edit `.env` file** with your database credentials:
   ```env
   # Database Configuration
   DB_SERVER=localhost
   DB_NAME=ITIExaminationDB
   DB_USERNAME=sa
   DB_PASSWORD=your_password
   DB_DRIVER=ODBC+Driver+17+for+SQL+Server
   ```

#### Common Server Names:
- **Local SQL Server**: `localhost` or `(local)`
- **Named Instance**: `localhost\SQLEXPRESS`
- **Remote Server**: `server_name` or `IP_address`

## 🚀 Running the Application

### Step 1: Start the Flask Server

```bash
# Make sure virtual environment is activated
python app.py
```

The server will start on `http://localhost:5000`

### Step 2: Test the Backend

```bash
# Run the test script
python test_backend.py
```

### Step 3: Access the Frontend

1. Open `demo.html` in your web browser
2. Use the test credentials to sign in:
   - **Student**: `student@iti.gov.eg` / `student123`
   - **Instructor**: `instructor@iti.gov.eg` / `instructor123`
   - **Manager**: `manager@iti.gov.eg` / `manager123`

## 🔧 Configuration Options

### Environment Variables

Create a `.env` file in the project root:

```env
# Flask Configuration
SECRET_KEY=your-super-secret-key-change-this-in-production
FLASK_ENV=development
DEBUG=True

# Database Configuration
DB_SERVER=localhost
DB_NAME=ITIExaminationDB
DB_USERNAME=sa
DB_PASSWORD=your_password
DB_DRIVER=ODBC+Driver+17+for+SQL+Server

# JWT Configuration
JWT_SECRET_KEY=your-jwt-secret-key-change-this-in-production

# Application Configuration
HOST=0.0.0.0
PORT=5000

# CORS Configuration
CORS_ORIGINS=http://localhost:3000,http://127.0.0.1:3000

# Security Configuration
SESSION_COOKIE_SECURE=False
```

### Production Configuration

For production deployment:

```env
FLASK_ENV=production
DEBUG=False
SECRET_KEY=your-very-secure-secret-key
SESSION_COOKIE_SECURE=True
```

## 📊 API Endpoints

### Authentication
- `POST /api/auth/signin` - User sign in
- `GET /api/user/profile` - Get user profile (protected)
- `POST /api/user/change-password` - Change password (protected)

### Data
- `GET /api/exams` - Get exams (role-based)
- `GET /api/users` - Get users (training manager only)

### System
- `GET /api/health` - Health check

## 🔍 Troubleshooting

### Common Issues:

#### 1. Database Connection Failed
**Error**: `pyodbc.Error: ('01000', "[01000] unixODBC;...")`
**Solution**:
- Verify ODBC driver installation
- Check database credentials in `.env`
- Ensure SQL Server is running
- Test connection with SQL Server Management Studio

#### 2. Module Not Found
**Error**: `ModuleNotFoundError: No module named 'flask'`
**Solution**:
```bash
# Activate virtual environment
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# Install dependencies
pip install -r requirements.txt
```

#### 3. CORS Errors
**Error**: `Access to fetch at 'http://localhost:5000/api/auth/signin' from origin 'null' has been blocked by CORS policy`
**Solution**:
- Update `CORS_ORIGINS` in `.env` file
- Or set `CORS_ORIGINS=*` for development

#### 4. JWT Token Issues
**Error**: `Invalid token`
**Solution**:
- Check `JWT_SECRET_KEY` in `.env`
- Ensure token is being sent in Authorization header
- Verify token hasn't expired

### Debug Mode

Enable debug mode for detailed error messages:

```env
DEBUG=True
FLASK_ENV=development
```

## 🔒 Security Considerations

### 1. Environment Variables
- Never commit `.env` files to version control
- Use strong, unique secret keys
- Rotate keys regularly

### 2. Database Security
- Use dedicated database user (not sa)
- Grant minimum required permissions
- Enable SQL Server authentication logging

### 3. Production Deployment
- Use HTTPS in production
- Set `SESSION_COOKIE_SECURE=True`
- Use environment-specific configurations
- Implement rate limiting
- Add request logging

## 📈 Performance Optimization

### 1. Database Connection Pooling
The application uses SQLAlchemy connection pooling:
```python
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_pre_ping': True,
    'pool_recycle': 300,
    'pool_timeout': 20,
    'max_overflow': 0
}
```

### 2. Query Optimization
- Use database indexes (already created in setup script)
- Implement pagination for large datasets
- Use database views for complex queries

### 3. Caching
Consider implementing Redis caching for:
- User sessions
- Frequently accessed data
- API responses

## 🚀 Deployment Options

### 1. Development Server
```bash
python app.py
```

### 2. Production Server (Gunicorn)
```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

### 3. Docker Deployment
Create a `Dockerfile`:
```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
EXPOSE 5000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
```

## 📞 Support

If you encounter issues:

1. Check the Flask application logs
2. Verify database connection
3. Test API endpoints with `test_backend.py`
4. Check environment variables
5. Ensure all dependencies are installed

## 🎯 Next Steps

After successful setup:

1. **Customize the system** - Modify models and endpoints
2. **Add more features** - Implement exam creation, grading
3. **Enhance security** - Add rate limiting, input validation
4. **Monitor performance** - Add logging and metrics
5. **Deploy to production** - Use proper web server and SSL

---

**Congratulations!** Your ITI Examination System Python backend is now connected to SQL Server and ready to use. 
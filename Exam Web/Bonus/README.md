# ITI Examination System - Sign In Page

A modern, secure sign-in page for the ITI Examination System with role-based authentication for students, instructors, and training managers.

## 🚀 Features

### Frontend Features
- **Modern UI/UX**: Clean, responsive design with smooth animations
- **Role Selection**: Interactive role selection for different user types
- **Form Validation**: Real-time validation with helpful error messages
- **Password Visibility Toggle**: Show/hide password functionality
- **Remember Me**: Option to save credentials for future sessions
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile
- **Accessibility**: Keyboard navigation and screen reader support

### Backend Features
- **Secure Authentication**: JWT-based authentication with bcrypt password hashing
- **Role-Based Access**: Different permissions for students, instructors, and managers
- **Rate Limiting**: Protection against brute force attacks
- **Input Validation**: Server-side validation for all inputs
- **SQLite Database**: Lightweight, file-based database
- **Security Headers**: Helmet.js for enhanced security
- **CORS Support**: Cross-origin resource sharing configuration

## 🛠️ Technologies Used

### Frontend
- HTML5
- CSS3 (with modern features like Grid, Flexbox, CSS Variables)
- Vanilla JavaScript (ES6+)
- Font Awesome Icons
- Google Fonts (Poppins)

### Backend
- Node.js
- Express.js
- SQLite3
- bcryptjs (password hashing)
- jsonwebtoken (JWT authentication)
- express-validator (input validation)
- helmet (security headers)
- express-rate-limit (rate limiting)
- cors (cross-origin support)

## 📋 Prerequisites

Before running this application, make sure you have:

### For Standalone Demo (No Database)
- **Modern web browser** (Chrome, Firefox, Safari, Edge)

### For SQL Server Integration (Recommended)
- **Microsoft SQL Server** (2016 or later)
- **SQL Server Management Studio (SSMS)** or Azure Data Studio
- **Python** (3.8 or later) with Flask
- **ODBC Driver for SQL Server** (17 or later)

### For Node.js Backend (Alternative)
- **Node.js** (version 14 or higher)
- **npm** (comes with Node.js)

## 🚀 Installation & Setup

### Option 1: Standalone Demo (No Database)
1. **Clone or Download the Project**
2. **Open `demo.html`** in your web browser
3. **Use test credentials** to sign in (see below)

### Option 2: SQL Server Integration (Recommended)
1. **Set up Python Environment**:
   ```bash
   python -m venv venv
   venv\Scripts\activate  # Windows
   pip install -r requirements.txt
   ```

2. **Configure Database Connection**:
   - Copy `env_template.txt` to `.env`
   - Edit `.env` with your SQL Server credentials
   - Update server name, database name, username, and password

3. **Start the Backend**:
   ```bash
   python app.py
   ```

4. **Test the Connection**:
   ```bash
   python test_backend.py
   ```

5. **Access the System**:
   - Open `demo.html` in your web browser
   - Sign in with the test credentials

**For detailed setup instructions, see `PYTHON_SETUP_GUIDE.md`**

### Option 3: Node.js Backend (Alternative)
1. **Clone or Download the Project**
   ```bash
   cd iti-examination-system
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration (Optional)**
   Create a `.env` file in the root directory:
   ```env
   PORT=3000
   JWT_SECRET=your-super-secret-jwt-key-here
   FRONTEND_URL=http://localhost:3000
   ```

4. **Start the Application**
   ```bash
   npm start
   ```

5. **Access the Application**
   - **Frontend**: http://localhost:3000
   - **API Health Check**: http://localhost:3000/api/health

## 👥 Default Test Users

The system comes with pre-configured test users:

| Role | Email | Password | Name |
|------|-------|----------|------|
| Student | student@iti.gov.eg | student123 | Ahmed Student |
| Instructor | instructor@iti.gov.eg | instructor123 | Dr. Sarah Instructor |
| Training Manager | manager@iti.gov.eg | manager123 | Mr. Mohamed Manager |

## 🔐 Authentication Flow

1. **User selects their role** (Student, Instructor, or Training Manager)
2. **User enters credentials** (email and password)
3. **Frontend validation** ensures proper input format
4. **Backend authentication** verifies credentials against database
5. **JWT token generation** for authenticated sessions
6. **Role-based redirect** to appropriate dashboard

## 📁 Project Structure

```
iti-examination-system/
├── demo.html               # Main sign-in page (standalone demo)
├── index.html              # Original sign-in page
├── styles.css              # CSS styles and animations
├── script.js               # Frontend JavaScript logic
├── dashboard-styles.css    # Dashboard CSS styles
├── dashboard-script.js     # Dashboard JavaScript logic
├── student-dashboard.html  # Student dashboard
├── instructor-dashboard.html # Instructor dashboard
├── manager-dashboard.html  # Training manager dashboard
├── app.py                  # Flask application (Python backend)
├── config.py               # Python configuration
├── requirements.txt        # Python dependencies
├── test_backend.py         # Python backend test script
├── env_template.txt        # Environment variables template
├── database-setup.sql      # SQL Server database setup script
├── PYTHON_SETUP_GUIDE.md   # Python setup instructions
├── server.js               # Node.js backend server (alternative)
├── package.json            # Node.js dependencies
├── README.md               # This file
└── .env                    # Environment variables (create this)
```

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/signin` - User sign in
- `POST /api/auth/logout` - User logout

### User Management
- `GET /api/user/profile` - Get user profile (protected)
- `POST /api/user/change-password` - Change password (protected)

### System
- `GET /api/health` - Health check
- `GET /` - Serve frontend

## 🎨 Customization

### Styling
- Modify `styles.css` to change colors, fonts, and layout
- Update CSS variables for consistent theming
- Add custom animations in the CSS file

### Functionality
- Extend `script.js` for additional frontend features
- Modify `server.js` for backend logic changes
- Add new API endpoints as needed

### Database
- The SQLite database is automatically created on first run
- Default users are inserted automatically
- Modify the `insertDefaultUsers()` function to add more test users

## 🔒 Security Features

- **Password Hashing**: bcrypt with salt rounds
- **JWT Tokens**: Secure session management
- **Rate Limiting**: Protection against brute force attacks
- **Input Validation**: Both client and server-side validation
- **Security Headers**: Helmet.js implementation
- **CORS Protection**: Controlled cross-origin access

## 📱 Responsive Design

The application is fully responsive and works on:
- Desktop computers (1920px+)
- Laptops (1366px+)
- Tablets (768px+)
- Mobile phones (320px+)

## 🚨 Error Handling

- **Network Errors**: Graceful handling of API failures
- **Validation Errors**: Clear error messages for users
- **Authentication Errors**: Secure error responses
- **Server Errors**: Proper HTTP status codes

## 🔄 Development Workflow

1. **Frontend Development**: Edit HTML, CSS, and JavaScript files
2. **Backend Development**: Modify server.js and add new endpoints
3. **Database Changes**: Update the database schema in server.js
4. **Testing**: Use the provided test users to verify functionality

## 📈 Future Enhancements

Potential improvements for the system:
- [ ] Password reset functionality
- [ ] Email verification
- [ ] Two-factor authentication
- [ ] User registration
- [ ] Session management
- [ ] Audit logging
- [ ] Admin panel
- [ ] Dashboard pages for each role

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support or questions:
- Check the console for error messages
- Verify all dependencies are installed
- Ensure the correct port is available
- Check the database file permissions

## 🎯 Quick Start Commands

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start

# Check if everything is working
curl http://localhost:3000/api/health
```

---

**Built with ❤️ for ITI Examination System** 
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime
from datetime import timezone
from functools import wraps
from config import get_config
from sqlalchemy.sql.expression import func

app = Flask(__name__)

# Load configuration
config = get_config()
app.config.from_object(config)

# Initialize CORS
CORS(app, origins=config.CORS_ORIGINS)

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# Database Models
class User(db.Model):
    __tablename__ = 'Users'
    
    UserID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Email = db.Column(db.String(255), unique=True, nullable=False)
    Password = db.Column(db.String(255), nullable=False)
    Name = db.Column(db.String(255), nullable=False)
    Role = db.Column(db.String(50), nullable=False)
    Department = db.Column(db.String(100))
    CreatedAt = db.Column(db.DateTime, default=lambda: datetime.datetime.now(timezone.utc))
    UpdatedAt = db.Column(db.DateTime, default=lambda: datetime.datetime.now(timezone.utc), onupdate=lambda: datetime.datetime.now(timezone.utc))
    IsActive = db.Column(db.Boolean, default=True)

class Exam(db.Model):
    __tablename__ = 'Exams'
    
    ExamID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Title = db.Column(db.String(255), nullable=False)
    Subject = db.Column(db.String(100), nullable=False)
    Description = db.Column(db.Text)
    Duration = db.Column(db.Integer, nullable=False)  # in minutes
    Difficulty = db.Column(db.String(20))
    InstructorID = db.Column(db.Integer, db.ForeignKey('Users.UserID'))
    Status = db.Column(db.String(20), default='Draft')
    CreatedAt = db.Column(db.DateTime, default=lambda: datetime.datetime.now(timezone.utc))
    UpdatedAt = db.Column(db.DateTime, default=lambda: datetime.datetime.now(timezone.utc), onupdate=lambda: datetime.datetime.now(timezone.utc))

class Question(db.Model):
    __tablename__ = 'Questions'
    
    QuestionID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ExamID = db.Column(db.Integer, db.ForeignKey('Exams.ExamID'), nullable=False)
    QuestionText = db.Column(db.Text, nullable=False)
    QuestionType = db.Column(db.String(20), nullable=False)
    Options = db.Column(db.Text)  # JSON string for multiple choice options
    CorrectAnswer = db.Column(db.Text, nullable=False)
    Points = db.Column(db.Integer, default=1)
    CreatedAt = db.Column(db.DateTime, default=datetime.datetime.utcnow)

class ExamResult(db.Model):
    __tablename__ = 'ExamResults'
    
    ResultID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ExamID = db.Column(db.Integer, db.ForeignKey('Exams.ExamID'), nullable=False)
    StudentID = db.Column(db.Integer, db.ForeignKey('Users.UserID'), nullable=False)
    Score = db.Column(db.Numeric(5, 2), nullable=False)
    TotalQuestions = db.Column(db.Integer, nullable=False)
    CorrectAnswers = db.Column(db.Integer, nullable=False)
    TimeTaken = db.Column(db.Integer)  # in minutes
    SubmittedAt = db.Column(db.DateTime, default=datetime.datetime.utcnow)

# JWT Token decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        # Get token from header
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(" ")[1]
            except IndexError:
                return jsonify({'message': 'Token is missing'}), 401
        
        if not token:
            return jsonify({'message': 'Token is missing'}), 401
        
        try:
            # Decode token
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = User.query.filter_by(UserID=data['user_id']).first()
            
            if not current_user:
                return jsonify({'message': 'Invalid token'}), 401
                
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Invalid token'}), 401
        
        return f(current_user, *args, **kwargs)
    
    return decorated

# Routes
@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({
        'success': True,
        'message': 'ITI Examination System API is running',
        'timestamp': datetime.datetime.utcnow().isoformat(),
        'version': '1.0.0'
    })

@app.route('/api/auth/signin', methods=['POST'])
def signin():
    try:
        data = request.get_json()
        
        # Validate input
        if not data or not all(key in data for key in ['email', 'password', 'role']):
            return jsonify({
                'success': False,
                'message': 'Email, password, and role are required'
            }), 400
        
        email = data['email'].strip()
        password = data['password']
        role = data['role']
        
        # Validate email format
        if '@' not in email or '.' not in email:
            return jsonify({
                'success': False,
                'message': 'Invalid email format'
            }), 400
        
        # Validate role
        valid_roles = ['student', 'instructor', 'training-manager']
        if role not in valid_roles:
            return jsonify({
                'success': False,
                'message': 'Invalid role selected'
            }), 400
        
        # Check if user exists
        user = User.query.filter_by(Email=email, IsActive=True).first()
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found or account is inactive'
            }), 401
        
        # Verify password
        if not check_password_hash(user.Password, password):
            return jsonify({
                'success': False,
                'message': 'Invalid password'
            }), 401
        
        # Check if role matches
        if user.Role != role:
            return jsonify({
                'success': False,
                'message': 'Selected role does not match user account'
            }), 401
        
        # Update last login time
        user.UpdatedAt = datetime.datetime.utcnow()
        db.session.commit()
        
        # Generate JWT token
        token_payload = {
            'user_id': user.UserID,
            'email': user.Email,
            'role': user.Role,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
        }
        
        token = jwt.encode(token_payload, app.config['SECRET_KEY'], algorithm="HS256")
        
        return jsonify({
            'success': True,
            'message': 'Authentication successful',
            'user': {
                'id': user.UserID,
                'email': user.Email,
                'name': user.Name,
                'role': user.Role,
                'department': user.Department
            },
            'token': token,
            'role': user.Role
        })
        
    except Exception as e:
        app.logger.error(f"Signin error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred during authentication'
        }), 500

@app.route('/api/user/profile', methods=['GET'])
@token_required
def get_user_profile(current_user):
    try:
        return jsonify({
            'success': True,
            'user': {
                'id': current_user.UserID,
                'email': current_user.Email,
                'name': current_user.Name,
                'role': current_user.Role,
                'department': current_user.Department,
                'created_at': current_user.CreatedAt.isoformat(),
                'updated_at': current_user.UpdatedAt.isoformat()
            }
        })
    except Exception as e:
        app.logger.error(f"Get profile error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching profile'
        }), 500

@app.route('/api/user/change-password', methods=['POST'])
@token_required
def change_password(current_user):
    try:
        data = request.get_json()
        
        if not data or not all(key in data for key in ['currentPassword', 'newPassword']):
            return jsonify({
                'success': False,
                'message': 'Current password and new password are required'
            }), 400
        
        current_password = data['currentPassword']
        new_password = data['newPassword']
        
        # Verify current password
        if not check_password_hash(current_user.Password, current_password):
            return jsonify({
                'success': False,
                'message': 'Current password is incorrect'
            }), 401
        
        # Hash new password
        hashed_password = generate_password_hash(new_password)
        
        # Update password
        current_user.Password = hashed_password
        current_user.UpdatedAt = datetime.datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Password updated successfully'
        })
        
    except Exception as e:
        app.logger.error(f"Change password error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while changing password'
        }), 500

@app.route('/api/exams', methods=['GET'])
@token_required
def get_exams(current_user):
    try:
        if current_user.Role == 'student':
            # Get exams that the student has taken
            results = db.session.query(Exam, ExamResult.Score, ExamResult.SubmittedAt)\
                .join(ExamResult, Exam.ExamID == ExamResult.ExamID)\
                .filter(ExamResult.StudentID == current_user.UserID)\
                .order_by(ExamResult.SubmittedAt.desc())\
                .all()
            
            exams = []
            for exam, score, submitted_at in results:
                exams.append({
                    'id': exam.ExamID,
                    'title': exam.Title,
                    'subject': exam.Subject,
                    'description': exam.Description,
                    'duration': exam.Duration,
                    'difficulty': exam.Difficulty,
                    'status': exam.Status,
                    'score': float(score) if score else None,
                    'submitted_at': submitted_at.isoformat() if submitted_at else None
                })
                
        elif current_user.Role == 'instructor':
            # Get exams created by the instructor
            exams_data = Exam.query.filter_by(InstructorID=current_user.UserID).order_by(Exam.CreatedAt.desc()).all()
            
            exams = []
            for exam in exams_data:
                # Get statistics for each exam
                result_count = ExamResult.query.filter_by(ExamID=exam.ExamID).count()
                avg_score = db.session.query(db.func.avg(ExamResult.Score))\
                    .filter(ExamResult.ExamID == exam.ExamID).scalar()
                
                exams.append({
                    'id': exam.ExamID,
                    'title': exam.Title,
                    'subject': exam.Subject,
                    'description': exam.Description,
                    'duration': exam.Duration,
                    'difficulty': exam.Difficulty,
                    'status': exam.Status,
                    'student_count': result_count,
                    'average_score': float(avg_score) if avg_score else 0
                })
                
        else:  # training-manager
            # Get all exams with instructor information
            exams_data = db.session.query(Exam, User.Name.label('instructor_name'))\
                .join(User, Exam.InstructorID == User.UserID)\
                .order_by(Exam.CreatedAt.desc()).all()
            
            exams = []
            for exam, instructor_name in exams_data:
                result_count = ExamResult.query.filter_by(ExamID=exam.ExamID).count()
                avg_score = db.session.query(db.func.avg(ExamResult.Score))\
                    .filter(ExamResult.ExamID == exam.ExamID).scalar()
                
                exams.append({
                    'id': exam.ExamID,
                    'title': exam.Title,
                    'subject': exam.Subject,
                    'description': exam.Description,
                    'duration': exam.Duration,
                    'difficulty': exam.Difficulty,
                    'status': exam.Status,
                    'instructor': instructor_name,
                    'student_count': result_count,
                    'average_score': float(avg_score) if avg_score else 0
                })
        
        return jsonify({
            'success': True,
            'exams': exams
        })
        
    except Exception as e:
        app.logger.error(f"Get exams error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching exams'
        }), 500

@app.route('/api/users', methods=['GET'])
@token_required
def get_users(current_user):
    try:
        if current_user.Role != 'training-manager':
            return jsonify({
                'success': False,
                'message': 'Access denied. Only training managers can view all users.'
            }), 403
        
        users_data = User.query.filter_by(IsActive=True).all()
        
        users = []
        for user in users_data:
            # Get statistics for students
            exam_count = 0
            avg_score = 0
            
            if user.Role == 'student':
                exam_count = ExamResult.query.filter_by(StudentID=user.UserID).count()
                avg_score_query = db.session.query(db.func.avg(ExamResult.Score))\
                    .filter(ExamResult.StudentID == user.UserID).scalar()
                avg_score = float(avg_score_query) if avg_score_query else 0
            
            users.append({
                'id': user.UserID,
                'name': user.Name,
                'email': user.Email,
                'role': user.Role,
                'department': user.Department,
                'created_at': user.CreatedAt.isoformat(),
                'exam_count': exam_count,
                'average_score': avg_score
            })
        
        return jsonify({
            'success': True,
            'users': users
        })
        
    except Exception as e:
        app.logger.error(f"Get users error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching users'
        }), 500

@app.route('/api/get_exam_questions', methods=['GET'])
def get_exam_questions():
    exam_id = request.args.get('exam_id')
    if not exam_id:
        return jsonify({'success': False, 'message': 'Missing exam_id'}), 400

    # Fetch exam config (number of questions, duration)
    exam = Exam.query.filter_by(ExamID=exam_id).first()
    if not exam:
        return jsonify({'success': False, 'message': 'Exam not found'}), 404

    # Get all questions for this exam
    questions_query = Question.query.filter_by(ExamID=exam_id)
    total_questions = questions_query.count()
    if total_questions == 0:
        return jsonify({'success': False, 'message': 'No questions found for this exam'}), 404

    # Randomly select N questions (N = total for this exam)
    # If you want to limit to a specific number, add a field to Exam or use all
    num_questions = total_questions  # or exam.NumQuestions if you have such a field
    questions = questions_query.order_by(func.random()).limit(num_questions).all()

    # Prepare questions for JSON
    questions_json = []
    for q in questions:
        questions_json.append({
            'id': q.QuestionID,
            'text': q.QuestionText,
            'type': q.QuestionType,
            'options': q.Options,  # Should be parsed as JSON on frontend if needed
            'points': q.Points
        })

    return jsonify({
        'success': True,
        'questions': questions_json,
        'duration': exam.Duration  # in minutes
    })

@app.route('/api/programming_mcq_questions', methods=['GET'])
def get_programming_mcq_questions():
    """Fetch MCQ questions from SQL Server database"""
    try:
        # Get all multiple-choice questions from the database
        questions_query = Question.query.filter_by(QuestionType='multiple-choice')
        total_questions = questions_query.count()
        
        if total_questions == 0:
            return jsonify({'success': False, 'message': 'No questions found in database'}), 404
        
        # Randomly select up to 50 questions
        import random
        sample_size = min(50, total_questions)
        questions = questions_query.order_by(func.random()).limit(sample_size).all()
        
        # Format questions for the exam page
        questions_json = []
        for q in questions:
            # Parse options from JSON string
            import json
            try:
                options = json.loads(q.Options) if q.Options else []
            except (json.JSONDecodeError, TypeError):
                options = []
            
            questions_json.append({
                'question': q.QuestionText,
                'options': options,
                'correct': q.CorrectAnswer
            })
        
        return jsonify({
            'success': True,
            'questions': questions_json
        })
        
    except Exception as e:
        app.logger.error(f"Error fetching questions from database: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error fetching questions: {str(e)}'
        }), 500

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'success': False,
        'message': 'Endpoint not found'
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        'success': False,
        'message': 'Internal server error'
    }), 500

if __name__ == '__main__':
    # Create tables if they don't exist
    with app.app_context():
        db.create_all()
        
        # Insert default users if they don't exist
        default_users = [
            {
                'email': 'alibakr@iti.org',
                'password': 'student123',
                'name': 'Ahmed Student',
                'role': 'student',
                'department': 'Programming'
            },
            {
                'email': 'saherahmed@iti.org',
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
        
        db.session.commit()
    
    app.run(debug=True, host='0.0.0.0', port=5000) 
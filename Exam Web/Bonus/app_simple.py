from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime
from functools import wraps
import random
import csv

app = Flask(__name__)
CORS(app, origins="*")

# Configuration
app.config['SECRET_KEY'] = 'your-secret-key-here'

# Mock user database (in-memory)
mock_users = {
    'alibakr@iti.org': {
        'id': 1,
        'password': generate_password_hash('student123'),
        'name': 'Ali Bakr',
        'role': 'student',
        'department': 'Programming'
    },
    'saherahmed@iti.org': {
        'id': 2,
        'password': generate_password_hash('instructor123'),
        'name': 'Saher Ahmed',
        'role': 'instructor',
        'department': 'Programming'
    },
    'manager@iti.gov.eg': {
        'id': 3,
        'password': generate_password_hash('manager123'),
        'name': 'Mr. Mohamed Manager',
        'role': 'training-manager',
        'department': 'Management'
    }
}

# Mock question database (in-memory)
mock_questions = {
    1: [  # JavaScript Fundamentals
        {
            'id': 101,
            'text': 'What is a closure in JavaScript?',
            'type': 'short-answer',
            'options': None,
            'points': 2
        },
        {
            'id': 102,
            'text': 'Which of the following is a JavaScript data type?',
            'type': 'multiple-choice',
            'options': '["String", "Table", "Document", "Style"]',
            'points': 1
        },
        {
            'id': 103,
            'text': 'JavaScript is a case-sensitive language.',
            'type': 'multiple-choice',
            'options': '["True", "False"]',
            'points': 1
        },
        {
            'id': 104,
            'text': 'What does DOM stand for?',
            'type': 'short-answer',
            'options': None,
            'points': 2
        }
    ],
    2: [  # Database Management
        {
            'id': 201,
            'text': 'What is a primary key in a database?',
            'type': 'short-answer',
            'options': None,
            'points': 2
        },
        {
            'id': 202,
            'text': 'Which SQL statement is used to extract data from a database?',
            'type': 'multiple-choice',
            'options': '["GET", "EXTRACT", "SELECT", "OPEN"]',
            'points': 1
        },
        {
            'id': 203,
            'text': 'A table can have multiple primary keys.',
            'type': 'multiple-choice',
            'options': '["True", "False"]',
            'points': 1
        },
        {
            'id': 204,
            'text': 'What does SQL stand for?',
            'type': 'short-answer',
            'options': None,
            'points': 2
        }
    ]
}

# JWT Token decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(" ")[1]
            except IndexError:
                return jsonify({'message': 'Token is missing'}), 401
        
        if not token:
            return jsonify({'message': 'Token is missing'}), 401
        
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = mock_users.get(data['email'])
            
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
        'timestamp': datetime.datetime.now().isoformat(),
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
        
        # Check if user exists
        user = mock_users.get(email)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 401
        
        # Verify password
        if not check_password_hash(user['password'], password):
            return jsonify({
                'success': False,
                'message': 'Invalid password'
            }), 401
        
        # Check if role matches
        if user['role'] != role:
            return jsonify({
                'success': False,
                'message': 'Selected role does not match user account'
            }), 401
        
        # Generate JWT token
        token_payload = {
            'user_id': user['id'],
            'email': email,
            'role': user['role'],
            'exp': datetime.datetime.now() + datetime.timedelta(hours=24)
        }
        
        token = jwt.encode(token_payload, app.config['SECRET_KEY'], algorithm="HS256")
        
        return jsonify({
            'success': True,
            'message': 'Authentication successful',
            'user': {
                'id': user['id'],
                'email': email,
                'name': user['name'],
                'role': user['role'],
                'department': user['department']
            },
            'token': token,
            'role': user['role']
        })
        
    except Exception as e:
        print(f"Signin error: {str(e)}")
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
                'id': current_user['id'],
                'email': list(mock_users.keys())[list(mock_users.values()).index(current_user)],
                'name': current_user['name'],
                'role': current_user['role'],
                'department': current_user['department']
            }
        })
    except Exception as e:
        print(f"Get profile error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching profile'
        }), 500

@app.route('/api/exams', methods=['GET'])
@token_required
def get_exams(current_user):
    try:
        # Mock exam data
        mock_exams = [
            {
                'id': 1,
                'title': 'JavaScript Fundamentals',
                'subject': 'Programming',
                'description': 'Basic JavaScript concepts',
                'duration': 60,
                'difficulty': 'Beginner',
                'status': 'Active',
                'score': 85.0 if current_user['role'] == 'student' else None,
                'student_count': 15 if current_user['role'] == 'instructor' else None,
                'average_score': 78.5 if current_user['role'] == 'instructor' else None,
                'instructor': 'Dr. Sarah Instructor' if current_user['role'] == 'training-manager' else None
            },
            {
                'id': 2,
                'title': 'Database Management',
                'subject': 'Database',
                'description': 'SQL Server concepts',
                'duration': 90,
                'difficulty': 'Intermediate',
                'status': 'Active',
                'score': 92.0 if current_user['role'] == 'student' else None,
                'student_count': 12 if current_user['role'] == 'instructor' else None,
                'average_score': 85.2 if current_user['role'] == 'instructor' else None,
                'instructor': 'Dr. Sarah Instructor' if current_user['role'] == 'training-manager' else None
            }
        ]
        
        return jsonify({
            'success': True,
            'exams': mock_exams
        })
        
    except Exception as e:
        print(f"Get exams error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching exams'
        }), 500

@app.route('/api/get_exam_questions', methods=['GET'])
def get_exam_questions():
    exam_id = request.args.get('exam_id', type=int)
    if not exam_id:
        return jsonify({'success': False, 'message': 'Missing exam_id'}), 400

    # Mock exam lookup
    mock_exams = [
        {
            'id': 1,
            'title': 'JavaScript Fundamentals',
            'duration': 60
        },
        {
            'id': 2,
            'title': 'Database Management',
            'duration': 90
        }
    ]
    exam = next((e for e in mock_exams if e['id'] == exam_id), None)
    if not exam:
        return jsonify({'success': False, 'message': 'Exam not found'}), 404

    # Get questions for this exam
    questions = mock_questions.get(exam_id, [])
    if not questions:
        return jsonify({'success': False, 'message': 'No questions found for this exam'}), 404

    # For demo, select all questions or random subset (e.g., 3)
    num_questions = min(3, len(questions))
    selected_questions = random.sample(questions, num_questions)

    return jsonify({
        'success': True,
        'questions': selected_questions,
        'duration': exam['duration']
    })

@app.route('/api/programming_mcq_questions', methods=['GET'])
def get_programming_mcq_questions():
    questions = []
    try:
        with open('programming_mcq_questions.csv', newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                questions.append({
                    'question': row['Question'],
                    'options': [row['OptionA'], row['OptionB'], row['OptionC'], row['OptionD']],
                    'correct': row['CorrectAnswer']
                })
        import random
        sample_size = min(50, len(questions))
        selected = random.sample(questions, sample_size)
        return jsonify({'success': True, 'questions': selected})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/users', methods=['GET'])
@token_required
def get_users(current_user):
    try:
        if current_user['role'] != 'training-manager':
            return jsonify({
                'success': False,
                'message': 'Access denied. Only training managers can view all users.'
            }), 403
        
        users = []
        for email, user_data in mock_users.items():
            users.append({
                'id': user_data['id'],
                'name': user_data['name'],
                'email': email,
                'role': user_data['role'],
                'department': user_data['department'],
                'exam_count': 2 if user_data['role'] == 'student' else 0,
                'average_score': 88.5 if user_data['role'] == 'student' else 0
            })
        
        return jsonify({
            'success': True,
            'users': users
        })
        
    except Exception as e:
        print(f"Get users error: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while fetching users'
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
    print("🚀 Starting ITI Examination System API...")
    print("📝 Test credentials:")
    print("   Student: student@iti.gov.eg / student123")
    print("   Instructor: instructor@iti.gov.eg / instructor123")
    print("   Manager: manager@iti.gov.eg / manager123")
    print("🌐 API will be available at: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000) 
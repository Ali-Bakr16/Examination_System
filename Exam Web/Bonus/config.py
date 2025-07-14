import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    # Flask Configuration
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your-secret-key-here-change-in-production'
    
    # Database Configuration
    # Update these values with your SQL Server details
    DB_SERVER = os.environ.get('DB_SERVER') or 'localhost'
    DB_NAME = os.environ.get('DB_NAME') or 'ITIExaminationDB'
    DB_USERNAME = os.environ.get('DB_USERNAME') or 'sa'
    DB_PASSWORD = os.environ.get('DB_PASSWORD') or 'your_password'
    DB_DRIVER = os.environ.get('DB_DRIVER') or 'ODBC+Driver+17+for+SQL+Server'
    
    # SQLAlchemy Configuration
    SQLALCHEMY_DATABASE_URI = f'mssql+pyodbc://{DB_USERNAME}:{DB_PASSWORD}@{DB_SERVER}/{DB_NAME}?driver={DB_DRIVER}'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_pre_ping': True,
        'pool_recycle': 300,
        'pool_timeout': 20,
        'max_overflow': 0
    }
    
    # JWT Configuration
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or SECRET_KEY
    JWT_ACCESS_TOKEN_EXPIRES = 24 * 60 * 60  # 24 hours in seconds
    
    # Application Configuration
    DEBUG = os.environ.get('DEBUG', 'False').lower() == 'true'
    HOST = os.environ.get('HOST') or '0.0.0.0'
    PORT = int(os.environ.get('PORT') or 5000)
    
    # CORS Configuration
    CORS_ORIGINS = os.environ.get('CORS_ORIGINS', '*').split(',')
    
    # Security Configuration
    SESSION_COOKIE_SECURE = os.environ.get('SESSION_COOKIE_SECURE', 'False').lower() == 'true'
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_TRACK_MODIFICATIONS = True

class ProductionConfig(Config):
    DEBUG = False
    SESSION_COOKIE_SECURE = True

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'

# Configuration dictionary
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}

def get_config():
    """Get configuration based on environment"""
    config_name = os.environ.get('FLASK_ENV', 'default')
    return config.get(config_name, config['default']) 
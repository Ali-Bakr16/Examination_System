#!/usr/bin/env python3
"""
Test script for ITI Examination System Python Backend
"""

import requests
import json
import sys

# Configuration
BASE_URL = "http://localhost:5000"
API_BASE = f"{BASE_URL}/api"

def test_health_check():
    """Test the health check endpoint"""
    print("🔍 Testing Health Check...")
    try:
        response = requests.get(f"{API_BASE}/health")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Health check passed: {data['message']}")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Could not connect to the server. Make sure the Flask app is running.")
        return False
    except Exception as e:
        print(f"❌ Health check error: {str(e)}")
        return False

def test_authentication():
    """Test authentication with test users"""
    print("\n🔍 Testing Authentication...")
    
    test_users = [
        {
            'email': 'student@iti.gov.eg',
            'password': 'student123',
            'role': 'student',
            'name': 'Ahmed Student'
        },
        {
            'email': 'instructor@iti.gov.eg',
            'password': 'instructor123',
            'role': 'instructor',
            'name': 'Dr. Sarah Instructor'
        },
        {
            'email': 'manager@iti.gov.eg',
            'password': 'manager123',
            'role': 'training-manager',
            'name': 'Mr. Mohamed Manager'
        }
    ]
    
    tokens = {}
    
    for user in test_users:
        print(f"  Testing {user['role']} authentication...")
        try:
            response = requests.post(
                f"{API_BASE}/auth/signin",
                json={
                    'email': user['email'],
                    'password': user['password'],
                    'role': user['role']
                },
                headers={'Content-Type': 'application/json'}
            )
            
            if response.status_code == 200:
                data = response.json()
                if data['success']:
                    print(f"    ✅ {user['role']} authenticated successfully")
                    tokens[user['role']] = data['token']
                else:
                    print(f"    ❌ {user['role']} authentication failed: {data['message']}")
            else:
                print(f"    ❌ {user['role']} authentication failed: HTTP {response.status_code}")
                
        except Exception as e:
            print(f"    ❌ {user['role']} authentication error: {str(e)}")
    
    return tokens

def main():
    """Main test function"""
    print("🚀 ITI Examination System - Python Backend Test")
    print("=" * 50)
    
    # Test health check
    if not test_health_check():
        print("\n❌ Health check failed. Please make sure the Flask app is running.")
        print("   Run: python app.py")
        sys.exit(1)
    
    # Test authentication
    tokens = test_authentication()
    
    if not tokens:
        print("\n❌ Authentication tests failed.")
        sys.exit(1)
    
    print("\n" + "=" * 50)
    print("✅ All tests completed!")
    print("\n🎉 Your Python backend is working correctly!")
    print("\n🌐 You can now:")
    print("1. Open demo.html in your browser")
    print("2. Sign in with the test credentials")
    print("3. Access the role-based dashboards")

if __name__ == "__main__":
    main() 
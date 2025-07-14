// DOM Elements
const signinForm = document.getElementById('signinForm');
const roleOptions = document.querySelectorAll('.role-option');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const togglePasswordBtn = document.getElementById('togglePassword');
const signinBtn = document.getElementById('signinBtn');
const alertContainer = document.getElementById('alertContainer');

// Global Variables
let selectedRole = null;
let isAuthenticating = false;

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    initializeEventListeners();
    loadSavedCredentials();
});

// Event Listeners
function initializeEventListeners() {
    // Role selection
    roleOptions.forEach(option => {
        option.addEventListener('click', () => selectRole(option));
    });

    // Form submission
    signinForm.addEventListener('submit', handleSignIn);

    // Password toggle
    togglePasswordBtn.addEventListener('click', togglePasswordVisibility);

    // Input validation
    emailInput.addEventListener('input', validateEmail);
    passwordInput.addEventListener('input', validatePassword);

    // Form validation on blur
    emailInput.addEventListener('blur', validateEmail);
    passwordInput.addEventListener('blur', validatePassword);
}

// Role Selection
function selectRole(selectedOption) {
    // Remove previous selection
    roleOptions.forEach(option => {
        option.classList.remove('selected');
    });

    // Add selection to clicked option
    selectedOption.classList.add('selected');
    selectedRole = selectedOption.dataset.role;

    // Update form validation
    validateForm();
    
    // Show success message
    showAlert(`Selected role: ${selectedOption.querySelector('span').textContent}`, 'success');
}

// Password Visibility Toggle
function togglePasswordVisibility() {
    const type = passwordInput.type === 'password' ? 'text' : 'password';
    passwordInput.type = type;
    
    const icon = togglePasswordBtn.querySelector('i');
    icon.className = type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
}

// Form Validation
function validateEmail() {
    const email = emailInput.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (!email) {
        showFieldError(emailInput, 'Email is required');
        return false;
    } else if (!emailRegex.test(email)) {
        showFieldError(emailInput, 'Please enter a valid email address');
        return false;
    } else {
        clearFieldError(emailInput);
        return true;
    }
}

function validatePassword() {
    const password = passwordInput.value;
    
    if (!password) {
        showFieldError(passwordInput, 'Password is required');
        return false;
    } else if (password.length < 6) {
        showFieldError(passwordInput, 'Password must be at least 6 characters');
        return false;
    } else {
        clearFieldError(passwordInput);
        return true;
    }
}

function validateForm() {
    const isEmailValid = validateEmail();
    const isPasswordValid = validatePassword();
    const isRoleSelected = selectedRole !== null;
    
    signinBtn.disabled = !(isEmailValid && isPasswordValid && isRoleSelected);
    
    return isEmailValid && isPasswordValid && isRoleSelected;
}

// Field Error Handling
function showFieldError(input, message) {
    const inputGroup = input.closest('.input-group');
    const existingError = inputGroup.querySelector('.field-error');
    
    if (!existingError) {
        const errorElement = document.createElement('div');
        errorElement.className = 'field-error';
        errorElement.textContent = message;
        errorElement.style.cssText = `
            color: #dc3545;
            font-size: 0.8rem;
            margin-top: 5px;
            animation: fadeIn 0.3s ease;
        `;
        inputGroup.appendChild(errorElement);
    }
    
    input.style.borderColor = '#dc3545';
}

function clearFieldError(input) {
    const inputGroup = input.closest('.input-group');
    const errorElement = inputGroup.querySelector('.field-error');
    
    if (errorElement) {
        errorElement.remove();
    }
    
    input.style.borderColor = '#e1e5e9';
}

// Sign In Handler
async function handleSignIn(event) {
    event.preventDefault();
    
    if (!validateForm()) {
        showAlert('Please fill in all required fields correctly', 'error');
        return;
    }
    
    if (isAuthenticating) {
        return;
    }
    
    const formData = {
        email: emailInput.value.trim(),
        password: passwordInput.value,
        role: selectedRole,
        rememberMe: document.getElementById('rememberMe').checked
    };
    
    setLoadingState(true);
    
    try {
        const response = await authenticateUser(formData);
        
        if (response.success) {
            // Save credentials if remember me is checked
            if (formData.rememberMe) {
                saveCredentials(formData.email, formData.role);
            } else {
                clearSavedCredentials();
            }
            
            showAlert('Sign in successful! Redirecting...', 'success');
            
            // Simulate redirect to dashboard
            setTimeout(() => {
                redirectToDashboard(response.user, response.role);
            }, 1500);
            
        } else {
            showAlert(response.message || 'Authentication failed', 'error');
        }
        
    } catch (error) {
        console.error('Authentication error:', error);
        showAlert('An error occurred during sign in. Please try again.', 'error');
    } finally {
        setLoadingState(false);
    }
}

// Authentication Function
async function authenticateUser(credentials) {
    try {
        const response = await fetch('/api/auth/signin', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(credentials)
        });

        const data = await response.json();
        
        if (data.success) {
            // Store token in localStorage
            localStorage.setItem('iti_auth_token', data.token);
            localStorage.setItem('iti_user_role', data.role);
        }
        
        return data;
    } catch (error) {
        console.error('API call failed:', error);
        return {
            success: false,
            message: 'Network error. Please check your connection and try again.'
        };
    }
}

// Loading State Management
function setLoadingState(loading) {
    isAuthenticating = loading;
    signinBtn.disabled = loading;
    
    if (loading) {
        signinBtn.classList.add('loading');
    } else {
        signinBtn.classList.remove('loading');
    }
}

// Alert System
function showAlert(message, type = 'info') {
    const alertElement = document.createElement('div');
    alertElement.className = `alert ${type}`;
    
    const iconMap = {
        success: 'fas fa-check-circle',
        error: 'fas fa-exclamation-circle',
        warning: 'fas fa-exclamation-triangle',
        info: 'fas fa-info-circle'
    };
    
    alertElement.innerHTML = `
        <i class="${iconMap[type] || iconMap.info}"></i>
        <span>${message}</span>
        <button class="alert-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    alertContainer.appendChild(alertElement);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alertElement.parentElement) {
            alertElement.remove();
        }
    }, 5000);
}

// Dashboard Redirect
function redirectToDashboard(user, role) {
    const dashboards = {
        student: '/student/dashboard',
        instructor: '/instructor/dashboard',
        'training-manager': '/manager/dashboard'
    };
    
    const dashboardUrl = dashboards[role] || '/dashboard';
    
    // In a real application, you would redirect to the actual dashboard
    // For demo purposes, we'll show a success message
    showAlert(`Welcome ${user.name}! Redirecting to ${role} dashboard...`, 'success');
    
    // Simulate redirect (replace with actual redirect in production)
    console.log(`Redirecting to: ${dashboardUrl}`);
}

// Credential Management
function saveCredentials(email, role) {
    try {
        localStorage.setItem('iti_remembered_email', email);
        localStorage.setItem('iti_remembered_role', role);
    } catch (error) {
        console.error('Failed to save credentials:', error);
    }
}

function loadSavedCredentials() {
    try {
        const savedEmail = localStorage.getItem('iti_remembered_email');
        const savedRole = localStorage.getItem('iti_remembered_role');
        
        if (savedEmail && savedRole) {
            emailInput.value = savedEmail;
            document.getElementById('rememberMe').checked = true;
            
            // Select the saved role
            const roleOption = document.querySelector(`[data-role="${savedRole}"]`);
            if (roleOption) {
                selectRole(roleOption);
            }
        }
    } catch (error) {
        console.error('Failed to load saved credentials:', error);
    }
}

function clearSavedCredentials() {
    try {
        localStorage.removeItem('iti_remembered_email');
        localStorage.removeItem('iti_remembered_role');
    } catch (error) {
        console.error('Failed to clear saved credentials:', error);
    }
}

// Utility Functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Enhanced validation with debouncing
const debouncedEmailValidation = debounce(validateEmail, 300);
const debouncedPasswordValidation = debounce(validatePassword, 300);

emailInput.addEventListener('input', debouncedEmailValidation);
passwordInput.addEventListener('input', debouncedPasswordValidation);

// Keyboard Navigation
document.addEventListener('keydown', function(event) {
    if (event.key === 'Enter' && !isAuthenticating) {
        handleSignIn(event);
    }
});

// Accessibility improvements
roleOptions.forEach(option => {
    option.setAttribute('tabindex', '0');
    option.setAttribute('role', 'button');
    option.setAttribute('aria-pressed', 'false');
    
    option.addEventListener('keydown', function(event) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            selectRole(this);
        }
    });
});

// Add fadeIn animation for field errors
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
`;
document.head.appendChild(style); 
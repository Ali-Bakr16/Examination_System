// Shared Dashboard Script
// This file contains common functionality used across all dashboard pages

// Common dashboard functions
function showAlert(message, type = 'info') {
    const alertContainer = document.getElementById('alertContainer');
    if (!alertContainer) return;
    
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
    
    setTimeout(() => {
        if (alertElement.parentElement) {
            alertElement.remove();
        }
    }, 5000);
}

function logout() {
    // Clear all stored data
    localStorage.removeItem('iti_user_data');
    localStorage.removeItem('iti_auth_token');
    localStorage.removeItem('iti_user_role');
    localStorage.removeItem('iti_remembered_email');
    localStorage.removeItem('iti_remembered_role');
    
    // Redirect to login page
    window.location.href = 'demo.html';
}

function navigateToSection(section) {
    // Remove active class from all nav items
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });

    // Add active class to clicked item
    const activeLink = document.querySelector(`[href="#${section}"]`);
    if (activeLink) {
        activeLink.parentElement.classList.add('active');
    }

    // Show appropriate content based on section
    showSectionContent(section);
}

function showSectionContent(section) {
    // This would show different content based on the section
    showAlert(`Navigating to ${section} section`, 'info');
}

function setupNavigation() {
    // Navigation event listeners
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = this.getAttribute('href').substring(1);
            navigateToSection(target);
        });
    });
}

function checkAuthentication() {
    const userData = localStorage.getItem('iti_user_data');
    if (!userData) {
        window.location.href = 'demo.html';
        return false;
    }
    return true;
}

function getUserData() {
    const userData = localStorage.getItem('iti_user_data');
    return userData ? JSON.parse(userData) : null;
}

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString();
}

function formatDateTime(dateString) {
    return new Date(dateString).toLocaleString();
}

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

// Export functions for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        showAlert,
        logout,
        navigateToSection,
        showSectionContent,
        setupNavigation,
        checkAuthentication,
        getUserData,
        formatDate,
        formatDateTime,
        debounce
    };
} 
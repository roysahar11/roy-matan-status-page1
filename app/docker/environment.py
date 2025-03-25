"""
Status-Page configuration template for Docker deployments.
This will be used to replace the default configuration with environment variables.
"""

import os

# SECURITY WARNING: Don't run with debug turned on in production!
DEBUG = os.environ.get('DEBUG', 'False').lower() == 'true'

# ALLOWED_HOSTS must be set to the proper domain names and/or IP addresses
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '*').split(',')

# Database settings
DATABASE = {
    'NAME': os.environ.get('DB_NAME', 'status-page'),
    'USER': os.environ.get('DB_USER', 'status-page'),
    'PASSWORD': os.environ.get('DB_PASSWORD', ''),
    'HOST': os.environ.get('DB_HOST', 'localhost'),
    'PORT': os.environ.get('DB_PORT', ''),
    'CONN_MAX_AGE': int(os.environ.get('DB_CONN_MAX_AGE', '300')),
}

# Redis settings
REDIS = {
    'tasks': {
        'HOST': os.environ.get('REDIS_HOST', 'localhost'),
        'PORT': int(os.environ.get('REDIS_PORT', '6379')),
        'PASSWORD': os.environ.get('REDIS_PASSWORD', ''),
        'DATABASE': int(os.environ.get('REDIS_DATABASE_TASKS', '0')),
        'SSL': os.environ.get('REDIS_SSL', 'False').lower() == 'true',
    },
    'caching': {
        'HOST': os.environ.get('REDIS_HOST', 'localhost'),
        'PORT': int(os.environ.get('REDIS_PORT', '6379')),
        'PASSWORD': os.environ.get('REDIS_PASSWORD', ''),
        'DATABASE': int(os.environ.get('REDIS_DATABASE_CACHING', '1')),
        'SSL': os.environ.get('REDIS_SSL', 'False').lower() == 'true',
    }
}

# SECURITY WARNING: Use a unique, randomly generated value for your installation!
SECRET_KEY = os.environ.get('SECRET_KEY', '')
-- PostgreSQL Database Setup Script
-- NodeJS PostgreSQL Application

-- Drop existing databases (if needed)
DROP DATABASE IF EXISTS nodejs_app_dev;
DROP DATABASE IF EXISTS nodejs_app_release;
DROP DATABASE IF EXISTS nodejs_app_prod;

-- Create databases for each environment
CREATE DATABASE nodejs_app_dev
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

CREATE DATABASE nodejs_app_release
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

CREATE DATABASE nodejs_app_prod
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

-- Display created databases
\l nodejs_app*

-- Instructions
\echo ''
\echo '✓ Databases created successfully!'
\echo ''
\echo 'Available databases:'
\echo '  - nodejs_app_dev     (Development)'
\echo '  - nodejs_app_release (Release/Staging)'
\echo '  - nodejs_app_prod    (Production)'
\echo ''
\echo 'The application will automatically create the required tables on startup.'
\echo ''

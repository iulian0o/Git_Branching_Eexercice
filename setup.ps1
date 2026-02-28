# NodeJS PostgreSQL Application Setup Script
# For Windows PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NodeJS PostgreSQL App Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js installation
Write-Host "Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js not found. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check npm installation
Write-Host "Checking npm installation..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version
    Write-Host "✓ npm found: v$npmVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ npm not found." -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host ""
Write-Host "Installing dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PostgreSQL Database Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please ensure PostgreSQL is running and execute the following SQL commands:" -ForegroundColor Yellow
Write-Host ""
Write-Host "CREATE DATABASE nodejs_app_dev;" -ForegroundColor White
Write-Host "CREATE DATABASE nodejs_app_release;" -ForegroundColor White
Write-Host "CREATE DATABASE nodejs_app_prod;" -ForegroundColor White
Write-Host ""

# Initialize Git repository
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Git Repository Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path .git) {
    Write-Host "✓ Git repository already initialized" -ForegroundColor Green
} else {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Git repository initialized" -ForegroundColor Green
        
        # Initial commit
        git add .
        git commit -m "Initial commit: Project structure setup"
        
        # Create develop branch
        git checkout -b develop
        git checkout main
        
        Write-Host "✓ Created main and develop branches" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to initialize Git repository" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Set up PostgreSQL databases (see above)" -ForegroundColor White
Write-Host "2. Run the application:" -ForegroundColor White
Write-Host "   - Development:  npm run dev" -ForegroundColor Cyan
Write-Host "   - Release:      npm run release" -ForegroundColor Cyan
Write-Host "   - Production:   npm run prod" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Test the API at:" -ForegroundColor White
Write-Host "   - Development:  http://localhost:3000" -ForegroundColor Cyan
Write-Host "   - Release:      http://localhost:3001" -ForegroundColor Cyan
Write-Host "   - Production:   http://localhost:3002" -ForegroundColor Cyan
Write-Host ""

# API Testing Script for NodeJS PostgreSQL Application
# For Windows PowerShell

param(
    [string]$Environment = "dev"
)

# Set port based on environment
$port = switch ($Environment) {
    "dev"     { 3000 }
    "release" { 3001 }
    "prod"    { 3002 }
    default   { 3000 }
}

$baseUrl = "http://localhost:$port"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  API Testing - $Environment Environment" -ForegroundColor Cyan
Write-Host "  Base URL: $baseUrl" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "Test 1: Health Check" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/health" -Method Get
    Write-Host "✓ Status: " -NoNewline -ForegroundColor Green
    Write-Host $response.message
    Write-Host "  Environment: $($response.environment)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 2: Create User
Write-Host "Test 2: Create User" -ForegroundColor Yellow
$newUser = @{
    username = "johndoe"
    email = "john.doe@example.com"
    full_name = "John Doe"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Post -Body $newUser -ContentType "application/json"
    Write-Host "✓ User created successfully" -ForegroundColor Green
    Write-Host "  ID: $($response.data.id)" -ForegroundColor Gray
    Write-Host "  Username: $($response.data.username)" -ForegroundColor Gray
    Write-Host "  Email: $($response.data.email)" -ForegroundColor Gray
    Write-Host ""
    $userId = $response.data.id
} catch {
    Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 3: Get All Users
Write-Host "Test 3: Get All Users" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Get
    Write-Host "✓ Retrieved $($response.count) user(s)" -ForegroundColor Green
    foreach ($user in $response.data) {
        Write-Host "  - $($user.username) ($($user.email))" -ForegroundColor Gray
    }
    Write-Host ""
} catch {
    Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 4: Get User by ID
if ($userId) {
    Write-Host "Test 4: Get User by ID" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" -Method Get
        Write-Host "✓ User retrieved successfully" -ForegroundColor Green
        Write-Host "  Username: $($response.data.username)" -ForegroundColor Gray
        Write-Host "  Email: $($response.data.email)" -ForegroundColor Gray
        Write-Host "  Full Name: $($response.data.full_name)" -ForegroundColor Gray
        Write-Host ""
    } catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
    }
}

# Test 5: Update User
if ($userId) {
    Write-Host "Test 5: Update User" -ForegroundColor Yellow
    $updateData = @{
        full_name = "John Doe Updated"
        email = "john.updated@example.com"
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" -Method Put -Body $updateData -ContentType "application/json"
        Write-Host "✓ User updated successfully" -ForegroundColor Green
        Write-Host "  New Full Name: $($response.data.full_name)" -ForegroundColor Gray
        Write-Host "  New Email: $($response.data.email)" -ForegroundColor Gray
        Write-Host ""
    } catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
    }
}

# Test 6: Create Additional Users
Write-Host "Test 6: Create Additional Users" -ForegroundColor Yellow
$users = @(
    @{ username = "janedoe"; email = "jane@example.com"; full_name = "Jane Doe" },
    @{ username = "bobsmith"; email = "bob@example.com"; full_name = "Bob Smith" }
)

foreach ($user in $users) {
    $userData = $user | ConvertTo-Json
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Post -Body $userData -ContentType "application/json"
        Write-Host "✓ Created user: $($response.data.username)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to create user: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 7: Get All Users Again
Write-Host "Test 7: Get All Users (Updated List)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Get
    Write-Host "✓ Total users: $($response.count)" -ForegroundColor Green
    foreach ($user in $response.data) {
        Write-Host "  - ID: $($user.id) | $($user.username) | $($user.email)" -ForegroundColor Gray
    }
    Write-Host ""
} catch {
    Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 8: Delete User
if ($userId) {
    Write-Host "Test 8: Delete User" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" -Method Delete
        Write-Host "✓ User deleted successfully" -ForegroundColor Green
        Write-Host "  Deleted: $($response.data.username)" -ForegroundColor Gray
        Write-Host ""
    } catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
    }
}

# Test 9: Verify Deletion
Write-Host "Test 9: Verify Deletion" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Get
    Write-Host "✓ Final user count: $($response.count)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Test 10: Error Handling - Invalid Email
Write-Host "Test 10: Error Handling (Invalid Email)" -ForegroundColor Yellow
$invalidUser = @{
    username = "testuser"
    email = "invalid-email"
    full_name = "Test User"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Post -Body $invalidUser -ContentType "application/json"
    Write-Host "✗ Should have failed validation" -ForegroundColor Red
    Write-Host ""
} catch {
    Write-Host "✓ Properly handled invalid email" -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Testing Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "All tests executed. Check results above." -ForegroundColor Yellow
Write-Host ""

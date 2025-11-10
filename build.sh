#!/bin/bash

# Nmap Training Platform - Build and Deployment Script
# This script automates the entire build and verification process

set -e  # Exit on any error

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Nmap Training Platform - Build Script v1.0           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Step 1: Verify all required files exist
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Verifying required files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

REQUIRED_FILES=(
    "Dockerfile"
    "docker-compose.yml"
    "init-database.sql"
    "config.php"
    "index.html"
    "dashboard.html"
    "api/register.php"
    "api/login.php"
    "api/logout.php"
    "api/progress.php"
)

MISSING_FILES=0

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "$file exists"
    else
        print_error "$file is MISSING!"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    print_error "Missing $MISSING_FILES required files. Please create them before continuing."
    exit 1
fi

echo ""
print_success "All required files are present!"
echo ""

# Step 2: Create log directories
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Creating log directories..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

mkdir -p logs/apache
mkdir -p logs/mysql

print_success "Log directories created"
echo ""

# Step 3: Stop existing container if running
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Stopping existing containers..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if docker ps -a | grep -q vulnerable-target; then
    print_info "Stopping existing container..."
    docker-compose down -v
    print_success "Existing container stopped"
else
    print_info "No existing container found"
fi
echo ""

# Step 4: Build Docker image
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4: Building Docker image..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

docker-compose build --no-cache

if [ $? -eq 0 ]; then
    print_success "Docker image built successfully"
else
    print_error "Docker build failed!"
    exit 1
fi
echo ""

# Step 5: Start container
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5: Starting container..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

docker-compose up -d

if [ $? -eq 0 ]; then
    print_success "Container started successfully"
else
    print_error "Failed to start container!"
    exit 1
fi
echo ""

# Wait for services to initialize
print_info "Waiting 15 seconds for services to initialize..."
sleep 15
echo ""

# Step 6: Verify container is running
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 6: Verifying container status..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if docker ps | grep -q vulnerable-target; then
    print_success "Container is running"
else
    print_error "Container is not running!"
    docker-compose logs
    exit 1
fi
echo ""

# Step 7: Verify web files inside container
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 7: Verifying web files in container..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

WEB_FILES=(
    "/var/www/html/index.html"
    "/var/www/html/dashboard.html"
    "/var/www/html/config.php"
    "/var/www/html/api/register.php"
    "/var/www/html/api/login.php"
    "/var/www/html/api/logout.php"
    "/var/www/html/api/progress.php"
)

FILE_CHECK_FAILED=0

for file in "${WEB_FILES[@]}"; do
    if docker exec vulnerable-target test -f "$file"; then
        print_success "$file exists in container"
    else
        print_error "$file MISSING in container!"
        FILE_CHECK_FAILED=1
    fi
done

if [ $FILE_CHECK_FAILED -eq 1 ]; then
    print_error "Some web files are missing in the container!"
    print_info "Showing container /var/www/html/ contents:"
    docker exec vulnerable-target ls -la /var/www/html/
    exit 1
fi
echo ""

# Step 8: Verify MySQL is running
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 8: Verifying MySQL service..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if docker exec vulnerable-target service mariadb status | grep -q "active"; then
    print_success "MySQL is running"
else
    print_error "MySQL is not running!"
    docker exec vulnerable-target service mariadb status
    exit 1
fi
echo ""

# Step 9: Verify database exists
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 9: Verifying database..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

DB_CHECK=$(docker exec vulnerable-target mysql -u nmap_user -pnmap_secure_password_2024 -e "SHOW DATABASES LIKE 'nmap_training';" 2>/dev/null | grep -c "nmap_training" || true)

if [ "$DB_CHECK" -eq "1" ]; then
    print_success "Database 'nmap_training' exists"
else
    print_error "Database 'nmap_training' does not exist!"
    exit 1
fi

# Check tables
TABLES=$(docker exec vulnerable-target mysql -u nmap_user -pnmap_secure_password_2024 -e "USE nmap_training; SHOW TABLES;" 2>/dev/null | tail -n +2)

if echo "$TABLES" | grep -q "users"; then
    print_success "Table 'users' exists"
else
    print_error "Table 'users' does not exist!"
    exit 1
fi

if echo "$TABLES" | grep -q "user_progress"; then
    print_success "Table 'user_progress' exists"
else
    print_error "Table 'user_progress' does not exist!"
    exit 1
fi

if echo "$TABLES" | grep -q "flags"; then
    print_success "Table 'flags' exists"
else
    print_error "Table 'flags' does not exist!"
    exit 1
fi
echo ""

# Step 10: Verify Apache is serving
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 10: Verifying Apache web server..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null || echo "000")

if [ "$HTTP_RESPONSE" == "200" ]; then
    print_success "Apache is serving HTTP requests (Status: 200)"
else
    print_warning "Apache returned status code: $HTTP_RESPONSE"
fi
echo ""

# Step 11: Test API endpoints
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 11: Testing API endpoints..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test login endpoint with admin credentials
print_info "Testing login endpoint..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/login.php \
    -H "Content-Type: application/json" \
    -d '{"email":"admin@nmaptraining.local","password":"admin123"}' 2>/dev/null || echo '{"success":false}')

if echo "$LOGIN_RESPONSE" | grep -q '"success":true'; then
    print_success "Login API is working (admin credentials verified)"
else
    print_error "Login API test failed!"
    echo "Response: $LOGIN_RESPONSE"
fi
echo ""

# Final summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    BUILD SUMMARY                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
print_success "Container is running and all services are operational!"
echo ""
echo "Access Information:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🌐 Web Interface:  http://localhost:8080/"
echo "  📧 Admin Email:    admin@nmaptraining.local"
echo "  🔑 Admin Password: admin123"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Useful Commands:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  View logs:         docker-compose logs -f"
echo "  Stop container:    docker-compose down"
echo "  Restart:           docker-compose restart"
echo "  Shell access:      docker exec -it vulnerable-target bash"
echo "  Apache logs:       docker exec -it vulnerable-target tail -f /var/log/apache2/error.log"
echo "  MySQL CLI:         docker exec -it vulnerable-target mysql -u nmap_user -pnmap_secure_password_2024 nmap_training"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_success "Deployment completed successfully! 🚀"
echo ""
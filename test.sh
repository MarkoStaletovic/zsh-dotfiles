#!/bin/bash

# Test Installation Script
# This script tests the installation in a safe way

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║           Testing Installation         ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Test 1: Check if all required files exist
log_info "Checking required files..."

required_files=(
    "install.sh"
    "uninstall.sh" 
    "verify.sh"
    ".zshrc"
    "README.md"
    "MANUAL.md"
    ".gitignore"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        log_success "Found $file"
    else
        log_error "Missing $file"
        exit 1
    fi
done

# Test 2: Check if scripts are executable
log_info "Checking script permissions..."

executable_files=(
    "install.sh"
    "uninstall.sh"
    "verify.sh"
)

for file in "${executable_files[@]}"; do
    if [ -x "$file" ]; then
        log_success "$file is executable"
    else
        log_error "$file is not executable"
        exit 1
    fi
done

# Test 3: Check .zshrc content
log_info "Checking .zshrc configuration..."

if grep -q "oh-my-zsh" .zshrc; then
    log_success ".zshrc contains oh-my-zsh configuration"
else
    log_error ".zshrc missing oh-my-zsh configuration"
    exit 1
fi

if grep -q "zsh-autosuggestions" .zshrc; then
    log_success ".zshrc includes zsh-autosuggestions plugin"
else
    log_error ".zshrc missing zsh-autosuggestions plugin"
    exit 1
fi

if grep -q "zsh-syntax-highlighting" .zshrc; then
    log_success ".zshrc includes zsh-syntax-highlighting plugin"
else
    log_error ".zshrc missing zsh-syntax-highlighting plugin"
    exit 1
fi

# Test 4: Check script syntax
log_info "Checking script syntax..."

for script in install.sh uninstall.sh verify.sh; do
    if bash -n "$script"; then
        log_success "$script has valid syntax"
    else
        log_error "$script has syntax errors"
        exit 1
    fi
done

echo -e "\n${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║           All Tests Passed!            ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GREEN}✓ Repository is ready for distribution${NC}"
echo "You can now:"
echo "1. Push to a Git hosting service (GitHub, GitLab, etc.)"
echo "2. Test the installation on a fresh Ubuntu system"
echo "3. Share the repository URL for others to use"

#!/bin/bash

# ZSH Configuration Verification Script
# This script checks if your zsh setup is correctly installed

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0

# Test functions
test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

test_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║       ZSH Configuration Checker        ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Check if zsh is installed
echo -e "\n${BLUE}Checking zsh installation...${NC}"
if command -v zsh >/dev/null 2>&1; then
    test_pass "zsh is installed ($(zsh --version))"
else
    test_fail "zsh is not installed"
fi

# Check if zsh is the default shell
echo -e "\n${BLUE}Checking default shell...${NC}"
if [ "$SHELL" = "$(which zsh)" ]; then
    test_pass "zsh is the default shell"
else
    test_warning "zsh is not the default shell (current: $SHELL)"
    echo "  Run: chsh -s $(which zsh)"
fi

# Check Oh My Zsh installation
echo -e "\n${BLUE}Checking Oh My Zsh...${NC}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    test_pass "Oh My Zsh is installed"
    
    # Check if ZSH variable is set correctly
    if [ -n "$ZSH" ] && [ "$ZSH" = "$HOME/.oh-my-zsh" ]; then
        test_pass "ZSH environment variable is correctly set"
    else
        test_warning "ZSH environment variable may not be set correctly"
    fi
else
    test_fail "Oh My Zsh is not installed"
fi

# Check .zshrc file
echo -e "\n${BLUE}Checking configuration files...${NC}"
if [ -f "$HOME/.zshrc" ]; then
    test_pass ".zshrc exists"
    
    # Check for important configurations
    if grep -q "ZSH_THEME=\"robbyrussell\"" "$HOME/.zshrc"; then
        test_pass "robbyrussell theme is configured"
    else
        test_warning "robbyrussell theme may not be configured"
    fi
    
    if grep -q "plugins=(.*git.*zsh-autosuggestions.*zsh-syntax-highlighting.*)" "$HOME/.zshrc"; then
        test_pass "Required plugins are configured"
    else
        test_warning "Plugin configuration may be incomplete"
    fi
else
    test_fail ".zshrc does not exist"
fi

# Check custom plugins
echo -e "\n${BLUE}Checking custom plugins...${NC}"

# zsh-autosuggestions
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    test_pass "zsh-autosuggestions plugin is installed"
else
    test_fail "zsh-autosuggestions plugin is missing"
fi

# zsh-syntax-highlighting
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    test_pass "zsh-syntax-highlighting plugin is installed"
else
    test_fail "zsh-syntax-highlighting plugin is missing"
fi

# Check if running in zsh
echo -e "\n${BLUE}Checking current shell...${NC}"
if [ -n "$ZSH_VERSION" ]; then
    test_pass "Currently running in zsh"
else
    test_warning "Not currently running in zsh (run 'exec zsh' to switch)"
fi

# Summary
echo -e "\n${BLUE}╔════════════════════════════════════════╗"
echo "║                Summary                 ║"
echo "╚════════════════════════════════════════╝${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! ($PASSED passed)${NC}"
    echo "Your zsh setup is working correctly."
else
    echo -e "${RED}✗ Some checks failed ($FAILED failed, $PASSED passed)${NC}"
    echo "Please review the failed checks above and fix any issues."
fi

if [ $PASSED -gt 0 ] && [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 Your zsh configuration is ready to use!${NC}"
fi

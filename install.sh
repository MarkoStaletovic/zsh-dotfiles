#!/bin/bash

# ZSH Dotfiles Installation Script for Ubuntu 22.04+
# This script sets up zsh with oh-my-zsh and custom plugins

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu
check_ubuntu() {
    if ! grep -q "Ubuntu" /etc/os-release; then
        log_warning "This script is designed for Ubuntu. Proceeding anyway..."
    fi
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    log_success "System updated"
}

# Install required packages
install_packages() {
    log_info "Installing required packages..."
    sudo apt install -y zsh git curl wget
    log_success "Required packages installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    log_info "Installing Oh My Zsh..."
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh My Zsh already installed, skipping..."
        return
    fi
    
    # Install Oh My Zsh non-interactively
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log_success "Oh My Zsh installed"
}

# Install zsh-autosuggestions plugin
install_autosuggestions() {
    log_info "Installing zsh-autosuggestions plugin..."
    
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    
    if [ -d "$plugin_dir" ]; then
        log_warning "zsh-autosuggestions already installed, updating..."
        cd "$plugin_dir" && git pull
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir"
    fi
    
    log_success "zsh-autosuggestions installed"
}

# Install zsh-syntax-highlighting plugin
install_syntax_highlighting() {
    log_info "Installing zsh-syntax-highlighting plugin..."
    
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    
    if [ -d "$plugin_dir" ]; then
        log_warning "zsh-syntax-highlighting already installed, updating..."
        cd "$plugin_dir" && git pull
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir"
    fi
    
    log_success "zsh-syntax-highlighting installed"
}

# Copy configuration files
copy_config_files() {
    log_info "Copying configuration files..."
    
    # Backup existing .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backed up existing .zshrc"
    fi
    
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Copy .zshrc
    if [ -f "$SCRIPT_DIR/.zshrc" ]; then
        cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
        log_success "Copied .zshrc"
    else
        cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
        log_success "Copied zshrc"
    fi
}

# Set zsh as default shell
set_default_shell() {
    log_info "Setting zsh as default shell..."
    
    if [ "$SHELL" = "$(which zsh)" ]; then
        log_warning "zsh is already the default shell"
        return
    fi
    
    # Add zsh to valid shells if not already there
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi
    
    # Change default shell
    sudo chsh -s "$(which zsh)" "$USER"
    log_success "Default shell set to zsh"
}

# Main installation function
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║        ZSH Dotfiles Installation       ║"
    echo "║              Ubuntu 22.04+            ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_info "Starting installation..."
    
    check_ubuntu
    update_system
    install_packages
    install_oh_my_zsh
    install_autosuggestions
    install_syntax_highlighting
    copy_config_files
    set_default_shell
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║           Installation Complete!       ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_success "Installation completed successfully!"
    log_info "Please restart your terminal or run 'exec zsh' to start using your new shell"
    log_info "You may need to log out and log back in for the default shell change to take effect"
}

# Run main function
main "$@"

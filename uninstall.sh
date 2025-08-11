#!/bin/bash

# ZSH Dotfiles Uninstallation Script
# This script removes the zsh setup and restores bash as default

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Confirm uninstallation
confirm_uninstall() {
    echo -e "${YELLOW}"
    echo "╔════════════════════════════════════════╗"
    echo "║           Uninstall ZSH Setup          ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_warning "This will:"
    echo "  - Remove Oh My Zsh and all plugins"
    echo "  - Restore your .zshrc backup (if available)"
    echo "  - Set bash as your default shell"
    echo
    
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstallation cancelled."
        exit 0
    fi
}

# Remove Oh My Zsh
remove_oh_my_zsh() {
    log_info "Removing Oh My Zsh..."
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh"
        log_success "Oh My Zsh removed"
    else
        log_warning "Oh My Zsh not found"
    fi
}

# Restore zshrc backup
restore_zshrc() {
    log_info "Restoring .zshrc backup..."
    
    # Find the most recent backup
    BACKUP_FILE=$(ls -t "$HOME"/.zshrc.backup.* 2>/dev/null | head -n 1)
    
    if [ -n "$BACKUP_FILE" ]; then
        cp "$BACKUP_FILE" "$HOME/.zshrc"
        log_success "Restored .zshrc from backup: $(basename "$BACKUP_FILE")"
    else
        log_warning "No .zshrc backup found, removing current .zshrc"
        rm -f "$HOME/.zshrc"
    fi
}

# Set bash as default shell
set_bash_default() {
    log_info "Setting bash as default shell..."
    
    if [ "$SHELL" = "/bin/bash" ]; then
        log_warning "bash is already the default shell"
        return
    fi
    
    sudo chsh -s /bin/bash "$USER"
    log_success "Default shell set to bash"
}

# Clean up environment variables
cleanup_env() {
    log_info "Cleaning up environment..."
    
    # Remove ZSH-related exports from common files
    for file in ~/.bashrc ~/.bash_profile ~/.profile; do
        if [ -f "$file" ]; then
            # Remove ZSH variable exports
            sed -i '/export ZSH=/d' "$file" 2>/dev/null || true
            sed -i '/export ZSH_THEME=/d' "$file" 2>/dev/null || true
        fi
    done
    
    log_success "Environment cleaned up"
}

# Main uninstallation
main() {
    confirm_uninstall
    
    log_info "Starting uninstallation..."
    
    remove_oh_my_zsh
    restore_zshrc
    set_bash_default
    cleanup_env
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║        Uninstallation Complete!        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_success "ZSH setup has been removed"
    log_info "Please restart your terminal or log out and log back in"
    log_info "Your default shell is now bash"
    
    # Show remaining backup files
    BACKUPS=$(ls "$HOME"/.zshrc.backup.* 2>/dev/null | wc -l)
    if [ "$BACKUPS" -gt 0 ]; then
        log_info "Found $BACKUPS .zshrc backup files in your home directory"
        log_info "You can safely remove them with: rm ~/.zshrc.backup.*"
    fi
}

main "$@"

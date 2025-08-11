# ZSH Dotfiles Setup

This repository contains my zsh configuration and an automated setup script for Ubuntu 22.04+ systems.

## Features

- Oh My Zsh installation and configuration
- Custom plugins: zsh-autosuggestions, zsh-syntax-highlighting
- Robbyrussell theme
- Optimized history settings
- Git integration

## Quick Setup

Run this one-liner on a fresh Ubuntu installation:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/zsh-dotfiles/main/install.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/yourusername/zsh-dotfiles.git
cd zsh-dotfiles
chmod +x install.sh
./install.sh
```

## What the script does

1. Updates system packages
2. Installs zsh and dependencies
3. Installs Oh My Zsh
4. Installs custom plugins (zsh-autosuggestions, zsh-syntax-highlighting)
5. Copies configuration files
6. Sets zsh as default shell

## Manual Installation

If you prefer to install manually, see the [manual installation guide](MANUAL.md).

## Customization

After installation, you can customize further by editing:
- `~/.zshrc` - Main zsh configuration
- `~/.oh-my-zsh/custom/` - Custom plugins and themes

## Requirements

- Ubuntu 22.04+ (tested)
- Internet connection for downloads
- Sudo privileges

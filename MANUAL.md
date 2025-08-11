# Manual Installation Guide

If you prefer to install manually or the automated script doesn't work for your system, follow these steps:

## Prerequisites

1. Update your system:
```bash
sudo apt update && sudo apt upgrade -y
```

2. Install required packages:
```bash
sudo apt install -y zsh git curl wget
```

## Step 1: Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Step 2: Install Custom Plugins

### zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### zsh-syntax-highlighting
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Step 3: Copy Configuration

1. Backup your existing `.zshrc` (if it exists):
```bash
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
```

2. Copy the provided `.zshrc`:
```bash
cp .zshrc ~/.zshrc
# or
cp zshrc ~/.zshrc
```

## Step 4: Set Zsh as Default Shell

1. Add zsh to valid shells:
```bash
echo $(which zsh) | sudo tee -a /etc/shells
```

2. Change your default shell:
```bash
chsh -s $(which zsh)
```

## Step 5: Reload Configuration

Either restart your terminal or run:
```bash
exec zsh
```

## Troubleshooting

### Permission Issues
If you encounter permission issues, make sure you have sudo privileges and try running individual commands manually.

### Plugin Issues
If plugins don't work, verify they're correctly installed in:
- `~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/`
- `~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/`

### Shell Not Changing
If zsh doesn't become your default shell:
1. Log out and log back in
2. Check `/etc/shells` contains your zsh path
3. Verify with `echo $SHELL`

### Theme Issues
If the theme doesn't load correctly, ensure you have the `robbyrussell` theme (comes with oh-my-zsh by default).

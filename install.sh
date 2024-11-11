#!/usr/bin/env zsh

# Allow script to continue if a command fails
set -u

DOTFILES_DIR="$HOME/github/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles.bak"

# Check for Zsh4Humans
if [[ ! -f "$HOME/.zsh4humans/zsh4humans.zsh" ]]; then
    echo "Installing Zsh4Humans..."
    if command -v curl >/dev/null 2>&1; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    elif command -v wget >/dev/null 2>&1; then
        sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    else
        echo "⚠️  Neither curl nor wget is installed. Please install Zsh4Humans manually."
        exit 1
    fi
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Created backup directory at $BACKUP_DIR"

# Helper function to create symlinks with backup
link_file() {
    local src="$1"
    local dest="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Backup existing file/symlink if it exists
    if [[ -f "$dest" || -L "$dest" ]]; then
        local backup_path="$BACKUP_DIR/$(basename "$dest").$(date +%Y%m%d_%H%M%S)"
        mv "$dest" "$backup_path"
        echo "Backed up $dest to $backup_path"
    fi

    # Create symbolic link
    ln -sf "$src" "$dest"

    # Validate symlink
    if [[ -L "$dest" && -e "$dest" ]]; then
        echo "✓ Successfully linked $dest -> $src"
    else
        echo "⚠️  Failed to create symlink for $dest"
        return 1
    fi
}

echo "Installing dotfiles..."

# First: Core system configuration and package management
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Homebrew packages first as they include many dependencies
    if command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew packages..."
        if brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"; then
            echo "✓ Homebrew packages installed successfully"
        else
            echo "⚠️  Some Homebrew packages failed to install"
        fi
    else
        echo "⚠️  Homebrew is not installed. Skipping package installation."
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # DNF configuration if on Fedora/RHEL
    if command -v dnf >/dev/null 2>&1; then
        sudo mkdir -p /etc/dnf
        sudo cp "$DOTFILES_DIR/system/dnf.conf" /etc/dnf/dnf.conf
    fi
fi

# Second: Security and authentication setup
# SSH configuration (needed for Git)
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
mkdir -p "$HOME/.ssh/control"

# GPG configuration (needed for Git signing)
if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
    link_file "$DOTFILES_DIR/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
    chmod 600 "$HOME/.gnupg/gpg-agent.conf"
fi

# Third: Git configuration (depends on SSH and GPG)
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore"

# Fourth: Shell configuration
link_file "$DOTFILES_DIR/shell/.zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/shell/.aliases" "$HOME/.aliases"
link_file "$DOTFILES_DIR/shell/.aliases-git" "$HOME/.aliases-git"
link_file "$DOTFILES_DIR/shell/.env.zsh" "$HOME/.env.zsh"
link_file "$DOTFILES_DIR/shell/.functions.zsh" "$HOME/.functions.zsh"
link_file "$DOTFILES_DIR/shell/.p10k.zsh" "$HOME/.p10k.zsh"

# Fifth: OS-specific shell configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    link_file "$DOTFILES_DIR/shell/.darwin.zsh" "$HOME/.darwin.zsh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    link_file "$DOTFILES_DIR/shell/.linux.zsh" "$HOME/.linux.zsh"
fi

# Finally: Application configurations
# Kitty
mkdir -p "$CONFIG_DIR/kitty"
link_file "$DOTFILES_DIR/config/kitty/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"

# Htop
mkdir -p "$CONFIG_DIR/htop"
link_file "$DOTFILES_DIR/config/htop/htoprc" "$CONFIG_DIR/htop/htoprc"

# Zed (OS-specific paths)
if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p "$CONFIG_DIR/zed"
    link_file "$DOTFILES_DIR/config/zed/settings.json" "$CONFIG_DIR/zed/settings.json"
else
    mkdir -p "$CONFIG_DIR/zed.dev"
    link_file "$DOTFILES_DIR/config/zed/settings.json" "$CONFIG_DIR/zed.dev/settings.json"
fi

echo "✨ Dotfiles installation complete!"
echo "Your old configs have been backed up to $BACKUP_DIR"
echo "Please restart your shell for changes to take effect."

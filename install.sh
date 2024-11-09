#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$HOME/github/dotfiles"
CONFIG_DIR="$HOME/.config"

# Helper function to create symlinks with backup
link_file() {
    local src="$1"
    local dest="$2"

    # Backup existing file if it's not a symlink
    if [[ -f "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "${dest}.backup"
        echo "Backed up $dest to ${dest}.backup"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symbolic link
    ln -svf "$src" "$dest"
}

echo "Installing dotfiles..."

# Shell configuration
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
link_file "$DOTFILES_DIR/.aliases-git" "$HOME/.aliases-git"
link_file "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# Git configuration
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"

# SSH configuration
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
link_file "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"

# Kitty configuration
if command -v kitty >/dev/null 2>&1; then
    mkdir -p "$CONFIG_DIR/kitty"
    link_file "$DOTFILES_DIR/misc/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"
fi

# htop configuration
mkdir -p "$CONFIG_DIR/htop"
link_file "$DOTFILES_DIR/misc/htoprc" "$CONFIG_DIR/htop/htoprc"

# OS specific configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific configuration
    link_file "$DOTFILES_DIR/.linux.zsh" "$HOME/.linux.zsh"

    # DNF configuration if on Fedora/RHEL
    if command -v dnf >/dev/null 2>&1; then
        sudo mkdir -p /etc/dnf
        sudo cp "$DOTFILES_DIR/misc/dnf.conf" /etc/dnf/dnf.conf
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific configuration
    link_file "$DOTFILES_DIR/.darwin.zsh" "$HOME/.darwin.zsh"

    # GPG configuration
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
    link_file "$DOTFILES_DIR/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
    chmod 600 "$HOME/.gnupg/gpg-agent.conf"

    # Zed configuration
    if command -v zed >/dev/null 2>&1; then
        mkdir -p "$CONFIG_DIR/zed"
        link_file "$DOTFILES_DIR/misc/zed/settings.json" "$CONFIG_DIR/zed/settings.json"
    fi

    # Install Homebrew if not already installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    if [[ -f "$DOTFILES_DIR/misc/Brewfile" ]]; then
        echo "Installing Homebrew packages..."
        brew bundle --file="$DOTFILES_DIR/misc/Brewfile"
    fi
fi

echo "✨ Dotfiles installation complete!"
echo "Please restart your shell for changes to take effect."

# Final reminders
cat << EOF

🔍 Post-installation steps:
1. Restart your shell or source your .zshrc: source ~/.zshrc
2. If using GPG, remember to set up your keys
3. Check that all symlinks are correct: ls -la ~
4. If on macOS, Homebrew packages have been installed

For more information, visit: https://github.com/nijaru/dotfiles
EOF

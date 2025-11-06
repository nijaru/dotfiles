#!/usr/bin/env fish
# macOS specific configuration and utilities for Fish shell

###################
# Homebrew Management
###################

# Homebrew abbreviations
if command -v brew >/dev/null 2>&1
    abbr --add brews "brew search"                  # Search packages
    abbr --add brewin "brew info"                   # Package info
    abbr --add brewi "brew install"                 # Install package
    abbr --add brewu "brew update && brew upgrade"  # Update and upgrade
    abbr --add brewx "brew uninstall"               # Uninstall package
    abbr --add brewl "brew list"                    # List installed packages
    abbr --add brewc "brew cleanup"                 # Clean up old versions

    # Homebrew Cask abbreviations
    abbr --add caskin "brew info --cask"            # Cask info
    abbr --add casks "brew search --cask"           # Search casks
    abbr --add caski "brew install --cask"          # Install cask
    abbr --add caskx "brew uninstall --cask"        # Uninstall cask
    abbr --add caskl "brew list --cask"             # List installed casks
end

###################
# macOS Utilities
###################

# System commands
if command -v diskutil >/dev/null 2>&1
    abbr --add disk diskutil
end
if command -v gtar >/dev/null 2>&1
    abbr --add tar gtar
end
abbr --add o open
abbr --add o. 'open .'
abbr --add oa 'open -a'
abbr --add reveal 'open -R'
abbr --add finder 'open -a Finder'

# File operations
abbr --add showfiles 'defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
abbr --add hidefiles 'defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
if command -v qlmanage >/dev/null 2>&1
    abbr --add ql 'qlmanage -p'
end

# Clipboard operations
abbr --add clip pbcopy
abbr --add paste pbpaste

###################
# SSH Session Setup
###################

# Unlock keychain and load SSH keys when connecting via SSH
# This enables git signing and Claude Code OAuth access
if set -q SSH_CLIENT; or set -q SSH_TTY
    if not set -q SSH_KEYS_LOADED
        echo "Unlocking keychain and loading SSH keys..."
        security unlock-keychain ~/Library/Keychains/login.keychain-db
        and ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
        and set -gx SSH_KEYS_LOADED true
        and set -gx KEYCHAIN_UNLOCKED true
        and echo "SSH keys loaded successfully"
    end
end

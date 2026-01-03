#!/usr/bin/env fish
# macOS specific configuration for Fish shell

###################
# Homebrew
###################
if command -v brew >/dev/null 2>&1
    abbr --add brews "brew search"
    abbr --add brewi "brew install"
    abbr --add brewu "brew update && brew upgrade"
end

###################
# macOS Utilities
###################
abbr --add o open
abbr --add o. 'open .'

# Clipboard
abbr --add clip pbcopy
abbr --add paste pbpaste

###################
# SSH Agent Setup
###################

# Ensure SSH_AUTH_SOCK is set from launchd (local sessions)
if not set -q SSH_AUTH_SOCK
    set -l sock (launchctl getenv SSH_AUTH_SOCK 2>/dev/null)
    if test -n "$sock" -a -S "$sock"
        set -gx SSH_AUTH_SOCK $sock
    else
        launchctl kickstart -k gui/(id -u)/com.openssh.ssh-agent 2>/dev/null
        sleep 0.5
        set -l new_sock (launchctl getenv SSH_AUTH_SOCK 2>/dev/null)
        if test -n "$new_sock" -a -S "$new_sock"
            set -gx SSH_AUTH_SOCK $new_sock
        end
    end
end

# Unlock keychain and load SSH keys when connecting via SSH
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

function claude --description "Claude CLI wrapper with macOS Keychain unlock for SSH sessions"
    # Unlock keychain if in SSH session and not already unlocked
    if set -q SSH_CONNECTION; and not set -q KEYCHAIN_UNLOCKED
        security unlock-keychain ~/Library/Keychains/login.keychain-db
        set -gx KEYCHAIN_UNLOCKED true
    end

    # Run the actual claude command
    command claude $argv
end

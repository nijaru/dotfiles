#!/usr/bin/env fish
# Configure rustup settings
# This runs whenever this file changes or toolchain settings need sync

if not type -q rustup
    # If rustup was just installed in the same run, we might need to source env
    if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
    else
        echo "rustup not found, skipping configuration"
        exit 0
    end
end

echo "Configuring rustup..."
rustup set auto-install enable
rustup default stable

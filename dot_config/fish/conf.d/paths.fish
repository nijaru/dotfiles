#!/usr/bin/env fish
# Fish path configuration
# Fish handles path deduplication automatically
# Note: Homebrew PATH is handled by 'brew shellenv' in env.fish

# Universal development tool paths (cross-platform)
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin  
fish_add_path $HOME/.mise/bin
fish_add_path $HOME/.modular/bin
fish_add_path $HOME/.local/share/gem/bin

# Platform-specific paths (non-Homebrew)
switch (uname -s)
    case Linux
        # Add any Linux-specific paths here if needed
        # e.g., fish_add_path /usr/local/bin
    case Darwin
        # macOS-specific non-Homebrew paths
        # Homebrew paths are handled by 'brew shellenv' in env.fish
end
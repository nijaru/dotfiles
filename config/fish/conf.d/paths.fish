#!/usr/bin/env fish
# Fish path configuration
# Fish handles path deduplication automatically

# Add all essential paths
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin  
fish_add_path $HOME/.mise/bin
fish_add_path $HOME/.modular/bin
fish_add_path $HOME/.gem/bin

# Homebrew paths for macOS
if test (uname -s) = "Darwin"
    switch (uname -m)
        case arm64 aarch64
            if test -d /opt/homebrew/bin
                fish_add_path /opt/homebrew/bin
                fish_add_path /opt/homebrew/sbin
            end
        case '*'
            if test -d /usr/local/bin
                fish_add_path /usr/local/bin
                fish_add_path /usr/local/sbin
            end
    end
end
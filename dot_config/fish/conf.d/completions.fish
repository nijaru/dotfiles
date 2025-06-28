#!/usr/bin/env fish
# Fish completions configuration

# Enable completions
set -g fish_complete_path $fish_complete_path ~/.config/fish/completions

# Git completions if not built in
if not type -q __fish_git_prompt
    if test -f /usr/share/fish/completions/git.fish
        source /usr/share/fish/completions/git.fish
    end
end

# Docker completions
if command -v docker >/dev/null 2>&1
    # Fish handles this automatically in newer versions
end

# Kubectl completions
if command -v kubectl >/dev/null 2>&1
    # Generate kubectl completions if not present
    if not test -f ~/.config/fish/completions/kubectl.fish
        kubectl completion fish > ~/.config/fish/completions/kubectl.fish
    end
end

# mise completions and activation
if command -v mise >/dev/null 2>&1
    # Activate mise for runtime version management
    mise activate fish | source
    # Load completions
    mise completion fish | source
end

# Modern CLI tools
if command -v zoxide >/dev/null 2>&1
    # Initialize zoxide (intelligent cd command)
    zoxide init fish | source
end
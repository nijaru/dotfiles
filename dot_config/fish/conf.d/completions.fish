#!/usr/bin/env fish
# Fish completions configuration

# Only run in interactive shells for better startup performance
if status is-interactive
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
end
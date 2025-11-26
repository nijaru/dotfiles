#!/usr/bin/env fish
# Fish completions configuration

# Only run in interactive shells
if status is-interactive
    # Enable completions
    set -g fish_complete_path $fish_complete_path ~/.config/fish/completions

    # Git completions if not built in
    if not type -q __fish_git_prompt
        if test -f /usr/share/fish/completions/git.fish
            source /usr/share/fish/completions/git.fish
        end
    end

    # mise and zoxide are lazy-loaded in dev.fish or config.fish
end
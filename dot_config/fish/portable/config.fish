#!/usr/bin/env fish
# Portable Fish config - minimal, fast, transfers quickly over SSH

# Disable greeting
set -g fish_greeting

# Enhanced history
set -g fish_history_size 10000

# Basic colors
set -g fish_color_command green
set -g fish_color_error red
set -g fish_color_param normal

# Modern CLI aliases with fallbacks
if command -v eza >/dev/null 2>&1
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias lt='eza -T'
else
    alias ll='ls -lh'
    alias la='ls -lah'
end

if command -v bat >/dev/null 2>&1
    alias cat='bat --style=plain'
end

if command -v rg >/dev/null 2>&1
    alias grep='rg'
end

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline -10'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Essential functions
function mkcd -d "Create directory and cd into it"
    mkdir -p $argv[1] && cd $argv[1]
end

function command_exists -d "Check if command exists"
    command -v $argv[1] >/dev/null 2>&1
end

# Prompt - simple and fast
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd)

    # Red prompt on error, green otherwise
    if test $last_status -ne 0
        set_color red
    else
        set_color green
    end

    echo -n "[$cwd] "
    set_color normal
end

function fish_right_prompt
    # Git status if in git repo
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git branch --show-current 2>/dev/null)
        if test -n "$branch"
            set_color yellow
            echo -n "($branch)"
            set_color normal
        end
    end
end

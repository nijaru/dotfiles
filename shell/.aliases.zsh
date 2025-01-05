#!/usr/bin/env zsh
# ~/.aliases.zsh

# Ensure `command_exists` function is available
if ! type command_exists >/dev/null 2>&1; then
    function command_exists() {
        command -v "$1" >/dev/null 2>&1
    }
fi

###############################################################################
# Editor Aliases
###############################################################################
alias e.="e ."
alias z.="z ."
alias z.="z ."
alias zp.="zp ."
alias c.="c ."
alias v.="v ."
alias hx.="hx ."

###############################################################################
# Modern CLI Replacements
###############################################################################

# File Operations & Viewing
# ------------------------
if command_exists bat; then
    # Replace 'cat' with 'bat' and set default arguments
    alias cat='bat --plain --paging=never'
fi

if command_exists moar; then
    # Replace 'less' with 'moar'
    alias less='moar'
fi

if command_exists eza; then
    # Replace 'ls' with 'eza' and set default arguments
    alias ls='eza --icons --git'
    # Aliases for common 'ls' options
    alias l='ls -1'      # Long listing
    alias ll='ls -l'     # Detailed listing
    alias la='ls -a'     # Show hidden files
    alias lsa='ls -a'    # Show hidden files
    alias lla='ls -la'   # Long with hidden
    alias tree='ls -T'   # Tree view
    alias lt='ls -T'     # Tree view
    alias ltd='ls -T -L' # Tree view with depth
fi

# Search and Navigation
# --------------------
command_exists rg && alias grep='rg'
command_exists fd && alias find='fd'
command_exists fzf && command_exists bat && alias preview="fzf --preview 'bat --color=always {}'"

# System Monitoring
# ----------------
command_exists duf && alias df='duf'
command_exists dust && alias du='dust'
command_exists procs && alias ps='procs'
command_exists btop && alias top='btop'
command_exists hyperfine && alias hypf='hyperfine -N --warmup 5'

# File Comparison & Network
# ------------------------
command_exists delta && alias diff='delta'
command_exists doggo && alias dig='doggo'
command_exists gping && alias ping='gping'

###############################################################################
# Safe File Operations
###############################################################################

# Core Operations
alias t="touch"         # Create file
alias rmd="rmdir"       # Remove directory
alias rmrf="rm -rf"     # Force removal
alias mkd="mkdir -pv"   # Recursive mkdir
alias mkdir="mkdir -pv" # Recursive mkdir
alias ez="exec zsh"     # Restart shell

# Advanced Operations
alias cpv="rsync -ah --info=progress2"                       # Copy with progress
alias mvv="rsync -ah --remove-source-files --info=progress2" # Move with progress
alias symlink="ln -sf"                                       # Force symlink

###############################################################################
# Directory Navigation
###############################################################################

# Quick Traversal
alias ..="cd .."         # Up one level
alias ...="cd ../.."     # Up two levels
alias ....="cd ../../.." # Up three levels
alias -- -="cd -"        # Previous directory
alias d='dirs -v'        # Directory stack

# Common Directories
alias dl="cd ~/Downloads"  # Go to Downloads
alias doc="cd ~/Documents" # Go to Documents
alias dt="cd ~/Desktop"    # Go to Desktop
alias p="cd ~/Projects"    # Go to Projects
alias ghub="cd ~/github"   # Go to GitHub

#!/usr/bin/env zsh
# Core aliases and shell utilities
# Source additional alias files as needed

# Source git aliases
z4h source ~/.git.zsh

###############################################################################
# Editor Aliases
###############################################################################
alias e="$EDITOR"
alias z="zed"
alias z.="zed ."
alias c="code"
alias c.="code ."
alias v="nvim"
alias v.="nvim ."

###############################################################################
# Modern CLI Replacements
###############################################################################

# File Operations & Viewing
# ------------------------
command_exists bat && alias cat="bat --plain --paging=never" # Enhanced file viewing
command_exists moar && alias less="moar"                     # Better pager

# Enhanced ls with eza
if command_exists eza; then
    alias ls="eza --icons --git"      # Basic listing
    alias l="eza -l --icons --git"    # Long listing
    alias ll="eza -l --icons --git"   # Detailed listing
    alias la="eza -a --icons --git"   # Show hidden files
    alias lla="eza -la --icons --git" # Long with hidden
    alias lt="eza -T --icons --git"   # Tree listing
    alias tree="eza --tree --icons"   # Tree view
fi

# Search and Navigation
# --------------------
command_exists rg && alias grep="rg" # Better text search
command_exists fd && alias find="fd" # Better file search
command_exists fzf &&
    alias preview="fzf --preview 'bat --color=always {}'" # Interactive preview

# System Monitoring
# ----------------
command_exists duf && alias df="duf"            # Better disk usage
command_exists dust && alias du="dust"          # Better dir usage
command_exists procs && alias ps="procs"        # Better process view
command_exists btop && alias top="btop"         # Better system monitor
command_exists htop && alias htop="htop --tree" # Tree process view

# File Comparison & Network
# ------------------------
command_exists delta && alias diff="delta" # Better diff tool
command_exists doggo && alias dig="doggo"  # Better DNS lookup
command_exists gping && alias ping="gping" # Visual ping tool

###############################################################################
# Safe File Operations
###############################################################################

# Core Operations
alias t="touch"         # Create file
alias rm="rm -i"        # Safe removal
alias rmd="rmdir"       # Remove directory
alias rmrf="rm -rf"     # Force removal
alias cp="cp -ia"       # Safe copy
alias mv="mv -i"        # Safe move
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

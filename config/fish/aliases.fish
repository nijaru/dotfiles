#!/usr/bin/env fish
# Fish shell aliases

# Helper function command_exists is now in functions/command_exists.fish

###############################################################################
# Editor Aliases
###############################################################################
abbr -a e. "$EDITOR ."
abbr -a z. "zed ."
abbr -a zp. "zed ."
abbr -a c. "code ."
abbr -a v. "nvim ."
abbr -a hx. "helix ."

###############################################################################
# Modern CLI Replacements
###############################################################################

# File Operations & Viewing
# ------------------------
if type -q bat
    # Replace 'cat' with 'bat' and set default arguments
    abbr -a cat 'bat --plain --paging=never'
end

if type -q moar
    # Replace 'less' with 'moar'
    abbr -a less 'moar'
end

if type -q eza
    # Replace 'ls' with 'eza' and set default arguments
    abbr -a ls 'eza --icons --git'
    # Aliases for common 'ls' options
    abbr -a l 'ls -1'    # Long listing
    abbr -a ll 'ls -l'   # Detailed listing
    abbr -a la 'ls -a'   # Show hidden files
    abbr -a lsa 'ls -a'  # Show hidden files
    abbr -a lla 'ls -la' # Long with hidden
    # Tree view
    abbr -a tree 'ls -T'       # Tree view
    abbr -a lt 'ls -T'         # Tree view
    abbr -a llt 'ls -T -l'     # Tree view long
    abbr -a ltd 'ls -T -L'     # Tree view with depth
    abbr -a lltd 'ls -T -l -L' # Tree view long with depth
end

# Search and Navigation
# --------------------
type -q rg; and abbr -a grep 'rg'
type -q fd; and abbr -a find 'fd'
if type -q fzf; and type -q bat
    abbr -a preview "fzf --preview 'bat --color=always {}'"
end

# System Monitoring
# ----------------
type -q duf; and abbr -a df 'duf'
type -q dust; and abbr -a du 'dust'
type -q procs; and abbr -a ps 'procs'
type -q btop; and abbr -a top 'btop'
type -q hyperfine; and abbr -a hypf 'hyperfine -N --warmup 5'

# File Comparison & Network
# ------------------------
type -q delta; and abbr -a diff 'delta'
type -q doggo; and abbr -a dig 'doggo'
type -q gping; and abbr -a ping 'gping'

###############################################################################
# Safe File Operations
###############################################################################

# Core Operations
abbr -a t "touch"         # Create file
abbr -a rmd "rmdir"       # Remove directory
abbr -a rmrf "rm -rf"     # Force removal
abbr -a mkd "mkdir -p"    # Recursive mkdir
abbr -a mkdir "mkdir -p"  # Recursive mkdir
abbr -a ef "exec fish"    # Restart shell (fish equivalent of ez)

# Advanced Operations
if type -q rsync
    abbr -a cpv "rsync -ah --info=progress2"                       # Copy with progress
    abbr -a mvv "rsync -ah --remove-source-files --info=progress2" # Move with progress
end
abbr -a symlink "ln -sf"                                       # Force symlink

###############################################################################
# Directory Navigation
###############################################################################

# Quick Traversal (builtin in fish with 'cd ..' etc.)
# Fish also has 'prevd' and 'nextd' for directory stack
# Note: Using a function instead of alias for 'cd -' since dashes can't be used in alias names
# prev function is in functions/prev.fish
abbr -a d 'dirs'           # Directory stack

# Common Directories
abbr -a dl "cd ~/Downloads"  # Go to Downloads
abbr -a doc "cd ~/Documents" # Go to Documents
abbr -a dt "cd ~/Desktop"    # Go to Desktop
abbr -a p "cd ~/Projects"    # Go to Projects
abbr -a ghub "cd ~/github"   # Go to GitHub
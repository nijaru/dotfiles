#!/usr/bin/env zsh
# Core utility functions for shell environment
# Provides common operations and helper functions

###############################################################################
# Core Utilities
###############################################################################
# Check if a command exists
# Usage: command_exists git
function command_exists() {
    local cmd=$1

    # Check if it's a function
    whence -w "$cmd" | grep -q "^$cmd: function$" && return 0

    # Check if it's an alias
    whence -w "$cmd" | grep -q "^$cmd: alias$" && return 0

    # Check if it's a regular command
    if command -v "$cmd" >/dev/null 2>&1; then
        return 0
    fi

    # Special handling for Ruby gems
    if command -v gem >/dev/null 2>&1; then
        if gem list "^$cmd$" -i >/dev/null 2>&1; then
            return 0
        fi
    fi

    return 1
}

# Lazy load commands with error handling
# Usage: lazy_load "npm completion" npm
function lazy_load() {
    local load_cmd=$1
    local lazy_cmd=$2

    eval "function ${lazy_cmd}() {
        unfunction ${lazy_cmd}
        if ! eval \"\$(${load_cmd})\"; then
            echo \"Error loading ${lazy_cmd}\" >&2
            return 1
        fi
        ${lazy_cmd} \"\$@\"
    }"
}

# Add directory to PATH if it exists
# Usage: add_to_path /usr/local/bin
function add_to_path() {
    if [[ -d "$1" ]]; then
        path=("$1" $path)
    fi
}

# Clean PATH removing duplicates and invalid entries
function clean_path() {
    path=("${(@)path:#*/*//./*}")  # Remove invalid entries
    typeset -U PATH path           # Remove duplicates
}

###############################################################################
# File & Directory Operations
###############################################################################
# Create and enter directory with error handling
# Usage: mkcd dir1 dir2 dir3
function mkcd() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: mkcd <directory>" >&2
        return 1
    fi

    for dir in "$@"; do
        if mkdir -p "$dir"; then
            cd "$dir" || return 1
        else
            echo "Failed to create directory: $dir" >&2
            return 1
        fi
    done
}

# Find and cd into directory using fuzzy search
# Usage: cdf [search_path]
function cdf() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null |
          fzf --preview 'tree -C {} | head -100' \
              --header 'Select directory to enter' \
              --height '40%' \
              +m) && cd "$dir"
}

# Create and enter temporary directory
# Usage: tmpd [prefix]
function tmpd() {
    local prefix=${1:-tmp}
    local dir
    dir=$(mktemp -d 2>/dev/null || mktemp -d -t "${prefix}")

    if [[ ! -d "$dir" ]]; then
        echo "Failed to create temporary directory" >&2
        return 1
    fi

    echo "Created temporary directory: $dir"
    cd "$dir" || return 1
}

# Extract various archive formats
# Usage: extract archive.tar.gz
function extract() {
    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file" >&2
        return 1
    fi

    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.tar.zst)   tar --zstd -xf "$1"   ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)
            echo "'$1' cannot be extracted via extract()" >&2
            return 1
            ;;
    esac
}

# Create ZIP archive of files or folders
# Usage: compress directory-or-file [output.zip]
function compress() {
    local input=$1
    local output=${2:-"${1:t:r}.zip"}

    if [[ ! -e "$input" ]]; then
        echo "Error: '$input' does not exist" >&2
        return 1
    fi

    zip -r "$output" "$input"
    echo "Created archive: $output"
}

# Create timestamped backup of files
# Usage: backup file [file2 ...]
function backup() {
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            local backup="${file}.$(date +%Y%m%d_%H%M%S).bak"
            cp -a "$file" "$backup" && echo "Backup created: $backup"
        else
            echo "File not found: $file" >&2
            return 1
        fi
    done
}

###############################################################################
# System Operations
###############################################################################
# Profile command execution time
# Usage: timecmd command [args...]
function timecmd() {
    local start=$SECONDS
    "$@"
    local duration=$((SECONDS - start))
    echo "Execution time: ${duration}s"
}

# Generate secure password
# Usage: genpass [length]
function genpass() {
    local length=${1:-32}
    if [[ "$length" -lt 8 ]]; then
        echo "Password length must be at least 8 characters" >&2
        return 1
    fi

    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' </dev/urandom | head -c "$length"
    echo
}

# Generate UUID
# Usage: uuid
function uuid() {
    python3 -c "import uuid; print(uuid.uuid4())"
}

# Generate random string
# Usage: randstr [length] [charset]
function randstr() {
    local length=${1:-32}
    local charset=${2:-'A-Za-z0-9'}

    if [[ "$length" -lt 1 ]]; then
        echo "Length must be positive" >&2
        return 1
    fi

    LC_ALL=C tr -dc "$charset" </dev/urandom | head -c "$length"
    echo
}

###############################################################################
# Development Tools
###############################################################################
# Format JSON data from string or pipe
# Usage: jsonf '{"key": "value"}' or echo '{"key": "value"}' | jsonf
function jsonf() {
    if [[ -t 0 ]]; then  # If argument provided
        if [[ $# -eq 0 ]]; then
            echo "Usage: jsonf '<json-string>' or pipe JSON content" >&2
            return 1
        fi
        echo "$1" | python3 -m json.tool
    else  # If piped input
        python3 -m json.tool
    fi
}

# Calculator with interactive mode support
# Usage: calc [expression]
function calc() {
    if [[ $# -eq 0 ]]; then
        python3 -ic 'from math import *; import sys; sys.ps1="calc> "'
    else
        python3 -c "from math import *; print($*)"
    fi
}

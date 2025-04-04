# ~/.functions.zsh

# Core utility functions for the shell environment

###############################################################################
# General Utilities
###############################################################################

function aoc-input() {
    local session_cookie=${1:-$AOC_SESSION}
    local year=$(echo "$PWD" | grep -oE '[0-9]{4}' | head -1)
    local day=$(basename "$PWD" | tr -dc '0-9')
    curl --cookie "session=$session_cookie" \
        "https://adventofcode.com/$year/day/$day/input" >input.txt
}

###############################################################################
# Editor Functions
###############################################################################

# Open editor with automatic directory creation
function edit_with_mkdir() {
    local editor_name=$1
    shift || return 1

    # Use 'whence -p' in Zsh to locate the executable, ignoring functions and aliases
    local editor_path
    editor_path=$(whence -p "$editor_name")

    # Check if the editor executable was found
    if [[ -z "$editor_path" ]]; then
        echo "Error: Editor '$editor_name' not found in PATH." >&2
        return 1
    fi

    # If no arguments, launch the editor without opening any files
    if [[ $# -eq 0 ]]; then
        "$editor_path"
        return
    fi

    # Iterate through each argument to handle files or directories
    for arg in "$@"; do
        if [[ -d "$arg" ]]; then
            "$editor_path" "$arg"
        else
            local dir
            dir=$(dirname "$arg")
            if [[ ! -d "$dir" ]]; then
                mkdir -p "$dir" && echo "Created directory: $dir"
            fi
            "$editor_path" "$arg"
        fi
    done
}

# Wrapper functions for specific editors
# Basic editors
function t() { edit_with_mkdir touch "$@"; }
function e() { edit_with_mkdir "$EDITOR" "$@"; }
# GUI editors
function z() { edit_with_mkdir zed "$@"; }
function zp() { edit_with_mkdir zed-preview "$@"; }
function c() { edit_with_mkdir code "$@"; }
# Command line editors
function v() { edit_with_mkdir nvim "$@"; }
function hx() { edit_with_mkdir hx "$@"; }

###############################################################################
# File & Directory Operations
###############################################################################

# Create and enter directory
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
function cdf() {
    local dir
    dir=$(find ${1:-.} -type d 2>/dev/null |
        fzf --preview 'tree -C {} | head -100' \
            --header 'Select directory to enter' \
            --height '40%' \
            +m) && cd "$dir"
}

# Create and enter a temporary directory
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
function extract() {
    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file" >&2
        return 1
    fi

    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *)
        echo "'$1' cannot be extracted via extract()" >&2
        return 1
        ;;
    esac
}

# Create ZIP archive of files or folders
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

# Convert FLAC files to WAV
function flac2wav() {
    for file in *.flac; do
        # Skip if no flac files are found
        [ -e "$file" ] || continue

        wav_file="${file%.flac}.wav"
        if [ ! -f "$wav_file" ]; then
            echo "Converting $file to $wav_file"
            ffmpeg -i "$file" "$wav_file"
        else
            echo "Skipping $file, $wav_file already exists"
        fi
    done
}

###############################################################################
# System Operations
###############################################################################

# Profile command execution time
function timecmd() {
    local start=$SECONDS
    "$@"
    local duration=$((SECONDS - start))
    echo "Execution time: ${duration}s"
}

# Generate secure password
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
function uuid() {
    python3 -c "import uuid; print(uuid.uuid4())"
}

# Generate random string
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

# Format JSON data
function jsonf() {
    if [[ -t 0 ]]; then # If argument provided
        if [[ $# -eq 0 ]]; then
            echo "Usage: jsonf '<json-string>' or pipe JSON content" >&2
            return 1
        fi
        echo "$1" | python3 -m json.tool
    else # If piped input
        python3 -m json.tool
    fi
}

# Calculator with interactive mode support
function calc() {
    if [[ $# -eq 0 ]]; then
        python3 -ic 'from math import *; import sys; sys.ps1="calc> "'
    else
        python3 -c "from math import *; print($*)"
    fi
}

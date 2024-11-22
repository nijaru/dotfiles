# ~/.functions.zsh

# Core utility functions for the shell environment

###############################################################################
# Editor Functions
###############################################################################

# Open editor with automatic directory creation
function edit_with_mkdir() {
    local editor=$1
    shift || return 1 # Error if no editor specified

    # Validate editor exists
    if ! command -v "$editor" >/dev/null 2>&1; then
        echo "Error: Editor '$editor' not found" >&2
        return 1
    fi

    if [[ $# -eq 0 ]]; then
        # No arguments, just launch editor
        "$editor"
        return
    fi

    for arg in "$@"; do
        local dir
        if [[ -d "$arg" ]]; then
            "$editor" "$arg"
        else
            dir=$(dirname "$arg")
            if [[ ! -d "$dir" ]]; then
                mkdir -p "$dir" && echo "Created directory: $dir"
            fi
            "$editor" "$arg"
        fi
    done
}

# Wrapper functions for specific editors
function z() { edit_with_mkdir zed "$@"; }
function c() { edit_with_mkdir code "$@"; }
function v() { edit_with_mkdir nvim "$@"; }
function t() { edit_with_mkdir touch "$@"; }

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

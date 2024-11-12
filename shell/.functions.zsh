#!/usr/bin/env zsh

###################
# Function Reference
###################
# Core Utilities:
#   command_exists      - Check if a command exists in the system
#   lazy_load          - Lazy load commands with error handling
#   safe_source        - Safely source files with error checking
#   add_to_path        - Add directory to PATH if it exists
#   clean_path         - Clean PATH removing duplicates and invalid entries

# File & Directory Operations:
#   mkcd              - Create and enter directory
#   cdf               - Find and cd into directory using fuzzy search
#   tmpd              - Create and enter temporary directory
#   extract           - Extract various archive formats
#   compress          - Create ZIP archive of files/folders
#   backup            - Create timestamped backup of a file
#   findtext          - Search file contents with preview
#   rmf               - Remove files/directories with fuzzy finder
#   trash             - Safely move files to trash
#   empty-trash       - Empty trash with confirmation

# Git Operations:
#   clone             - Clone repo and cd into it
#   gadd              - Interactive git add with preview
#   gswitch           - Interactive branch switching with log preview
#   gbr               - Create and switch to new branch
#   git-clean         - Clean up merged branches
#   git-prune         - Prune remote branches and tags

# Development Tools:
#   venv              - Create and activate Python virtual environment
#   gotest            - Run Go tests with coverage report
#   goupdate          - Update Go dependencies
#   jsonf             - Format JSON data from string or pipe
#   timecmd           - Profile command execution time
#   watch-cmd         - Monitor command resource usage

# Network Operations:
#   ports             - Check open ports on the system
#   myip              - Get external IP address
#   curltime          - Test endpoint response times
#   serve             - Start quick HTTP server in current directory
#   lanscan           - Scan local network for devices
#   check-ssl         - Check SSL certificate for domain

# System Operations:
#   sys-check         - Check system resource usage
#   update-all        - Update all package managers and tools
#   pg                - Manage PostgreSQL service

# Security Tools:
#   genpass           - Generate secure password
#   ssh-fails         - Monitor failed SSH attempts
#   uuid              - Generate UUID
#   randstr           - Generate random string with specified length

# Productivity Tools:
#   note              - Quick note taking with daily files
#   calc              - Calculator with interactive mode support

###################
# Core Utilities
###################

# Check if a command exists in the system
# Usage: command_exists git
function command_exists() {
    command -v "$1" >/dev/null 2>&1
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

# Safely source files with error checking
# Usage: safe_source ~/.local/env
function safe_source() {
    if [[ -f "$1" ]]; then
        source "$1"
    else
        print -P "%F{yellow}Warning:%f Could not source $1" >&2
    fi
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

###################
# File & Directory Operations
###################

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

# Create a ZIP archive of files or folders
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

# Search file contents with preview using ripgrep and fzf
# Usage: findtext "search pattern" [directory]
function findtext() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: findtext <pattern> [directory]" >&2
        return 1
    fi

    local pattern="$1"
    local dir=${2:-.}

    if ! command_exists rg || ! command_exists fzf; then
        echo "Required dependencies (ripgrep, fzf) not found" >&2
        return 1
    fi

    rg --color=always --line-number --no-heading "$pattern" "$dir" |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '~3:+{2}+3/2'
}

# Remove files/directories interactively using fuzzy finder
# Usage: rmf [directory]
function rmf() {
    local dir=${1:-.}
    local selected
    local targets

    # Check if fzf is installed
    if ! command_exists fzf; then
        echo "fzf is required for this function" >&2
        return 1
    fi

    # Select files/directories to remove
    selected=$(fd --hidden --exclude .git --type f --type d . "$dir" 2>/dev/null | \
        fzf --multi \
            --preview 'if [ -d {} ]; then
                          tree -C {} | head -100
                      else
                          bat --style=numbers --color=always {} | head -100
                      fi' \
            --preview-window right:60% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --header 'Select files/directories to remove (TAB to multi-select, CTRL-/ to toggle preview)')

    [[ -z "$selected" ]] && return 0

    # Convert selection to array
    targets=("${(f)selected}")

    # If no targets selected, exit
    if [[ ${#targets[@]} -eq 0 ]]; then
        echo "No files selected"
        return 0
    fi

    # Show selected targets
    echo "The following items will be removed:"
    printf '%s\n' "${targets[@]}"

    # Ask for confirmation
    read -q "REPLY?Are you sure you want to remove these items? [y/N] "
    echo

    if [[ "$REPLY" == "y" ]]; then
        # Remove selected targets
        for target in "${targets[@]}"; do
            if /bin/rm -rf "$target"; then
                echo "Removed: $target"
            else
                echo "Failed to remove: $target" >&2
            fi
        done
    else
        echo "Operation cancelled"
    fi
}

# Safely empty trash with size check and confirmation
# Usage: empty-trash
function empty-trash() {
    local trash_dir="$HOME/.Trash"
    if [[ ! -d "$trash_dir" ]]; then
        echo "Trash directory doesn't exist" >&2
        return 1
    fi

    local size=$(du -sh "$trash_dir" 2>/dev/null | cut -f1)
    echo "Trash size: $size"
    read -q "REPLY?Empty trash? [y/N] "
    echo
    if [[ "$REPLY" == "y" ]]; then
        rm -rf "${trash_dir:?}/"* && echo "Trash emptied"
    fi
}

# Create timestamped backup of a file
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

###################
# Git Operations
###################

# Clone repository and cd into it
# Usage: clone https://github.com/user/repo.git
function clone() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: clone <repository-url>" >&2
        return 1
    fi

    git clone "$1" && cd "$(basename "$1" .git)"
}

# Interactive git add with diff preview
# Usage: gadd
function gadd() {
    if ! command_exists fzf; then
        echo "fzf is required for this function" >&2
        return 1
    fi

    local files
    files=$(git status -s |
        fzf --multi \
            --preview 'git diff --color {2}' \
            --preview-window right:70% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --header 'Press CTRL-/ to toggle preview window' \
            --height '80%')

    if [[ -n "$files" ]]; then
        echo "$files" | awk '{print $2}' | xargs git add
        echo "Added files:"
        echo "$files" | awk '{print "  "$2}'
    fi
}

# Interactive branch switching with log preview
# Usage: gswitch
function gswitch() {
    if ! command_exists fzf; then
        echo "fzf is required for this function" >&2
        return 1
    fi

    local branch
    branch=$(git branch --all |
        grep -v HEAD |
        fzf --preview 'git log --color --graph --date=short --pretty=format:"%C(auto)%cd %h%d %s" {1}' \
            --preview-window right:70% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --header 'Press CTRL-/ to toggle preview window' |
        sed 's/.* //')

    if [[ -n "$branch" ]]; then
        git switch "${branch/#remotes\/origin\//}"
    fi
}

# Clean up merged branches
# Usage: git-clean
function git-clean() {
    local branches
    branches=$(git branch --merged | grep -v '^\*' | grep -vE '^(\+|\s*master\s*|\s*main\s*|\s*dev\s*)$')

    if [[ -z "$branches" ]]; then
        echo "No merged branches to clean up"
        return 0
    fi

    echo "The following branches will be deleted:"
    echo "$branches"
    read -q "REPLY?Proceed with deletion? [y/N] "
    echo

    if [[ "$REPLY" == "y" ]]; then
        echo "$branches" | xargs git branch -d
        echo "Branches cleaned up"
    fi
}

# Prune remote branches and tags
# Usage: git-prune
function git-prune() {
    echo "Fetching remote changes..."
    git fetch --prune

    echo "Pruning remote branches..."
    git remote prune origin

    echo "Pruning local references..."
    git gc --prune=now

    echo "Cleanup complete"
}

###################
# Development Tools
###################

# Create and activate Python virtual environment
# Usage: venv [name] [python_version]
function venv() {
    local venv_name="${1:-.venv}"
    local python_cmd="${2:-python3}"

    if ! command_exists "$python_cmd"; then
        echo "Python ($python_cmd) is not installed" >&2
        return 1
    fi

    echo "Creating virtual environment '$venv_name' using $python_cmd..."
    "$python_cmd" -m venv "$venv_name"

    if [[ ! -d "$venv_name" ]]; then
        echo "Failed to create virtual environment" >&2
        return 1
    fi

    # Use '.' instead of 'source' for better compatibility
    . "$venv_name/bin/activate" || {
        echo "Failed to activate virtual environment" >&2
        return 1
    }

    echo "Upgrading pip..."
    pip install --upgrade pip

    # Install dependencies if available
    if [[ -f "requirements-dev.txt" ]]; then
        echo "Installing development dependencies..."
        pip install -r requirements-dev.txt
    elif [[ -f "requirements.txt" ]]; then
        echo "Installing dependencies..."
        pip install -r requirements.txt
    fi

    echo "Virtual environment is ready"
}

# Run Go tests with coverage report
# Usage: gotest [package_path]
function gotest() {
    if ! command_exists go; then
        echo "Go is not installed" >&2
        return 1
    fi

    local pkg_path=${1:-.}

    echo "Running tests with race detection..."
    go test -v -race "$pkg_path/..."

    echo
    echo "Generating coverage report..."
    go test -coverprofile=coverage.out "$pkg_path/..."

    if command_exists go-tool-cover; then
        go tool cover -html=coverage.out -o coverage.html
        echo
        echo "Coverage report generated: coverage.html"

        if command_exists open; then
            open coverage.html
        elif command_exists xdg-open; then
            xdg-open coverage.html
        fi
    fi
}

# Update Go dependencies
# Usage: goupdate [package_path]
function goupdate() {
    if ! command_exists go; then
        echo "Go is not installed" >&2
        return 1
    fi

    local pkg_path=${1:-.}

    echo "Updating Go dependencies..."
    go get -u "$pkg_path/..."

    echo
    echo "Tidying Go modules..."
    go mod tidy

    echo
    echo "Verifying dependencies..."
    go mod verify
}

###################
# Network Operations
###################

# Check open ports on the system
# Usage: ports
function ports() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    else
        sudo ss -tulpn
    fi
}

# Get external IP address with additional info
# Usage: myip
function myip() {
    echo "External IP and location:"
    if command_exists curl; then
        curl -s "https://ipinfo.io" | python3 -m json.tool
    else
        echo "curl is not installed" >&2
        return 1
    fi
}

# Scan local network for devices
# Usage: lanscan [interface]
function lanscan() {
    if ! command_exists nmap; then
        echo "nmap is not installed" >&2
        return 1
    fi

    local interface="${1:-en0}"
    local subnet

    if [[ "$OSTYPE" == "darwin"* ]]; then
        subnet=$(ipconfig getifaddr "$interface" | cut -d. -f1-3)
    else
        subnet=$(ip -o -f inet addr show "$interface" | awk '{print $4}' | cut -d/ -f1 | cut -d. -f1-3)
    fi

    if [[ -z "$subnet" ]]; then
        echo "Could not determine subnet for interface $interface" >&2
        return 1
    fi

    echo "Scanning subnet $subnet.0/24..."
    nmap -sn "$subnet.0/24"
}

###################
# System Operations
###################

# Update all package managers and tools
# Usage: update-all
function update-all() {
    echo "=== Starting System Update ==="

    if command_exists brew; then
        echo
        echo "Updating Homebrew..."
        brew update && brew upgrade && brew cleanup
    fi

    if command_exists pip3; then
        echo
        echo "Updating Python packages..."
        pip3 list --outdated --format=freeze | \
            grep -v '^\-e' | cut -d = -f 1 | \
            xargs -n1 pip3 install -U
    fi

    if command_exists npm; then
        echo
        echo "Updating npm packages..."
        npm update -g
    fi

    if command_exists rustup; then
        echo
        echo "Updating Rust..."
        rustup update
    fi

    if command_exists go; then
        echo
        echo "Updating Go packages..."
        go get -u all
    fi

    if command_exists z4h; then
        echo
        echo "Updating zsh plugins..."
        z4h update
    fi

    echo
    echo "Update complete"
}

# Manage PostgreSQL service
# Usage: pg [start|stop|restart|status]
function pg() {
    if ! command_exists brew; then
        echo "Homebrew is not installed" >&2
        return 1
    fi

    case "$1" in
        start)
            brew services start postgresql
            ;;
        stop)
            brew services stop postgresql
            ;;
        restart)
            brew services restart postgresql
            ;;
        status)
            brew services list | grep postgresql
            ;;
        *)
            echo "Usage: pg [start|stop|restart|status]" >&2
            return 1
            ;;
    esac
}

###################
# Security Tools
###################

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

# Monitor failed SSH attempts
# Usage: ssh-fails [lines]
function ssh-fails() {
    local lines=${1:-50}

    if [[ "$OSTYPE" == "darwin"* ]]; then
        log show --predicate 'process == "sshd"' --last 1h
    else
        journalctl -u ssh -n "$lines"
    fi
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

###################
# Productivity Tools
###################

# Calculator with interactive mode support
# Usage: calc [expression]
function calc() {
    if [[ $# -eq 0 ]]; then
        python3 -ic 'from math import *; import sys; sys.ps1="calc> "'
    else
        python3 -c "from math import *; print($*)"
    fi
}

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

#!/usr/bin/env zsh

###################
# Function Reference
###################
# Core File & Directory Operations:
#   mkcd         - Create and enter directory
#   cdf          - Find and cd into directory using fuzzy search
#   tmpd         - Create and enter temporary directory
#   extract      - Extract various archive formats
#   compress     - Create ZIP archive of files/folders
#   findtext     - Search file contents with preview
#   rmf          - Safe recursive file/directory removal
#   trash        - Move items to trash with dating
#   empty-trash  - Safely empty trash with confirmation
#   pbc          - Enhanced clipboard operations

###################
# Core File & Directory Operations
###################

# Create and enter a new directory
function mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Find and cd into directory using fuzzy search
function cdf() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Create and enter a temporary directory
function tmpd() {
    local dir
    dir=$(mktemp -d)
    echo "Created temporary directory: $dir"
    cd "$dir"
}

# Extract various archive formats
function extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;           # Extract tar.bz2
            *.tar.gz)    tar xzf $1     ;;           # Extract tar.gz
            *.tar.xz)    tar xJf $1     ;;           # Extract tar.xz
            *.tar.zst)   tar --zstd -xf $1   ;;      # Extract tar.zst
            *.bz2)       bunzip2 $1     ;;           # Extract bz2
            *.rar)       unrar x $1     ;;           # Extract rar
            *.gz)        gunzip $1      ;;           # Extract gz
            *.tar)       tar xf $1      ;;           # Extract tar
            *.tbz2)      tar xjf $1     ;;           # Extract tbz2
            *.tgz)       tar xzf $1     ;;           # Extract tgz
            *.zip)       unzip $1       ;;           # Extract zip
            *.Z)         uncompress $1  ;;           # Extract Z
            *.7z)        7z x $1        ;;           # Extract 7z
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Safely remove files and directories with confirmation
function rmf() {
    local dirs=()
    local files=()

    # Sort items into files and directories
    for item in "$@"; do
        if [[ -d "$item" ]]; then
            dirs+=("$item")
        elif [[ -f "$item" ]]; then
            files+=("$item")
        fi
    done

    # Warn about directory removal
    if (( ${#dirs[@]} > 0 )); then
        echo "Warning: About to recursively remove these directories:"
        printf '%s\n' "${dirs[@]}"
        read -q "REPLY?Are you sure? [y/N] "
        echo
        [[ "$REPLY" != "y" ]] && return 1
    fi

    rm -rf "$@"
}

# Move items to dated trash directory
function trash() {
    local trash_dir="$HOME/.Trash"

    [[ ! -d "$trash_dir" ]] && mkdir -p "$trash_dir"

    for item in "$@"; do
        if [[ -e "$item" ]]; then
            local date_dir="$trash_dir/$(date +%Y%m%d)"
            mkdir -p "$date_dir"

            local base_name=$(basename "$item")
            local target="$date_dir/$base_name"
            if [[ -e "$target" ]]; then
                target="$date_dir/$base_name-$(date +%H%M%S)"
            fi

            mv "$item" "$target" && echo "Moved to trash: $item"
        else
            echo "File not found: $item"
        fi
    done
}

# Safely empty trash with size check and confirmation
function empty-trash() {
    local trash_dir="$HOME/.Trash"
    if [[ ! -d "$trash_dir" ]]; then
        echo "Trash directory doesn't exist"
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

# Enhanced clipboard operations with multiple input methods
function pbc() {
    if [[ -p /dev/stdin ]]; then
        pbcopy
    elif [[ -f "$1" ]]; then
        cat "$1" | pbcopy
    else
        echo "$1" | pbcopy
    fi
}

# Create a ZIP archive of files or directories
function compress() {
    local zip_name="${1:t:r}.zip"
    zip -r "$zip_name" "$1"
    echo "Created $zip_name"
}

# Search file contents with preview using ripgrep and fzf
function findtext() {
    rg --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window '~3:+{2}+3/2'
}

###################
# Development Tools
###################

# Unified Cargo command interface with error handling
function cargo-cmd() {
    if ! command -v cargo >/dev/null 2>&1; then
        echo "Error: Rust/Cargo not installed"
        return 1
    fi

    case "$1" in
        b|build)  cargo build "${@:2}"    ;;        # Build project
        r|run)    cargo run "${@:2}"      ;;        # Run project
        t|test)   cargo test "${@:2}"     ;;        # Run tests
        c|check)  cargo check "${@:2}"    ;;        # Check project
        f|fmt)    cargo fmt "${@:2}"      ;;        # Format code
        l|lint)   cargo clippy "${@:2}"   ;;        # Lint code
        w|watch)  cargo watch -x "${2:-run}" ;;     # Watch mode
        u|update) cargo update "${@:2}"   ;;        # Update deps
        *)        echo "Unknown cargo command: $1" ;;
    esac
}

# Interactive git add with diff preview
function gadd() {
    git status -s |
    fzf --multi --preview 'git diff --color {2}' |
    awk '{print $2}' |
    xargs git add
}

# Interactive git branch switching with log preview
function gswitch() {
    local branch=$(git branch --all |
        grep -v HEAD |
        fzf --preview 'git log --color --graph --date=short --pretty=format:"%C(auto)%cd %h%d %s" {1}' |
        sed 's/.* //')
    [[ -n "$branch" ]] && git switch "${branch/#remotes\/origin\//}"
}

# Interactive Docker container shell access
function dksh() {
    local cid=$(docker ps | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
    if [[ -n "$cid" ]]; then
        docker exec -it "$cid" ${2:-sh}
    else
        echo "No container selected"
    fi
}

# Interactive Docker container log viewing
function dklogs() {
    local cid=$(docker ps | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
    if [[ -n "$cid" ]]; then
        docker logs -f "$cid"
    else
        echo "No container selected"
    fi
}

# PostgreSQL database management
function pgdb() {
    case "$1" in
        start)   brew services start postgresql  ;;   # Start service
        stop)    brew services stop postgresql   ;;   # Stop service
        status)  brew services list | grep postgresql ;; # Check status
        create)  createdb "$2"                  ;;    # Create database
        drop)    dropdb "$2"                    ;;    # Drop database
        list)    psql -l                        ;;    # List databases
        *)       echo "Unknown command: $1"     ;;
    esac
}

# Create and setup Python virtual environment
function venv() {
    local venv_name="${1:-.venv}"
    python3 -m venv "$venv_name"
    source "$venv_name/bin/activate"
    pip install --upgrade pip

    if [[ -f "requirements-dev.txt" ]]; then
        pip install -r requirements-dev.txt
    elif [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    fi
}

# Run tests with coverage reporting
function test-coverage() {
    if [[ -f "pytest.ini" ]]; then
        pytest --cov --cov-report=html
        open htmlcov/index.html
    elif [[ -f "go.mod" ]]; then
        go test -coverprofile=coverage.out ./...
        go tool cover -html=coverage.out
    else
        echo "No recognized test configuration found"
    fi
}

###################
# Network Operations
###################

# Check open ports on the system
function ports() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    else
        sudo ss -tulpn
    fi
}

# Get external IP address
function myip() {
    curl -s https://api.ipify.org
    echo
}

# Test endpoint response times
function curltime() {
    curl -w "\
    time_namelookup:  %{time_namelookup}s\n\
    time_connect:  %{time_connect}s\n\
    time_appconnect:  %{time_appconnect}s\n\
    time_pretransfer:  %{time_pretransfer}s\n\
    time_redirect:  %{time_redirect}s\n\
    time_starttransfer:  %{time_starttransfer}s\n\
    ----------\n\
    time_total:  %{time_total}s\n" -o /dev/null -s "$@"
}

# Start a quick HTTP server in current directory
function serve() {
    local port="${1:-8000}"
    echo "Starting server on http://localhost:$port"
    python3 -m http.server "$port"
}

# Scan local network for devices
function lanscan() {
    local subnet=$(ipconfig getifaddr en0 | cut -d. -f1-3)
    nmap -sn "$subnet.0/24"
}

###################
# System Operations
###################

# Check system resource usage
function sys-check() {
    echo "=== CPU Usage ==="
    top -l 1 -n 0 | grep "CPU usage"

    echo "\n=== Memory Usage ==="
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; \
        /Pages\s+([^:]+)[^\d]+(\d+)/ and \
        printf "%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576;'

    echo "\n=== Disk Usage ==="
    df -h | grep -E '^/dev/'
}

# Add directory to PATH if it exists
function add_to_path() {
    if [[ -d "$1" ]]; then
        path=("$1" $path)
    fi
}

# Clean PATH removing duplicates and invalid entries
function clean_path() {
    path=("${(@)path:#*/*//./*}")
    typeset -U PATH path
}

# Lazy load commands with error handling
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
function safe_source() {
    local file=$1
    [[ -f $file ]] && source "$file" || echo "Warning: $file not found" >&2
}

###################
# Security Tools
###################

# Generate secure password with specified length
function genpass() {
    local length=${1:-32}
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' </dev/urandom | head -c "$length"
    echo
}

# Check SSL certificate for domain
function check-ssl() {
    echo | openssl s_client -servername "$1" -connect "$1":443 2>/dev/null | \
        openssl x509 -noout -dates
}

# Monitor failed SSH attempts
function ssh-fails() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log show --predicate 'process == "sshd"' --last 1h
    else
        journalctl -u ssh -n 50
    fi
}

# Generate UUID
function uuid() {
    python3 -c "import uuid; print(uuid.uuid4())"
}

###################
# Productivity Tools
###################

# Create timestamped backup of a file
function backup() {
    local filename=$1
    if [[ -f "$filename" ]]; then
        cp "$filename" "${filename}.$(date +%Y%m%d_%H%M%S).bak"
        echo "Backup created: ${filename}.$(date +%Y%m%d_%H%M%S).bak"
    else
        echo "File not found: $filename"
    fi
}

# Quick note taking with daily files
function note() {
    local notes_dir="$HOME/Notes"
    local date=$(date +%Y-%m-%d)
    mkdir -p "$notes_dir"

    if [ $# -eq 0 ]; then
        $EDITOR "$notes_dir/$date.md"
    else
        echo "$(date +%H:%M): $@" >> "$notes_dir/$date.md"
    fi
}

# Calculator with interactive mode support
function calc() {
    if [ $# -eq 0 ]; then
        bc -l
    else
        echo "$@" | bc -l
    fi
}

# Format JSON data from string or pipe
function jsonf() {
    if [ -t 0 ]; then
        echo "$1" | python3 -m json.tool
    else
        python3 -m json.tool
    fi
}

###################
# Update Operations
###################

# Update all package managers and tools
function update-all() {
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup

    echo "\nUpdating Python packages..."
    pip list --outdated --format=freeze | \
        grep -v '^\-e' | cut -d = -f 1 | \
        xargs -n1 pip install -U

    if command -v rustup >/dev/null 2>&1; then
        echo "\nUpdating Rust..."
        rustup update
    fi

    if command -v go >/dev/null 2>&1; then
        echo "\nUpdating Go packages..."
        go get -u all
    fi

    echo "\nUpdating zsh plugins..."
    z4h update
}

# Generate random string with specified length
function randstr() {
    local length=${1:-32}
    LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$length"
    echo
}

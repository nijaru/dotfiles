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
#
# System Utilities:
#   lazy_load    - Lazy load commands with error handling
#   safe_source  - Safely source files with error checking
#   clean_path   - Clean up PATH removing duplicates/invalid
#
# Development Operations:
# - Git:
#   clone        - Clone repo and cd into it
#   gbr          - Create and switch to new branch
#   git-clean    - Clean up merged local branches
#   gadd         - Interactive git add with fzf
#   gswitch      - Interactive branch switching
#
# - Python:
#   venv         - Create and activate Python virtual environment
#
# - Go:
#   gotest       - Run Go tests with coverage report
#   goupdate     - Update Go dependencies
#
# Container Operations:
#   dkstop-all   - Stop all running containers
#   dkrm-all     - Remove all containers
#   dkclean      - Clean up docker system
#   dksh         - Interactive container shell access
#   dklogs       - View container logs interactively
#   dkstats      - Show container resource usage
#
# Network Operations:
#   ports        - Check open ports
#   myip         - Get external IP
#   curltime     - Test endpoint response times
#   serve        - Start quick HTTP server
#   lanscan      - Scan local network
#
# System Operations:
#   sys-check    - Check system resource usage
#   add_to_path  - Add directory to PATH
#
# Database Operations:
#   pg           - Manage PostgreSQL service
#
# Development Tools:
#   jsonf        - Format JSON data
#   randstr      - Generate random string
#   uuid         - Generate UUID
#
# Performance Tools:
#   timecmd      - Profile command execution time
#   watch-cmd    - Monitor command resource usage
#
# Security Tools:
#   genpass      - Generate secure password
#   check-ssl    - Check SSL certificate
#   ssh-fails    - Monitor failed SSH attempts
#
# Productivity Tools:
#   backup       - Create timestamped file backup
#   note         - Quick note taking
#   calc         - Calculator with bc
#
# Update Operations:
#   update-all   - Update all package managers and tools
###################

###################
# Core File & Directory Operations
###################

# Create and enter directory
# Usage: mkcd new-directory
function mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Find directory and cd into it using fuzzy search
# Usage: cdf [search_path]
function cdf() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Create and enter temporary directory
# Usage: tmpd
function tmpd() {
    local dir
    dir=$(mktemp -d)
    echo "Created temporary directory: $dir"
    cd "$dir"
}

# Extract various archive formats
# Usage: extract archive.tar.gz
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.tar.xz)    tar xJf $1     ;;
            *.tar.zst)   tar --zstd -xf $1   ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a ZIP archive of a file or folder
# Usage: compress directory-or-file
function compress() {
    local zip_name="${1:t:r}.zip"
    zip -r "$zip_name" "$1"
    echo "Created $zip_name"
}

# Find files by content using ripgrep and fzf
# Usage: findtext "search term"
function findtext() {
    rg --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window '~3:+{2}+3/2'
}

###################
# System Utilities
###################
# Enhanced lazy loading with error handling
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

# Safe source function
function safe_source() {
    local file=$1
    [[ -f $file ]] && source "$file" || echo "Warning: $file not found" >&2
}

# Path cleanup and deduplication
function clean_path() {
    # Remove non-existent directories from PATH
    path=("${(@)path:#*/*//./*}")
    # Remove duplicate entries
    typeset -U PATH path
}

###################
# Development Operations
###################

# Git Operations
#-----------------
# Clone and cd into a repository
# Usage: clone https://github.com/user/repo.git
function clone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Create and switch to a new branch
# Usage: gbr feature-branch
function gbr() {
    git switch -c "$1"
}

# Clean up merged local branches (excluding main/master/dev)
# Usage: git-clean
function git-clean() {
    git branch --merged | egrep -v "(^\*|main|dev|master)" | xargs git branch -d
}

# Interactive git add using fzf
# Usage: gadd
function gadd() {
    git status -s |
    fzf --multi --preview 'git diff --color {2}' |
    awk '{print $2}' |
    xargs git add
}

# Interactive branch switching with preview
# Usage: gswitch
function gswitch() {
    local branch=$(git branch --all |
        grep -v HEAD |
        fzf --preview 'git log --color --graph --date=short --pretty=format:"%C(auto)%cd %h%d %s" {1}' |
        sed 's/.* //')
    [[ -n "$branch" ]] && git switch "${branch/#remotes\/origin\//}"
}

# Python Development
#------------------
# Create and activate Python virtual environment
# Usage: venv [venv_name]
function venv() {
    local venv_name="${1:-.venv}"
    python3 -m venv "$venv_name"
    source "$venv_name/bin/activate"
    pip install --upgrade pip

    # Install dependencies if available
    if [[ -f "requirements-dev.txt" ]]; then
        pip install -r requirements-dev.txt
    elif [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    fi
}

# Go Development
#------------------
# Run Go tests with coverage and open report
# Usage: gotest
function gotest() {
    go test -v -race -cover ./... && \
    go test -coverprofile=coverage.out ./... && \
    go tool cover -html=coverage.out -o coverage.html && \
    open coverage.html
}

# Update all Go dependencies
# Usage: goupdate
function goupdate() {
    go get -u ./... && \
    go mod tidy
}

###################
# Container Operations
###################

# Docker Management
#------------------
# Stop all running containers
# Usage: dkstop-all
function dkstop-all() {
    if [[ $(docker ps -q) ]]; then
        docker stop $(docker ps -q)
    else
        echo "No running containers found"
    fi
}

# Remove all containers
# Usage: dkrm-all
function dkrm-all() {
    if [[ $(docker ps -a -q) ]]; then
        docker rm $(docker ps -a -q)
    else
        echo "No containers found"
    fi
}

# Clean up docker system (containers, volumes, networks)
# Usage: dkclean
function dkclean() {
    echo "Cleaning Docker system..."
    docker system prune -af
    docker volume prune -f
    docker network prune -f
}

# Interactive container shell access
# Usage: dksh [container_name_filter]
function dksh() {
    local cid=$(docker ps | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
    if [[ -n "$cid" ]]; then
        docker exec -it "$cid" ${2:-sh}
    else
        echo "No container selected"
    fi
}

# View container logs interactively
# Usage: dklogs [container_name_filter]
function dklogs() {
    local cid=$(docker ps | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
    if [[ -n "$cid" ]]; then
        docker logs -f "$cid"
    else
        echo "No container selected"
    fi
}

# Show container resource usage statistics
# Usage: dkstats
function dkstats() {
    docker stats $(docker ps --format "{{.Names}}")
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

# Get external IP address
# Usage: myip
function myip() {
    curl -s https://api.ipify.org
    echo
}

# Test endpoint response times
# Usage: curltime https://example.com
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
# Usage: serve [port]
function serve() {
    local port="${1:-8000}"
    echo "Starting server on http://localhost:$port"
    python3 -m http.server "$port"
}

# Scan local network for devices
# Usage: lanscan
function lanscan() {
    local subnet=$(ipconfig getifaddr en0 | cut -d. -f1-3)
    nmap -sn "$subnet.0/24"
}

###################
# System Operations
###################
# Check system resource usage
# Usage: sys-check
function sys-check() {
    echo "=== CPU Usage ==="
    top -l 1 -n 0 | grep "CPU usage"
    echo "\n=== Memory Usage ==="
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf "%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576;'
    echo "\n=== Disk Usage ==="
    df -h | grep -E '^/dev/'
}

# Add directory to PATH if it exists
# Usage: add_to_path /path/to/dir
function add_to_path() {
    if [[ -d "$1" ]]; then
        path=("$1" $path)
    fi
}

###################
# Database Operations
###################
# Manage PostgreSQL service
# Usage: pg [start|stop|restart]
function pg() {
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
        *)
            echo "Usage: pg [start|stop|restart]"
            ;;
    esac
}

###################
# Development Tools
###################
# Format JSON data
# Usage: jsonf '{"foo": "bar"}'
function jsonf() {
    if [ -t 0 ]; then  # If argument provided
        echo "$1" | python3 -m json.tool
    else  # If piped input
        python3 -m json.tool
    fi
}

# Generate random string
# Usage: randstr [length]
function randstr() {
    local length=${1:-32}
    LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$length"
    echo
}

# Generate UUID
# Usage: uuid
function uuid() {
    python3 -c "import uuid; print(uuid.uuid4())"
}

###################
# Performance Tools
###################
# Profile command execution time
# Usage: timecmd "command args"
function timecmd() {
    local start=$(($(gdate +%s%N)/1000000))
    eval "$@"
    local end=$(($(gdate +%s%N)/1000000))
    echo "Time elapsed: $(($end-$start)) milliseconds"
}

# Monitor command resource usage
# Usage: watch-cmd "command args"
function watch-cmd() {
    while true; do
        ps aux | head -1
        ps aux | grep "$1" | grep -v grep
        sleep 1
        clear
    done
}

###################
# Security Tools
###################
# Generate secure password
# Usage: genpass [length]
function genpass() {
    local length=${1:-32}
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' </dev/urandom | head -c "$length"
    echo
}

# Check SSL certificate
# Usage: check-ssl example.com
function check-ssl() {
    echo | openssl s_client -servername "$1" -connect "$1":443 2>/dev/null | openssl x509 -noout -dates
}

# Monitor failed SSH attempts
# Usage: ssh-fails
function ssh-fails() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log show --predicate 'process == "sshd"' --last 1h
    else
        journalctl -u ssh -n 50
    fi
}

###################
# Productivity Tools
###################
# Create timestamped backup of a file
# Usage: backup filename
function backup() {
    local filename=$1
    if [[ -f "$filename" ]]; then
        cp "$filename" "${filename}.$(date +%Y%m%d_%H%M%S).bak"
    else
        echo "File not found: $filename"
    fi
}

# Quick note taking
# Usage: note "Note content"
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

# Calculator with bc
# Usage: calc "1 + 2" or calc to enter interactive mode
function calc() {
    if [ $# -eq 0 ]; then
        bc -l
    else
        echo "$@" | bc -l
    fi
}

###################
# Update Operations
###################
# Update all package managers and tools
# Usage: update-all
function update-all() {
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup

    echo "\nUpdating Python packages..."
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U

    echo "\nUpdating npm packages..."
    npm update -g

    echo "\nUpdating Rust..."
    rustup update

    echo "\nUpdating Go packages..."
    go get -u all

    echo "\nUpdating zsh plugins..."
    z4h update
}

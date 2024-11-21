#!/usr/bin/env zsh
# Docker operations and utilities
# Provides container and Kubernetes management functions

###################
# Docker Operations
###################
# Basic operations
alias dc="docker compose"          # Basic compose command
alias dcu="docker compose up -d"   # Start containers in background
alias dcd="docker compose down"    # Stop and remove containers
alias dcl="docker compose logs -f" # Follow container logs
alias dcp="docker compose pull"    # Pull latest images
alias dcr="docker compose restart" # Restart containers
alias dcs="docker compose stop"    # Stop containers
alias dcps="docker compose ps"     # List containers
alias dcb="docker compose build"   # Build containers
alias dce="docker compose exec"    # Execute command in container
alias dccp="docker compose cp"     # Copy files between host and containers

# Development helpers
alias dcdev="docker compose -f docker-compose.yml -f docker-compose.dev.yml"
alias dcprod="docker compose -f docker-compose.yml -f docker-compose.prod.yml"

# Cleanup commands
alias dcrm="docker compose rm -f"                              # Remove stopped containers
alias dcprune="docker compose down --volumes --remove-orphans" # Full cleanup

###################
# Container Operations
###################

# Interactive container shell access
# Usage: dksh [container_name_filter] [shell]
function dksh() {
    if ! command_exists docker; then
        echo "Docker is not installed" >&2
        return 1
    fi

    local containers
    if [[ -z "$(docker ps -q)" ]]; then
        echo "No running containers found" >&2
        return 1
    fi

    local cid
    cid=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" |
        sed '1d' |
        fzf --header "Select container" \
            --preview 'docker inspect {1}' \
            --preview-window right:70% \
            --query "$1" |
        awk '{print $1}')

    if [[ -n "$cid" ]]; then
        local shell=${2:-sh}
        echo "Connecting to container $cid using $shell..."
        docker exec -it "$cid" "$shell"
    fi
}

# View container logs interactively
# Usage: dklogs [container_name_filter]
function dklogs() {
    if ! command_exists docker; then
        echo "Docker is not installed" >&2
        return 1
    fi

    local cid
    cid=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" |
        sed '1d' |
        fzf --header "Select container to view logs" \
            --preview 'docker logs --tail 50 {1}' \
            --preview-window right:70% \
            --query "$1" |
        awk '{print $1}')

    if [[ -n "$cid" ]]; then
        echo "Streaming logs for container $cid..."
        docker logs -f "$cid"
    fi
}

# Clean up docker system
# Usage: dkclean
function dkclean() {
    if ! command_exists docker; then
        echo "Docker is not installed" >&2
        return 1
    fi

    echo "=== Docker Cleanup ==="
    echo "This will remove:"
    echo "- All stopped containers"
    echo "- All networks not used by at least one container"
    echo "- All dangling images"
    echo "- All dangling build cache"

    read -q "REPLY?Are you sure you want to proceed? [y/N] "
    echo

    if [[ "$REPLY" == "y" ]]; then
        echo
        echo "Cleaning up containers..."
        docker container prune -f

        echo
        echo "Cleaning up networks..."
        docker network prune -f

        echo
        echo "Cleaning up images..."
        docker image prune -f

        echo
        echo "Cleaning up build cache..."
        docker builder prune -f

        echo
        echo "Cleanup complete"
    fi
}

# Show container resource usage
# Usage: dkstats
function dkstats() {
    if ! command_exists docker; then
        echo "Docker is not installed" >&2
        return 1
    fi

    local running_containers
    running_containers=$(docker ps -q)

    if [[ -z "$running_containers" ]]; then
        echo "No running containers found" >&2
        return 1
    fi

    docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
}

# Remove unused containers, images, and volumes
# Usage: dkprune
function dkprune() {
    if ! command_exists docker; then
        echo "Docker is not installed" >&2
        return 1
    fi

    echo "=== Docker Deep Cleanup ==="
    echo "This will remove:"
    echo "- All stopped containers"
    echo "- All networks not used by at least one container"
    echo "- All volumes not used by at least one container"
    echo "- All unused images"
    echo "- All build cache"

    read -q "REPLY?Are you sure you want to proceed? [y/N] "
    echo

    if [[ "$REPLY" == "y" ]]; then
        echo
        echo "Pruning containers..."
        docker container prune -f

        echo
        echo "Pruning networks..."
        docker network prune -f

        echo
        echo "Pruning volumes..."
        docker volume prune -f

        echo
        echo "Pruning images..."
        docker image prune -a -f

        echo
        echo "Pruning build cache..."
        docker builder prune -a -f

        echo
        echo "Deep cleanup complete"

        # Show remaining disk usage
        docker system df
    fi
}

###################
# Kubernetes Operations
###################
# Basic operations
alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgn="kubectl get nodes"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdn="kubectl describe node"

# Namespace operations
alias kn="kubectl config set-context --current --namespace"
alias kgns="kubectl get namespaces"
alias kcn="kubectl config view --minify | grep namespace:"

# Context operations
alias kc="kubectl config use-context"
alias kgc="kubectl config get-contexts"

# Logging and debugging
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias kex="kubectl exec -it"
alias kpf="kubectl port-forward"

# Resource management
alias ka="kubectl apply -f"
# alias kd="kubectl delete -f"
alias krm="kubectl delete"

# Cluster information
alias kgi="kubectl cluster-info"
alias kgv="kubectl version"
alias kga="kubectl get all"

# Development helpers
alias kdev="kubectl --context=dev"
alias kprod="kubectl --context=prod"
alias kstg="kubectl --context=staging"

# Custom functions
function kns() {
    if [ $# -eq 0 ]; then
        kubectl get ns
    else
        kubectl config set-context --current --namespace="$1"
    fi
}

function kctx() {
    if [ $# -eq 0 ]; then
        kubectl config get-contexts
    else
        kubectl config use-context "$1"
    fi
}

function kpods() {
    kubectl get pods "$@" -o wide
}

function klogs() {
    POD=$(kubectl get pods | grep "$1" | awk '{print $1}')
    kubectl logs -f "$POD" "${@:2}"
}

# Function completions
compdef _docker dkclean=docker-system
compdef _kubectl kns=kubectl
compdef _kubectl kctx=kubectl
compdef _kubectl kpods=kubectl
compdef _kubectl klogs=kubectl

###################
# OrbStack Initialization and Completion
###################

# Initialize OrbStack if available
if [[ -r "$HOME/.orbstack/shell/init.zsh" ]]; then
    z4h source "$HOME/.orbstack/shell/init.zsh"
fi

# Orbctl Command Completion
if command -v orbctl >/dev/null 2>&1; then
    z4h source <(orbctl completion zsh)
    compdef _orb orbctl
    compdef _orb orb
fi

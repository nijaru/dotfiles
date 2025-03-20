#!/usr/bin/env fish
# Docker operations and utilities for Fish shell

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

# Docker functions are now in functions/ directory
# - dksh.fish - Interactive container shell access
# - dklogs.fish - View container logs interactively
# - dkclean.fish - Clean up docker system
# - dkstats.fish - Show container resource usage
# - dkprune.fish - Remove unused containers, images, and volumes

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
# alias kd="kubectl delete -f" # Conflicts with describe
alias krm="kubectl delete"

# Cluster information
alias kgi="kubectl cluster-info"
alias kgv="kubectl version"
alias kga="kubectl get all"

# Development helpers
alias kdev="kubectl --context=dev"
alias kprod="kubectl --context=prod"
alias kstg="kubectl --context=staging"

# Kubernetes functions are now in functions/ directory
# - kns.fish - Kubernetes namespace operations
# - kctx.fish - Kubernetes context operations
# - kpods.fish - List Kubernetes pods with details
# - klogs.fish - View Kubernetes pod logs

###################
# OrbStack Initialization
###################

# Initialize OrbStack if available
if test -r "$HOME/.orbstack/shell/init.fish"
    source "$HOME/.orbstack/shell/init.fish"
end

# Orbctl Command Completion is automatically handled by fish
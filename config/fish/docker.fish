#!/usr/bin/env fish
# Docker operations and utilities for Fish shell

###################
# Docker Operations
###################
# Basic operations
abbr --add d "docker"                   # Basic docker command
abbr --add dc "docker compose"          # Basic compose command
abbr --add dkc "docker compose"         # Alternative compose command
abbr --add dcu "docker compose up -d"   # Start containers in background
abbr --add dcd "docker compose down"    # Stop and remove containers
abbr --add dcl "docker compose logs -f" # Follow container logs
abbr --add dcp "docker compose pull"    # Pull latest images
abbr --add dcr "docker compose restart" # Restart containers
abbr --add dcs "docker compose stop"    # Stop containers
abbr --add dcps "docker compose ps"     # List containers
abbr --add dcb "docker compose build"   # Build containers
abbr --add dce "docker compose exec"    # Execute command in container
abbr --add dccp "docker compose cp"     # Copy files between host and containers

# Development helpers
abbr --add dcdev "docker compose -f docker-compose.yml -f docker-compose.dev.yml"
abbr --add dcprod "docker compose -f docker-compose.yml -f docker-compose.prod.yml"

# Cleanup commands
abbr --add dcrm "docker compose rm -f"                              # Remove stopped containers
abbr --add dcprune "docker compose down --volumes --remove-orphans" # Full cleanup

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
abbr --add k "kubectl"
abbr --add kg "kubectl get"
abbr --add kgp "kubectl get pods"
abbr --add kgs "kubectl get services"
abbr --add kgn "kubectl get nodes"
abbr --add kd "kubectl describe"
abbr --add kdp "kubectl describe pod"
abbr --add kds "kubectl describe service"
abbr --add kdn "kubectl describe node"

# Namespace operations
abbr --add kn "kubectl config set-context --current --namespace"
abbr --add kgns "kubectl get namespaces"
abbr --add kcn "kubectl config view --minify | grep namespace:"

# Context operations
abbr --add kc "kubectl config use-context"
abbr --add kgc "kubectl config get-contexts"

# Logging and debugging
abbr --add kl "kubectl logs"
abbr --add klf "kubectl logs -f"
abbr --add kex "kubectl exec -it"
abbr --add kpf "kubectl port-forward"

# Resource management
abbr --add ka "kubectl apply -f"
# Was alias kd="kubectl delete -f" # Conflicts with describe
abbr --add krm "kubectl delete"

# Cluster information
abbr --add kgi "kubectl cluster-info"
abbr --add kgv "kubectl version"
abbr --add kga "kubectl get all"

# Development helpers
abbr --add kdev "kubectl --context=dev"
abbr --add kprod "kubectl --context=prod"
abbr --add kstg "kubectl --context=staging"

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
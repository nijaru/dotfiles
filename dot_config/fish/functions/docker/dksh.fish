function dksh --description 'Interactive container shell access'
    if not command -v docker >/dev/null 2>&1
        echo "Docker is not installed" >&2
        return 1
    end

    # Check if any containers are running
    if test -z (docker ps -q)
        echo "No running containers found" >&2
        return 1
    end

    # Use FZF to select a container
    set -l cid (docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | \
        sed '1d' | \
        fzf --header "Select container" \
            --preview 'docker inspect {1}' \
            --preview-window right:70% \
            --query "$argv[1]" | \
        awk '{print $1}')

    if test -n "$cid"
        # Use the provided shell or default to sh
        set -l shell $argv[2]
        test -z "$shell"; and set shell "sh"
        
        echo "Connecting to container $cid using $shell..."
        docker exec -it "$cid" "$shell"
    end
end
function dklogs --description 'View container logs interactively'
    if not command -v docker >/dev/null 2>&1
        echo "Docker is not installed" >&2
        return 1
    end

    # Use FZF to select a container
    set -l cid (docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | \
        sed '1d' | \
        fzf --header "Select container to view logs" \
            --preview 'docker logs --tail 50 {1}' \
            --preview-window right:70% \
            --query "$argv[1]" | \
        awk '{print $1}')

    if test -n "$cid"
        echo "Streaming logs for container $cid..."
        docker logs -f "$cid"
    end
end
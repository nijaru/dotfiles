function dkclean --description 'Clean up docker system'
    if not command -v docker >/dev/null 2>&1
        echo "Docker is not installed" >&2
        return 1
    end

    echo "=== Docker Cleanup ==="
    echo "This will remove:"
    echo "- All stopped containers"
    echo "- All networks not used by at least one container"
    echo "- All dangling images"
    echo "- All dangling build cache"

    read -l -P "Are you sure you want to proceed? [y/N] " confirm
    
    if test "$confirm" = "y"
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
    end
end
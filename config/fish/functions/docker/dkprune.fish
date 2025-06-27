function dkprune --description 'Remove unused containers, images, and volumes'
    if not command -v docker >/dev/null 2>&1
        echo "Docker is not installed" >&2
        return 1
    end

    echo "=== Docker Deep Cleanup ==="
    echo "This will remove:"
    echo "- All stopped containers"
    echo "- All networks not used by at least one container"
    echo "- All volumes not used by at least one container"
    echo "- All unused images"
    echo "- All build cache"

    read -l -P "Are you sure you want to proceed? [y/N] " confirm
    
    if test "$confirm" = "y"
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
    end
end
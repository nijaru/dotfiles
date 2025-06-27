function dkstats --description 'Show container resource usage'
    if not command -v docker >/dev/null 2>&1
        echo "Docker is not installed" >&2
        return 1
    end

    set -l running_containers (docker ps -q)

    if test -z "$running_containers"
        echo "No running containers found" >&2
        return 1
    end

    docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
end
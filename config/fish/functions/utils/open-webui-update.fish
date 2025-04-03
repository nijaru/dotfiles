function open-webui-update --description 'Update or install Open WebUI container' --argument-names cleanup
    # Check if Docker is installed
    if not command -v docker >/dev/null 2>&1
        echo "Error: Docker is not installed" >&2
        return 1
    end

    # Check if container exists
    if not docker ps -a --format '{{.Names}}' | grep -q "^open-webui\$"
        echo "Open WebUI container not found."
        read -l -P "Would you like to install Open WebUI? [y/N] " confirm

        switch $confirm
            case Y y
                echo "Installing Open WebUI container..."
                if docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
                    echo "Open WebUI installed successfully. Access it at http://localhost:3000"
                    return 0
                else
                    echo "Error: Failed to install Open WebUI" >&2
                    return 1
                end
            case '*'
                echo "Installation cancelled."
                return 0
        end
    else
        # Setup update arguments
        set args --run-once
        if test "$cleanup" = "--cleanup"
            set args $args --cleanup
            echo "Will remove old images after update"
        end

        echo "Updating Open WebUI container..."
        if docker run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower $args open-webui
            echo "Update completed successfully."
        else
            echo "Error: Update failed." >&2
            return 1
        end
    end
end

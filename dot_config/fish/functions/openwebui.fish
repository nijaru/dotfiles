# Main Open WebUI management function
function openwebui
    if test (count $argv) -eq 0
        echo "Usage: openwebui <command> [args]"
        echo ""
        echo "Commands:"
        echo "  set <target>      - Switch Open WebUI connection"
        echo "  status            - Check current connection status"
        echo "  devices           - List available Tailscale devices"
        echo "  restart           - Restart current connection"
        echo "  logs              - Show container logs"
        echo "  stop              - Stop Open WebUI container"
        echo ""
        echo "Examples:"
        echo "  openwebui set local"
        echo "  openwebui set fedora"
        echo "  openwebui status"
        return 1
    end
    
    set subcommand $argv[1]
    
    switch $subcommand
        case "set"
            _openwebui_set $argv[2..-1]
        case "status"
            _openwebui_status
        case "devices"
            _openwebui_devices
        case "restart"
            _openwebui_restart
        case "logs"
            _openwebui_logs
        case "stop"
            _openwebui_stop
        case "*"
            echo "❌ Unknown command: $subcommand"
            echo "💡 Run 'openwebui' for usage help"
            return 1
    end
end

# Set/switch connection target
function _openwebui_set
    if test (count $argv) -eq 0
        echo "Usage: openwebui set <target>"
        echo ""
        echo "Targets:"
        echo "  local                    - Use local Ollama"
        echo "  <tailscale-hostname>     - Use Tailscale hostname (e.g., 'fedora')"
        echo "  <ip-address>             - Use IP address directly"
        return 1
    end
    
    set target $argv[1]
    set ollama_url ""
    
    # Determine the target URL based on argument
    switch $target
        case "local"
            set ollama_url "http://host.docker.internal:11434"
            echo "🏠 Switching to local Ollama..."
            
        case "*.*.*.*"  # IP address pattern
            set ollama_url "http://$target:11434"
            echo "🌐 Switching to Ollama at IP: $target..."
            
        case "*"  # Assume it's a Tailscale hostname
            echo "🔍 Resolving Tailscale hostname: $target..."
            set resolved_ip (tailscale ip $target 2>/dev/null | head -1)
            
            if test $status -eq 0 -a -n "$resolved_ip"
                set ollama_url "http://$resolved_ip:11434"
                echo "📡 Resolved $target to $resolved_ip"
            else
                echo "❌ Could not resolve Tailscale hostname: $target"
                echo "💡 Try: tailscale status | grep $target"
                return 1
            end
    end
    
    # Test connection (skip for local since it might not be running)
    if test "$target" != "local"
        echo "🔄 Testing connection..."
        if not curl -s --connect-timeout 5 "$ollama_url/api/tags" >/dev/null
            echo "❌ Cannot connect to Ollama at $ollama_url"
            echo "💡 Make sure Ollama is running and accessible"
            return 1
        end
        echo "✅ Connection test passed"
    end
    
    # Stop current container
    echo "🛑 Stopping current Open WebUI..."
    docker stop open-webui >/dev/null 2>&1
    docker rm open-webui >/dev/null 2>&1
    
    # Start with new URL
    echo "🚀 Starting Open WebUI..."
    docker run -d \
        --name open-webui \
        -p 3000:8080 \
        -e OLLAMA_BASE_URL="$ollama_url" \
        -v open-webui:/app/backend/data \
        --restart unless-stopped \
        ghcr.io/open-webui/open-webui:main >/dev/null
    
    if test $status -eq 0
        echo "✅ Open WebUI connected to: $ollama_url"
        echo "🌐 Access at: http://localhost:3000"
    else
        echo "❌ Failed to start Open WebUI"
        return 1
    end
end

# Check current connection status
function _openwebui_status
    echo "📊 Open WebUI Status:"
    echo "===================="
    
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q open-webui
        set container_id (docker ps -q --filter "name=open-webui")
        set ollama_url (docker inspect $container_id | jq -r '.[0].Config.Env[]' | grep OLLAMA_BASE_URL | cut -d= -f2)
        
        echo "🟢 Container: Running"
        echo "📡 Ollama URL: $ollama_url"
        echo "🌐 WebUI: http://localhost:3000"
        
        # Test the connection
        echo "🔄 Testing connection..."
        if curl -s --connect-timeout 3 "$ollama_url/api/tags" >/dev/null
            echo "✅ Ollama: Connected"
            
            # Show available models if connected
            set models (curl -s "$ollama_url/api/tags" | jq -r '.models[].name' 2>/dev/null)
            if test -n "$models"
                echo "🤖 Models: "(echo $models | tr '\n' ' ')
            end
        else
            echo "❌ Ollama: Connection failed"
        end
    else
        echo "🔴 Container: Not running"
        echo "💡 Run: openwebui set <target> to start"
    end
end

# List available Tailscale devices
function _openwebui_devices
    echo "🌐 Available Tailscale Devices:"
    echo "==============================="
    tailscale status --json | jq -r '.Peer[] | select(.Online == true) | "\(.HostName)\t\(.TailscaleIPs[0])"' | column -t
    echo ""
    echo "💡 Usage: openwebui set <hostname> or openwebui set <ip>"
end

# Restart current connection
function _openwebui_restart
    if not docker ps --format "table {{.Names}}" | grep -q open-webui
        echo "❌ Open WebUI is not running"
        echo "💡 Use 'openwebui set <target>' to start with a target"
        return 1
    end
    
    echo "🔄 Restarting Open WebUI..."
    docker restart open-webui >/dev/null
    
    if test $status -eq 0
        echo "✅ Open WebUI restarted successfully"
        echo "🌐 Access at: http://localhost:3000"
    else
        echo "❌ Failed to restart Open WebUI"
        return 1
    end
end

# Show container logs
function _openwebui_logs
    if not docker ps --format "table {{.Names}}" | grep -q open-webui
        echo "❌ Open WebUI container is not running"
        return 1
    end
    
    echo "📋 Open WebUI Logs:"
    echo "=================="
    docker logs open-webui --tail 50 --follow
end

# Stop Open WebUI container
function _openwebui_stop
    if not docker ps --format "table {{.Names}}" | grep -q open-webui
        echo "⚠️  Open WebUI is not running"
        return 0
    end
    
    echo "🛑 Stopping Open WebUI..."
    docker stop open-webui >/dev/null 2>&1
    docker rm open-webui >/dev/null 2>&1
    
    echo "✅ Open WebUI stopped"
end
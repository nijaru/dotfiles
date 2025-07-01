# Main function to switch Open WebUI Ollama connections
function set-openwebui
    if test (count $argv) -eq 0
        echo "Usage: set-openwebui <target>"
        echo ""
        echo "Targets:"
        echo "  local                    - Use local Ollama"
        echo "  <tailscale-hostname>     - Use Tailscale hostname (e.g., 'fedora')"
        echo "  <ip-address>             - Use IP address directly"
        echo ""
        echo "Examples:"
        echo "  set-openwebui local"
        echo "  set-openwebui fedora"
        echo "  set-openwebui 100.100.101.101"
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
            set resolved_ip (tailscale ip $target 2>/dev/null)
            
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
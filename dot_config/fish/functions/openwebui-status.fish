# Function to check current Open WebUI connection status
function openwebui-status
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
        echo "💡 Run: set-openwebui <target> to start"
    end
end
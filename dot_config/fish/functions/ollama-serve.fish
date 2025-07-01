function ollama-serve -d "Manage Ollama with Tailscale serving"
    switch $argv[1]
        case start
            echo "Starting Ollama service..."
            ollama serve &
            sleep 2
            echo "Starting Tailscale serve for Ollama..."
            tailscale serve --bg localhost:11434
            echo "✅ Ollama is now served via Tailscale"
            
        case stop
            echo "Stopping Tailscale serve..."
            tailscale serve --reset
            echo "Stopping Ollama service..."
            pkill -f "ollama serve"
            echo "✅ Ollama serve stopped"
            
        case status
            echo "=== Ollama Process Status ==="
            if pgrep -f "ollama serve" > /dev/null
                echo "✅ Ollama service: RUNNING (PID: "(pgrep -f "ollama serve")")"
            else
                echo "❌ Ollama service: STOPPED"
            end
            
            echo ""
            echo "=== Tailscale Serve Status ==="
            tailscale serve status
            
        case '*'
            echo "Usage: ollama-serve {start|stop|status}"
            echo ""
            echo "Commands:"
            echo "  start   - Start Ollama and serve via Tailscale"
            echo "  stop    - Stop both Ollama and Tailscale serve"
            echo "  status  - Show status of both services"
            return 1
    end
end
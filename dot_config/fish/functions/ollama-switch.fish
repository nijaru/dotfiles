function ollama-switch -d "Switch between local and remote Ollama"
    set current_status (if set -q OLLAMA_HOST; echo $OLLAMA_HOST; else; echo "local"; end)
    
    switch $argv[1]
        case local
            set -e OLLAMA_HOST
            echo "🏠 Using local Ollama"
        case remote fedora
            set fedora_ip (tailscale ip -4 fedora 2>/dev/null)
            if test -n "$fedora_ip"
                set -gx OLLAMA_HOST http://$fedora_ip:11434
                echo "🌐 Using remote Ollama: $OLLAMA_HOST"
            else
                echo "❌ Could not get fedora IP from tailscale"
                return 1
            end
        case list
            echo "Available tailscale machines:"
            tailscale status --peers | grep -v '^#' | awk '{print "  " $2 " (" $1 ")"}'
            echo ""
            echo "Current: $current_status"
        case '*'
            echo "Usage: ollama-switch {local|remote|list}"
            echo "Current: $current_status"
    end
end
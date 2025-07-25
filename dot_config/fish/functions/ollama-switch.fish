function ollama-switch -d "Switch between local and remote Ollama"
    set current_status (if set -q OLLAMA_HOST; echo $OLLAMA_HOST; else; echo "local"; end)
    
    switch $argv[1]
        case local
            set -e OLLAMA_HOST
            echo "🏠 Using local Ollama"
        case list
            echo "Available tailscale machines:"
            tailscale status --peers | grep -v '^#' | awk '{print "  " $2 " (" $1 ")"}'
            echo ""
            echo "Current: $current_status"
        case ''
            echo "Usage: ollama-switch {local|list|<machine-name>}"
            echo "Current: $current_status"
        case '*'
            set machine_name $argv[1]
            set machine_ip (tailscale ip -4 $machine_name 2>/dev/null)
            if test -n "$machine_ip"
                set -gx OLLAMA_HOST http://$machine_ip:11434
                echo "🌐 Using remote Ollama ($machine_name): $OLLAMA_HOST"
            else
                echo "❌ Could not get $machine_name IP from tailscale"
                return 1
            end
    end
end
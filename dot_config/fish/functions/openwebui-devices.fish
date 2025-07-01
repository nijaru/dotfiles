# Function to list available Tailscale devices for Open WebUI
function openwebui-devices
    echo "🌐 Available Tailscale Devices:"
    echo "==============================="
    tailscale status --json | jq -r '.Peer[] | select(.Online == true) | "\(.HostName)\t\(.TailscaleIPs[0])"' | column -t
    echo ""
    echo "💡 Usage: set-openwebui <hostname> or set-openwebui <ip>"
end
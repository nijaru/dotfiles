# Open WebUI abbreviations and completions

# Quick abbreviations for convenience
abbr ows openwebui-status
abbr owd openwebui-devices

# Tab completion for set-openwebui
complete -c set-openwebui -a "local" -d "Use local Ollama"
complete -c set-openwebui -a "(tailscale status --json 2>/dev/null | jq -r '.Peer[] | select(.Online == true) | .HostName' 2>/dev/null)" -d "Tailscale device"
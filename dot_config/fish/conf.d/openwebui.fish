# Open WebUI completions

# Tab completion for openwebui command
complete -c openwebui -n "__fish_use_subcommand" -a "set" -d "Switch connection"
complete -c openwebui -n "__fish_use_subcommand" -a "status" -d "Check status"
complete -c openwebui -n "__fish_use_subcommand" -a "devices" -d "List devices"
complete -c openwebui -n "__fish_use_subcommand" -a "restart" -d "Restart container"
complete -c openwebui -n "__fish_use_subcommand" -a "logs" -d "Show logs"
complete -c openwebui -n "__fish_use_subcommand" -a "stop" -d "Stop container"

# Tab completion for 'openwebui set' targets
complete -c openwebui -n "__fish_seen_subcommand_from set" -a "local" -d "Use local Ollama"
complete -c openwebui -n "__fish_seen_subcommand_from set" -a "(tailscale status --json 2>/dev/null | jq -r '.Peer[] | select(.Online == true) | .HostName' 2>/dev/null)" -d "Tailscale device"
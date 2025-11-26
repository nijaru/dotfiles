function claude
    set -l mcp_config ~/.config/claude/mcp-servers.json
    set -l subcommands mcp config doctor version help

    # Subcommands bypass MCP config
    if contains -- $argv[1] $subcommands
        command claude $argv
    else if test -f $mcp_config
        # Use chezmoi-managed MCP config if available
        command claude --mcp-config $mcp_config $argv
    else
        # Fallback to default
        command claude $argv
    end
end

function claude
    # Subcommands that don't need MCP config
    set -l subcommands mcp config doctor version help
    
    # Check if first arg is a subcommand
    if contains -- $argv[1] $subcommands
        command claude $argv
    else
        # Main interactive mode - load MCP config (strict mode to ignore .claude.json)
        command claude --mcp-config ~/.config/claude/mcp-servers-lite.json --strict-mcp-config $argv
    end
end

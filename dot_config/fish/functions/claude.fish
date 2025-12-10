function claude
    set -l mcp_config ~/.config/claude/mcp-servers.json
    set -l subcommands mcp config doctor version help update install setup-token plugin

    # Subcommands bypass wrapper options
    if contains -- $argv[1] $subcommands
        command claude $argv
        return
    end

    if test -f $mcp_config
        command claude --mcp-config $mcp_config $argv
    else
        command claude $argv
    end
end

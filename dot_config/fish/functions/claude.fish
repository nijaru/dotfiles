function claude
    set -l mcp_config ~/.config/claude/mcp-servers.json
    set -l subcommands mcp config doctor version help update install setup-token plugin

    # Subcommands bypass wrapper options
    if contains -- $argv[1] $subcommands
        command claude $argv
        return
    end

    # Build args - interleaved thinking is on by default but explicit for API key users
    set -l args --betas interleaved-thinking-2025-05-14

    if test -f $mcp_config
        set -a args --mcp-config $mcp_config
    end

    command claude $args $argv
end

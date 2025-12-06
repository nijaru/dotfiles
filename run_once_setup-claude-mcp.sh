#!/bin/bash
# Setup Claude Code MCP servers (runs once per machine)

# Only run if claude is installed
command -v claude >/dev/null 2>&1 || exit 0

# Add Context7 if not already configured
if ! claude mcp list 2>/dev/null | grep -q "context7"; then
    claude mcp add -s user context7 -- npx -y @upstash/context7-mcp
    echo "Added Context7 MCP server"
fi

#!/bin/bash
# Setup Claude Code MCP servers (runs once per machine)
# Keys are read from shell environment via -e flag, not stored in config

# Only run if claude is installed
command -v claude >/dev/null 2>&1 || exit 0

# Add Context7 if not already configured
if ! claude mcp list 2>/dev/null | grep -q "context7"; then
    claude mcp add -s user context7 -- npx -y @upstash/context7-mcp
    echo "Added Context7 MCP server"
fi

# Add Exa if not already configured (reads EXA_API_KEY from env)
if ! claude mcp list 2>/dev/null | grep -q "exa"; then
    claude mcp add -s user exa -- npx -y exa-mcp-server -e EXA_API_KEY
    echo "Added Exa MCP server"
fi

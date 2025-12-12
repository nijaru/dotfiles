#!/bin/bash
# Setup Codex CLI config (runs once per machine)
# Only creates initial config - Codex will add to it as you use it

command -v codex >/dev/null 2>&1 || exit 0

CONFIG="$HOME/.codex/config.toml"

# Only create if doesn't exist
if [ ! -f "$CONFIG" ]; then
    mkdir -p "$HOME/.codex"
    cat > "$CONFIG" << 'TOML'
# Codex CLI Configuration

# Project doc fallback - read AGENTS.md or CLAUDE.md
project_doc_fallback_filenames = ["AGENTS.md", "CLAUDE.md", "README.md"]

# Sandbox - allow writing to omendb parent (for cross-project work)
sandbox_mode = "workspace-write"
[sandbox_workspace_write]
writable_roots = ["~/github/omendb"]

# MCP Servers
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

[mcp_servers.exa]
command = "npx"
args = ["-y", "exa-mcp-server", "-e", "EXA_API_KEY"]
TOML
    echo "Created initial Codex config"
fi

# Create AGENTS.md symlink if doesn't exist
if [ ! -e "$HOME/.codex/AGENTS.md" ]; then
    ln -s "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"
    echo "Created AGENTS.md symlink"
fi

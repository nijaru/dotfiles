#!/usr/bin/env fish
function install-agents --description "Install AI coding agents (Claude Code, Sourcegraph Amp)"
    echo "Installing AI coding agents..."
    echo ""

    set -l agents \
        "@anthropic-ai/claude-code" \
        "@sourcegraph/amp"

    for agent in $agents
        echo "Installing $agent..."
        npm install -g $agent

        if test $status -eq 0
            echo "  ✓ $agent installed successfully"
        else
            echo "  ✗ Failed to install $agent"
        end
        echo ""
    end

    echo "Verifying installations..."
    echo ""

    # Verify Claude Code
    if command -q claude
        set -l version (claude --version 2>/dev/null)
        echo "  ✓ claude: $version"
    else
        echo "  ✗ claude: not found in PATH"
    end

    # Verify Amp
    if command -q amp
        set -l version (amp --version 2>/dev/null)
        echo "  ✓ amp: $version"
    else
        echo "  ✗ amp: not found in PATH"
    end

    echo ""
    echo "Done! You may need to restart your shell."
end

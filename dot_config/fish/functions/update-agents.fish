function update-agents --description "Update AI coding agents"
    argparse f/force -- $argv

    echo "Updating AI coding agents..."
    echo ""

    # Built-in updaters (handle their own version checking)
    if command -q claude
        echo "Claude Code..."
        claude update
        echo ""
    end

    # npm packages - batch check and install
    if not command -q npm
        echo "Done!"
        return
    end

    # Package definitions: "name|npm_package|version_cmd"
    set -l packages \
        "Opencode|opencode-ai|opencode --version" \
        "Amp|@sourcegraph/amp|amp --version" \
        "Codex|@openai/codex|codex --version" \
        "Pi|@mariozechner/pi-coding-agent|pi --version" \
        "Gemini CLI|@google/gemini-cli|gemini --version"

    set -l to_update

    # Check versions (parallel npm view)
    for pkg in $packages
        set -l parts (string split "|" $pkg)
        set -l name $parts[1]
        set -l npm_pkg $parts[2]
        set -l version_cmd $parts[3]

        if not command -q (string split " " $version_cmd)[1]
            continue
        end

        if set -q _flag_force
            set -a to_update $npm_pkg
            echo "$name: forcing update"
            continue
        end

        set -l current (eval $version_cmd 2>/dev/null | string trim)
        set -l latest (npm view $npm_pkg version 2>/dev/null | string trim)

        if test -z "$latest"
            echo "$name: failed to check latest version"
        else if test "$current" != "$latest"
            echo "$name: $current -> $latest"
            set -a to_update $npm_pkg
        else
            echo "$name: up to date ($current)"
        end
    end

    # Batch install outdated packages
    if test (count $to_update) -gt 0
        echo ""
        npm install -g $to_update
    end

    echo ""
    echo "Done!"
end

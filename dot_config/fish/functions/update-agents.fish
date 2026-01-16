function update-agents --description "Update AI coding agents"
    argparse f/force -- $argv

    # Helper for pretty status
    function _status -a color label message
        set_color $color
        printf "● "
        set_color --bold $color
        printf "% -12s " "$label"
        set_color normal
        echo "$message"
    end

    echo (set_color --bold cyan)"Updating AI coding agents..."(set_color normal)
    echo ""

    # 1. Claude Code
    if command -q claude
        _status blue "Claude" "Checking..."
        set -l claude_out (claude update 2>&1)
        if test $status -eq 0
            set -l v_str (echo $claude_out | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
            _status green "Claude" "Up to date ($v_str)"
        else
            _status red "Claude" "Failed to update"
            echo $claude_out
        end
    end

    # 2. npm packages
    if not command -q npm
        _status yellow "NPM" "Not found, skipping batch updates"
        echo ""
        _status green "Done" "All tasks complete"
        return
    end

    # Package definitions: "name|npm_package|version_cmd"
    set -l packages \
        "Gemini CLI|@google/gemini-cli|gemini --version" \
        "Opencode|opencode-ai|opencode --version" \
        "Pi|@mariozechner/pi-coding-agent|pi --version" \
        "Codex|@openai/codex|codex --version" \
        "Amp|@sourcegraph/amp|amp --version"

    set -l to_update
    set -l package_names

    for pkg in $packages
        set -l parts (string split "|" $pkg)
        set -l name $parts[1]
        set -l npm_pkg $parts[2]
        set -l version_cmd $parts[3]

        if not command -q (string split " " $version_cmd)[1]
            continue
        end

        _status blue "$name" "Checking..."

        if set -q _flag_force
            set -a to_update $npm_pkg
            set -a package_names $name
            _status yellow "$name" "Forcing update"
            continue
        end

        set -l current (eval $version_cmd 2>/dev/null | string trim | grep -oE '[0-9]+(\.[0-9]+)*(-[a-zA-Z0-9]+)?' | head -n 1)
        set -l latest (npm view $npm_pkg version 2>/dev/null | string trim)

        if test -z "$latest"
            _status red "$name" "Failed to check version"
        else if test "$current" != "$latest"; and not string match -q "$current*" "$latest"
            _status yellow "$name" "$current -> $latest"
            set -a to_update $npm_pkg
            set -a package_names $name
        else
            _status green "$name" "Up to date ($current)"
        end
    end

    # Batch install
    if test (count $to_update) -gt 0
        echo ""
        _status magenta "Installing" (string join ", " $package_names)
        npm install -g $to_update --quiet --no-fund --no-audit >/dev/null 2>&1
        if test $status -eq 0
            _status green "Success" "Packages updated"
        else
            _status red "Error" "Failed to install updates"
        end
    end

    # Reshim mise if applicable
    if command -q mise
        mise reshim >/dev/null 2>&1
    end

    echo ""
    _status green "Done" "All agents updated"
end

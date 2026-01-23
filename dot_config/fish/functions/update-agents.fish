function update-agents --description "Update AI coding agents"
    argparse f/force -- $argv

    function _status -a color label message
        set_color --bold $color
        printf "$label: "
        set_color normal
        echo "$message"
    end

    set_color --bold cyan
    echo "Updating AI coding agents..."
    set_color normal

    # 1. Claude Code
    if command -q claude
        set -l claude_out (claude update 2>&1)
        if test $status -eq 0
            set -l v_str (echo $claude_out | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
            _status green "Claude" "up to date ($v_str)"
        else
            _status red "Claude" "update failed"
        end
    else
        _status yellow "Claude" "installing..."
        set -l installer (curl -fsSL https://claude.ai/install.sh)
        if test -n "$installer"; and echo "$installer" | bash
            _status green "Claude" "installed"
        else
            _status red "Claude" "install failed"
        end
    end

    # 2. JS/TS Packages via Bun
    if not command -q bun
        _status yellow "Bun" "not found, skipping JS agents"
        return
    end

    # Package definitions: "name|npm_package|cmd"
    set -l packages \
        "Gemini CLI|@google/gemini-cli|gemini" \
        "Crush|@charmland/crush|crush" \
        "Opencode|opencode-ai|opencode" \
        "Pi|@mariozechner/pi-coding-agent|pi" \
        "Codex|@openai/codex|codex" \
        "Amp|@sourcegraph/amp|amp"

    set -l to_sync
    for pkg in $packages
        set -l parts (string split "|" $pkg)
        set -l name $parts[1]
        set -l npm_pkg $parts[2]
        set -l cmd $parts[3]

        if not command -q $cmd
            _status yellow "$name" "installing..."
            set -a to_sync $npm_pkg
        else if set -q _flag_force
            _status blue "$name" "forcing update..."
            set -a to_sync $npm_pkg
        else
            set -a to_sync $npm_pkg
        end
    end

    if test (count $to_sync) -gt 0
        if bun add -g $to_sync >/dev/null 2>&1
            _status green "JS Agents" "synced"
        else
            _status red "JS Agents" "sync failed"
        end
    end

    if command -q mise
        mise reshim >/dev/null 2>&1
        _status blue "Mise" "reshimmed"
    end

    _status green "Done" "all agents updated"
end
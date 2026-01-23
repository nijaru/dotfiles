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
    else
        _status yellow "Claude" "Not installed (installing...)"
        set -l installer (curl -fsSL https://claude.ai/install.sh)
        if test -n "$installer"
            if echo "$installer" | bash
                _status green "Claude" "Successfully installed"
            else
                _status red "Claude" "Installation failed"
            end
        else
            _status red "Claude" "Failed to download installer"
        end
    end

    # 2. JS/TS Packages via Bun
    if not command -q bun
        _status yellow "Bun" "Not found, skipping JS agent updates"
        echo ""
        _status green "Done" "All tasks complete"
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
    set -l new_installs

    for pkg in $packages
        set -l parts (string split "|" $pkg)
        set -l name $parts[1]
        set -l npm_pkg $parts[2]
        set -l cmd $parts[3]

        if not command -q $cmd
            _status yellow "$name" "Installing..."
            set -a new_installs $name
            set -a to_sync $npm_pkg
        else if set -q _flag_force
            _status blue "$name" "Forcing update..."
            set -a to_sync $npm_pkg
        else
            # Silently add to the sync list
            set -a to_sync $npm_pkg
        end
    end

    # Batch sync via Bun
    if test (count $to_sync) -gt 0
        _status blue "JS Agents" "Syncing for updates..."
        if bun add -g $to_sync >/dev/null 2>&1
            _status green "JS Agents" "All agents up to date"
        else
            _status red "JS Agents" "Failed to sync packages"
        end
    end

    # Reshim mise if applicable
    if command -q mise
        mise reshim >/dev/null 2>&1
    end

    echo ""
    _status green "Done" "All agents updated"
end
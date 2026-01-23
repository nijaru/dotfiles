function update-agents --description "Update AI coding agents"
    argparse f/force -- $argv

    # Helper for pretty status (Brew/Cargo style)
    function _status -a color label message
        set_color --bold $color
        printf "%12s " "$label"
        set_color normal
        echo "$message"
    end

    echo (set_color --bold cyan)"Updating AI coding agents..."(set_color normal)
    echo ""

    # 1. Claude Code
    if command -q claude
        _status blue "Checking" "Claude Code..."
        set -l claude_out (claude update 2>&1)
        if test $status -eq 0
            set -l v_str (echo $claude_out | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
            _status green "Updated" "Claude Code ($v_str)"
        else
            _status red "Error" "Failed to update Claude"
            echo $claude_out
        end
    else
        _status yellow "Installing" "Claude Code..."
        set -l installer (curl -fsSL https://claude.ai/install.sh)
        if test -n "$installer"
            if echo "$installer" | bash
                _status green "Installed" "Claude Code"
            else
                _status red "Error" "Claude installation failed"
            end
        else
            _status red "Error" "Failed to download Claude installer"
        end
    end

    # 2. JS/TS Packages via Bun
    if not command -q bun
        _status yellow "Skipping" "JS agent updates (Bun not found)"
        echo ""
        _status green "Finished" "All tasks complete"
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
            _status yellow "Installing" "$name..."
            set -a new_installs $name
            set -a to_sync $npm_pkg
        else if set -q _flag_force
            _status blue "Forcing" "$name update..."
            set -a to_sync $npm_pkg
        else
            set -a to_sync $npm_pkg
        end
    end

    # Batch sync via Bun
    if test (count $to_sync) -gt 0
        _status cyan "Syncing" "JS Agents..."
        if bun add -g $to_sync >/dev/null 2>&1
            _status green "Finished" "JS Agents sync"
        else
            _status red "Error" "Failed to sync JS packages"
        end
    end

    # Reshim mise if applicable
    if command -q mise
        _status blue "Reshim" "Mise environments..."
        mise reshim >/dev/null 2>&1
    end

    echo ""
    _status green "Complete" "All agents updated"
end

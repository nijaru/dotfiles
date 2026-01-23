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
        # Safer curl | bash
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

    set -l to_update
    set -l package_names

    for pkg in $packages
        set -l parts (string split "|" $pkg)
        set -l name $parts[1]
        set -l npm_pkg $parts[2]
        set -l cmd $parts[3]

        if set -q _flag_force
            _status blue "$name" "Forcing update..."
            set -a to_update $npm_pkg
            set -a package_names $name
            continue
        end

        if not command -q $cmd
            _status yellow "$name" "Not installed (queuing)"
            set -a to_update $npm_pkg
            set -a package_names $name
        else
            # We skip current version calculation to save time (~500ms)
            # Bun handles the "up-to-date" check extremely fast in the batch install.
            _status blue "$name" "Queued for sync..."
            set -a to_update $npm_pkg
            set -a package_names $name
        end
    end

    # Batch install via Bun (much faster than npm)
    if test (count $to_update) -gt 0
        echo ""
        _status magenta "Syncing" (string join ", " $package_names)
        
        # bun add -g is idempotent and extremely fast
        if bun add -g $to_update >/dev/null 2>&1
            _status green "Success" "Agents synced via Bun"
        else
            _status red "Error" "Failed to sync packages"
        end
    end

    # Reshim mise if applicable
    if command -q mise
        mise reshim >/dev/null 2>&1
    end

    echo ""
    _status green "Done" "All agents updated"
end

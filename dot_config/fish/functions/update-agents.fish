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

    set -l packages \
        "@google/gemini-cli" \
        "@charmland/crush" \
        "opencode-ai" \
        "@mariozechner/pi-coding-agent" \
        "@openai/codex" \
        "@sourcegraph/amp"

    if test (count $packages) -gt 0
        set -l bun_out (bun add -g $packages 2>&1)
        if test $status -eq 0
            # Look for "installed" or package version additions (+)
            set -l changes (echo $bun_out | grep -E "installed| \+" | grep -v "bun add" | string trim)
            if test -n "$changes"
                _status green "JS Agents" "updated"
                echo "$changes" | while read -l line
                    echo "  $line"
                end
            else
                _status green "JS Agents" "up to date"
            end
        else
            _status red "JS Agents" "sync failed"
            echo $bun_out
        end
    end

    if command -q mise
        mise reshim >/dev/null 2>&1
        _status blue "Mise" "reshimmed"
    end

    _status green "Done" "all agents updated"
end

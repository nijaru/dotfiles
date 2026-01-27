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

    # Map: package -> display name
    set -l packages \
        "@google/gemini-cli:Gemini" \
        "@charmland/crush:Crush" \
        "opencode-ai:OpenCode" \
        "@mariozechner/pi-coding-agent:Pi" \
        "@openai/codex:Codex" \
        "@sourcegraph/amp:Amp"

    # Update all packages silently
    set -l pkg_names
    for entry in $packages
        set -l pkg (string split ":" $entry)[1]
        set -a pkg_names $pkg
    end
    bun add -g $pkg_names >/dev/null 2>&1

    # Report each package with version
    set -l global_list (bun pm ls -g 2>/dev/null | string collect)
    for entry in $packages
        set -l parts (string split ":" $entry)
        set -l pkg $parts[1]
        set -l name $parts[2]
        # Extract version: find line with "pkg@version", get the version part
        set -l ver (printf '%s\n' $global_list | grep -F "$pkg@" | string replace -r '.*@' '')
        if test -n "$ver"
            _status green $name $ver
        else
            _status yellow $name "not found"
        end
    end

    if command -q mise
        mise reshim >/dev/null 2>&1
        _status blue "Mise" "reshimmed"
    end

    _status green "Done" "all agents updated"
end

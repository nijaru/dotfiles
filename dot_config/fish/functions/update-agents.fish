function update-agents --description "Update AI coding agents"
    argparse f/force -- $argv

    function _status -a color label message
        set_color --bold $color
        printf "%-8s " "$label"
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

    # Helper to get version for a package
    function _get_ver -a pkg listing
        printf '%s\n' $listing | grep -F "$pkg@" | string replace -r '.*@' ''
    end

    # Capture versions before update
    set -l before_list (bun pm ls -g 2>/dev/null | string collect)

    # Build package list and update
    set -l pkg_names
    for entry in $packages
        set -l pkg (string split ":" $entry)[1]
        set -a pkg_names $pkg
    end
    bun add -g $pkg_names >/dev/null 2>&1

    # Capture versions after update
    set -l after_list (bun pm ls -g 2>/dev/null | string collect)

    # Report each package
    for entry in $packages
        set -l parts (string split ":" $entry)
        set -l pkg $parts[1]
        set -l name $parts[2]
        set -l old_ver (_get_ver $pkg $before_list)
        set -l new_ver (_get_ver $pkg $after_list)

        if test -z "$new_ver"
            _status yellow $name "not found"
        else if test -z "$old_ver"
            _status green $name "installed ($new_ver)"
        else if test "$old_ver" != "$new_ver"
            _status green $name "updated ($old_ver → $new_ver)"
        else
            _status green $name "up to date ($new_ver)"
        end
    end

    functions -e _get_ver

    if command -q mise
        mise reshim >/dev/null 2>&1
        _status blue "Mise" "reshimmed"
    end

    _status green "Done" "all agents updated"
end

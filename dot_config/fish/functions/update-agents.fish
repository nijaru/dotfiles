function update-agents --description "Update AI coding agents"
    argparse f/force -- $argv

    function _agent -a name ver
        set_color --bold white
        printf "  %-10s" "$name"
        set_color normal brblack
        echo "$ver"
        set_color normal
    end

    function _agent_updated -a name old_ver new_ver
        set_color --bold white
        printf "  %-10s" "$name"
        set_color normal brblack
        printf "%s " "$old_ver"
        set_color normal white
        printf "→ "
        set_color normal green
        echo "$new_ver"
        set_color normal
    end

    function _agent_err -a name color msg
        set_color --bold white
        printf "  %-10s" "$name"
        set_color normal $color
        echo "$msg"
        set_color normal
    end

    set_color --bold cyan
    echo "Updating AI coding agents..."
    set_color normal

    # 1. Claude Code
    if command -q claude
        set -l claude_out (claude update 2>&1)
        if test $status -eq 0
            set -l v_str (echo $claude_out | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
            _agent "Claude" "$v_str"
        else
            _agent_err "Claude" red "update failed"
        end
    else
        set -l installer (curl -fsSL https://claude.ai/install.sh)
        if test -n "$installer"; and echo "$installer" | bash
            _agent_err "Claude" green "installed"
        else
            _agent_err "Claude" red "install failed"
        end
    end

    # 2. JS/TS Packages via Bun
    if not command -q bun
        _agent_err "Bun" yellow "not found"
        return
    end

    # Map: package -> display name (alphabetical)
    set -l packages \
        "@sourcegraph/amp:Amp" \
        "@openai/codex:Codex" \
        "@charmland/crush:Crush" \
        "@google/gemini-cli:Gemini" \
        "@mariozechner/pi-coding-agent:Pi"

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
            _agent_err $name yellow "not found"
        else if test -z "$old_ver"
            _agent_updated $name "new" $new_ver
        else if test "$old_ver" != "$new_ver"
            _agent_updated $name $old_ver $new_ver
        else
            _agent $name $new_ver
        end
    end

    functions -e _get_ver _agent _agent_updated _agent_err

    command -q mise; and mise reshim >/dev/null 2>&1
end

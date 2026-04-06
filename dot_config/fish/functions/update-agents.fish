function update-agents --description "Update AI coding agents"
    function _agent -a name ver
        set_color --bold white
        printf "  %-22s" "$name"
        set_color normal brblack
        echo "$ver"
        set_color normal
    end

    function _agent_updated -a name old_ver new_ver
        set_color --bold white
        printf "  %-22s" "$name"
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
        printf "  %-22s" "$name"
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
        set -l claude_status $status
        if test $claude_status -eq 0
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
        "droid:Droid" \
        "@google/gemini-cli:Gemini" \
        "opencode-ai:OpenCode" \
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
    if not bun add -g $pkg_names >/dev/null 2>&1
        _agent_err "Bun packages" red "update failed"
        functions -e _get_ver _agent _agent_updated _agent_err
        return 1
    end

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

    functions -e _get_ver

    # 3. Third-party skills
    set_color --bold cyan
    echo ""
    echo "Updating third-party skills..."
    set_color normal

    # Format: "repo_url|source_path[:dest_name] ..."
    set -l skill_sources \
        "https://github.com/modular/skills|mojo-syntax mojo-gpu-fundamentals mojo-python-interop new-modular-project" \
        "https://github.com/huggingface/skills|skills/hf-cli skills/huggingface-community-evals skills/huggingface-datasets skills/huggingface-gradio skills/huggingface-jobs skills/huggingface-llm-trainer skills/huggingface-paper-publisher skills/huggingface-papers skills/huggingface-trackio skills/huggingface-vision-trainer skills/transformers-js"

    set -l tmp (mktemp -d)
    for entry in $skill_sources
        set -l parts (string split "|" $entry)
        set -l repo $parts[1]
        set -l skills (string split " " $parts[2])
        set -l clone_dir $tmp/(string replace -ra '.+/' '' $repo)

        set -l clone_ok false
        for attempt in 1 2 3
            if git clone --depth=1 --quiet $repo $clone_dir 2>/dev/null
                set clone_ok true
                break
            end
            rm -rf $clone_dir
        end
        if not $clone_ok
            _agent_err (string replace -ra '.+/' '' $repo) red "clone failed"
            continue
        end

        for skill_entry in $skills
            set -l skill_parts (string split ":" $skill_entry)
            set -l src_path $skill_parts[1]
            set -l dest_name (string replace -ra '.+/' '' $src_path)
            if test (count $skill_parts) -gt 1
                set dest_name $skill_parts[2]
            end

            set -l src $clone_dir/$src_path
            set -l dst ~/.claude/skills/$dest_name
            if not test -d $src
                _agent_err $dest_name yellow "not found in repo"
            else if test -d $dst; and diff -rq $src $dst >/dev/null 2>&1
                _agent $dest_name "up to date"
            else
                rm -rf $dst
                mkdir -p (dirname $dst)
                cp -r $src $dst
                chezmoi add $dst 2>/dev/null
                _agent_err $dest_name green "updated"
            end
        end
    end
    rm -rf $tmp

    functions -e _agent _agent_updated _agent_err

    command -q mise; and mise reshim >/dev/null 2>&1
end

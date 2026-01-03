#!/usr/bin/env fish
# Development environment configuration for Fish shell
# Minimal abbrs - rely on fish completions and history instead

###############################################################################
# hhg (semantic code search)
###############################################################################
if command -v hhg >/dev/null 2>&1
    # Sync .hhg index between machines via rsync
    # Usage: sync-hhg <src> <dest> [path]
    function sync-hhg
        if test (count $argv) -lt 2
            echo "Usage: sync-hhg <src> <dest> [path]"
            echo "Example: sync-hhg fedora apple ~/github/project"
            return 1
        end

        set -l src $argv[1]
        set -l dest $argv[2]
        set -l dir (test (count $argv) -ge 3; and echo $argv[3]; or pwd)
        set -l localhost (hostname -s)

        set -l rel_path (string replace -r "^$HOME/?" "" (realpath $dir 2>/dev/null; or echo $dir))
        set -l rel_path (string replace -r "^~/" "" $rel_path)

        set -l src_host (string lower (string replace -r '^.*@' '' $src))
        set -l dest_host (string lower (string replace -r '^.*@' '' $dest))
        set -l localhost_lower (string lower $localhost)
        set -l src_local (test "$src_host" = "$localhost_lower"; and echo 1; or echo 0)
        set -l dest_local (test "$dest_host" = "$localhost_lower"; and echo 1; or echo 0)

        set -l src_path (test $src_local -eq 1; and echo "$HOME/$rel_path/.hhg/"; or echo "$src:$rel_path/.hhg/")
        set -l dest_path (test $dest_local -eq 1; and echo "$HOME/$rel_path/.hhg/"; or echo "$dest:$rel_path/.hhg/")

        echo "Syncing .hhg: $src:~/$rel_path → $dest:~/$rel_path"

        if test $src_local -eq 1 -o $dest_local -eq 1
            test $dest_local -eq 1; and mkdir -p "$HOME/$rel_path"
            rsync -az --info=progress2 $src_path $dest_path
        else
            set -l tmp_dir (mktemp -d)
            rsync -az --info=progress2 $src_path "$tmp_dir/" \
                && rsync -az --info=progress2 "$tmp_dir/" $dest_path
            set -l ret $status
            rm -rf $tmp_dir
            return $ret
        end
    end
end

###############################################################################
# mise (runtime version manager)
###############################################################################
if command -v mise >/dev/null 2>&1
    mise activate fish | source
end

###############################################################################
# direnv (lazy-loaded)
###############################################################################
if command -v direnv >/dev/null 2>&1
    function __direnv_activate_if_needed
        if not set -q __direnv_activated
            eval (direnv hook fish)
            set -g __direnv_activated 1
        end
    end

    function direnv
        __direnv_activate_if_needed
        command direnv $argv
    end

    function __auto_direnv --on-variable PWD
        if test -f .envrc
            __direnv_activate_if_needed
            direnv allow .
        end
    end
end

###############################################################################
# Go (just the format helper)
###############################################################################
if command -v go >/dev/null 2>&1
    function goformat
        gofumpt | golines
    end
end

###############################################################################
# Python
###############################################################################
if command -v python3 >/dev/null 2>&1
    abbr --add py "python3"
end

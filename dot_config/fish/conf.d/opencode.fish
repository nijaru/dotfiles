#!/usr/bin/env fish
# Read OpenCode Zen API key from OpenCode's own auth store
if test -f ~/.local/share/opencode/auth.json
    set -gx OPENCODE_ZEN_API_KEY (jq -r '.opencode.key // empty' ~/.local/share/opencode/auth.json 2>/dev/null)
end

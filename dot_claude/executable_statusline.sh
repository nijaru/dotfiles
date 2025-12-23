#!/bin/bash

input=$(cat)

# Single jq call for all JSON fields
IFS=$'\t' read -r model_display cwd context_window current_usage < <(
    echo "$input" | jq -r '[
        .model.display_name // .model.id,
        .workspace.current_dir,
        .context_window.context_window_size // 200000,
        (.context_window.current_usage | if . then (.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens) else 0 end)
    ] | @tsv'
)

current_tokens=${current_usage:-0}

# Git branch (fast path first)
git_branch=""
if [ -f "$cwd/.git/HEAD" ]; then
    head_content=$(cat "$cwd/.git/HEAD" 2>/dev/null)
    if [[ "$head_content" == ref:* ]]; then
        git_branch="${head_content#ref: refs/heads/}"
    fi
fi
[ -z "$git_branch" ] && git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Format
display_cwd="$cwd"
[[ "$cwd" == "$HOME"* ]] && display_cwd="~${cwd#$HOME}"
pct=$((current_tokens * 100 / context_window))
tok="${pct}% ($((current_tokens/1000))k/$((context_window/1000))k)"

left="$model_display · $tok"
right="${git_branch:+[$git_branch] · }$display_cwd"

printf "\033[2m%s  |  %s\033[0m" "$left" "$right"

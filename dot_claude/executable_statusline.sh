#!/bin/bash

input=$(cat)

# Single jq call for all JSON fields
IFS=$'\t' read -r model_display cwd context_window transcript_path < <(
    echo "$input" | jq -r '[
        .model.display_name // .model.id,
        .workspace.current_dir,
        .context_window.context_window_size // 200000,
        .transcript_path
    ] | @tsv'
)

# Current context from transcript
current_tokens=0
if [ -f "$transcript_path" ]; then
    current_tokens=$(tail -50 "$transcript_path" | jq -s '
        [.[] | select(.type == "assistant" and .message.usage)][-1].message.usage |
        (.input_tokens // 0) + (.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0)
    ' 2>/dev/null || echo 0)
fi

# Git branch (fast path first)
git_branch=""
[ -f "$cwd/.git/HEAD" ] && git_branch=$(sed 's|^ref: refs/heads/||' "$cwd/.git/HEAD" 2>/dev/null)
[ -z "$git_branch" ] && git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Format
display_cwd="$cwd"
[[ "$cwd" == "$HOME"* ]] && display_cwd="~${cwd#$HOME}"
pct=$((current_tokens * 100 / context_window))
tok="${pct}% ($((current_tokens/1000))k/$((context_window/1000))k)"

left="$model_display · $tok"
right="${git_branch:+[$git_branch] · }$display_cwd"

printf "\033[2m%s  |  %s\033[0m" "$left" "$right"

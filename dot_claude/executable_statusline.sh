#!/bin/bash

input=$(cat)

IFS=$'\t' read -r model cwd project_dir ctx_size used_pct current_in < <(
    jq -r '[
        .model.display_name // .model.id,
        .workspace.current_dir,
        .workspace.project_dir // .workspace.current_dir,
        .context_window.context_window_size // 200000,
        .context_window.used_percentage // 0,
        (.context_window.current_usage | if . then (.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens) else 0 end)
    ] | @tsv' <<< "$input"
)

# Git branch (fast path: read .git/HEAD directly, no subprocess)
git_branch=""
if [ -f "$cwd/.git/HEAD" ]; then
    head=$(< "$cwd/.git/HEAD")
    [[ "$head" == ref:* ]] && git_branch="${head#ref: refs/heads/}"
fi
[ -z "$git_branch" ] && git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

# Context % color: green < 50, yellow 50-79, red 80+
if ((used_pct >= 80)); then pc='31'; elif ((used_pct >= 50)); then pc='33'; else pc='32'; fi

# CWD: white basename, dim relative path when in subdirectory
proj_name="${project_dir##*/}"
if [[ "$cwd" != "$project_dir" && "$cwd" == "$project_dir"/* ]]; then
    display_cwd="\033[2m${proj_name}/\033[0;37m${cwd#$project_dir/}"
elif [[ "$cwd" != "$project_dir" ]]; then
    p="$cwd"
    [[ "$p" == "$HOME"* ]] && p="~${p#$HOME}"
    display_cwd="\033[37m${p}"
else
    display_cwd="\033[37m${proj_name}"
fi

s='\033[2m • \033[0m'
printf '\033[36m%s\033[0m' "$model"
printf "${s}\033[%sm%s%%\033[0m \033[2m(%dk/%dk)\033[0m" "$pc" "$used_pct" "$((current_in/1000))" "$((ctx_size/1000))"
printf "${s}%b\033[0m" "$display_cwd"
[ -n "$git_branch" ] && printf "${s}\033[36m%s\033[0m" "$git_branch"

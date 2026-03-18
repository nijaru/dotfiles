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

# x2 usage indicator: March 13-28 2026, outside 8AM-2PM ET on weekdays
x2_suffix=""
now_epoch=$(date +%s)
promo_start=$(date -j -f "%Y-%m-%d %H:%M:%S" "2026-03-13 00:00:00" +%s 2>/dev/null || date -d "2026-03-13 00:00:00" +%s)
promo_end=$(date -j -f "%Y-%m-%d %H:%M:%S" "2026-03-28 23:59:59" +%s 2>/dev/null || date -d "2026-03-28 23:59:59" +%s)
if (( now_epoch >= promo_start && now_epoch <= promo_end )); then
    # Get current hour in ET and day of week (1=Mon..7=Sun)
    et_hour=$(TZ="America/New_York" date +%H)
    et_dow=$(TZ="America/New_York" date +%u)  # 1=Monday, 7=Sunday
    et_hour=${et_hour#0}  # strip leading zero
    # Weekday (1-5) during peak hours (8-13 = 8AM to 1:59PM, i.e. before 2PM)
    if (( et_dow >= 1 && et_dow <= 5 && et_hour >= 8 && et_hour < 14 )); then
        x2_suffix=""
    else
        x2_suffix=" \033[33m[x2]\033[0m"
    fi
fi

s='\033[2m • \033[0m'
printf '\033[36m%s\033[0m' "$model"
printf "%b" "$x2_suffix"
printf "${s}\033[%sm%s%%\033[0m \033[2m(%dk/%dk)\033[0m" "$pc" "$used_pct" "$((current_in/1000))" "$((ctx_size/1000))"
printf "${s}%b\033[0m" "$display_cwd"
[ -n "$git_branch" ] && printf "${s}\033[36m%s\033[0m" "$git_branch"

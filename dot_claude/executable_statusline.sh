#!/bin/bash

input=$(cat)

IFS=$'\t' read -r model effort cwd project_dir ctx_size used_pct current_in p5 r5 pw rw < <(
	jq -r '[
        .model.display_name // .model.id,
        (.effort_level // .effortLevel // .model.effort_level // "-"),
        .workspace.current_dir,
        .workspace.project_dir // .workspace.current_dir,
        (.context_window.context_window_size // 200000 | floor),
        (.context_window.used_percentage // 0 | floor),
        (.context_window.current_usage | if . then (.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens) else 0 end),
        (.rate_limits.five_hour.used_percentage // 0 | floor),
        (.rate_limits.five_hour.resets_at // 0 | floor),
        (.rate_limits.seven_day.used_percentage // 0 | floor),
        (.rate_limits.seven_day.resets_at // 0 | floor)
    ] | @tsv' <<<"$input"
)

# Git branch (fast path: read .git/HEAD directly, no subprocess)
git_branch=""
if [ -f "$cwd/.git/HEAD" ]; then
	head=$(<"$cwd/.git/HEAD")
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

# Peak hours indicator: weekdays 5AM-11AM PT (8AM-2PM ET), slower usage during this window
peak_suffix=""
read -r pt_hour pt_dow < <(TZ="America/Los_Angeles" date '+%H %u') # %H=hour, %u=1Mon-7Sun
pt_hour=${pt_hour#0}                                               # strip leading zero for arithmetic
# Weekday (1-5) during peak hours (5-10 = 5AM to 10:59AM, i.e. before 11AM PT)
if ((pt_dow >= 1 && pt_dow <= 5 && pt_hour >= 5 && pt_hour < 11)); then
	peak_suffix=" \033[31m[peak]\033[0m"
fi

_now=$(date +%s)
_until() { # unix timestamp -> "Xh Ym" remaining
	local secs=$(($1 - _now))
	if ((secs <= 0)); then
		printf 'soon'
	else
		local h=$((secs / 3600)) m=$(((secs % 3600) / 60))
		if ((h > 0)); then
			printf '%dh%02dm' "$h" "$m"
		else
			printf '%dm' "$m"
		fi
	fi
}

if ((p5 >= 80)); then c5=31; elif ((p5 >= 50)); then c5=33; else c5=32; fi
if ((pw >= 80)); then cw=31; elif ((pw >= 50)); then cw=33; else cw=32; fi

s='\033[2m • \033[0m'
printf '\033[36m%s\033[0m' "$model"
[ "$effort" = "-" ] && effort=$(jq -r '.effortLevel // empty' ~/.claude/settings.json 2>/dev/null)
[ -n "$effort" ] && [ "$effort" != "-" ] && printf ' \033[2m[%s]\033[0m' "$effort"
printf "%b" "$peak_suffix"
printf "${s}\033[%sm%s%%\033[0m \033[2m(%dk/%dk)\033[0m" "$pc" "$used_pct" "$((current_in / 1000))" "$((ctx_size / 1000))"
printf "${s}%b\033[0m" "$display_cwd"
[ -n "$git_branch" ] && printf "${s}\033[36m%s\033[0m" "$git_branch"
printf "${s}\033[${c5}m%d%%\033[0m \033[2m5h (%s)\033[0m" "$p5" "$(_until "$r5")"
printf "${s}\033[${cw}m%d%%\033[0m \033[2mweek (%s)\033[0m" "$pw" "$(_until "$rw")"

#!/bin/bash

# Configuration
SHOW_PERCENTAGE=true   # Set to true to show percentage
SHOW_RAW_TOKENS=true  # Set to true to show (28k/200k)
SHOW_GIT_BRANCH=true   # Set to true to show git branch

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
model_id=$(echo "$input" | jq -r '.model.id')
model_display=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Context window size from JSON (handles extended context models)
context_window=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Get current context usage from most recent API response
current_tokens=0
if [ -f "$transcript_path" ]; then
    last_usage=$(tail -50 "$transcript_path" | jq -c 'select(.type == "assistant" and .message.usage)' 2>/dev/null | tail -1)
    if [ -n "$last_usage" ]; then
        in_tok=$(echo "$last_usage" | jq -r '.message.usage.input_tokens // 0')
        cache_read=$(echo "$last_usage" | jq -r '.message.usage.cache_read_input_tokens // 0')
        cache_create=$(echo "$last_usage" | jq -r '.message.usage.cache_creation_input_tokens // 0')
        current_tokens=$((in_tok + cache_read + cache_create))
    fi
fi

# Use display_name if available, otherwise format from id
if [ -n "$model_display" ]; then
    model_name="$model_display"
else
    # Fallback: claude-sonnet-4-5-20250929 -> sonnet-4.5
    model_name=$(echo "$model_id" | sed 's/^claude-//; s/-[0-9]\{8\}$//')
    model_name=$(echo "$model_name" | sed 's/\([0-9]\)-\([0-9]\)/\1.\2/g')
fi

# Get git branch if enabled and in a git repository
git_branch=""
if [ "$SHOW_GIT_BRANCH" = true ]; then
    # Try fast path: read .git/HEAD directly (~1ms)
    if [ -f "$cwd/.git/HEAD" ]; then
        git_branch=$(sed 's|^ref: refs/heads/||' "$cwd/.git/HEAD" 2>/dev/null)
    fi
    # Fall back to git command for worktrees/detached HEAD (~10-25ms)
    if [ -z "$git_branch" ]; then
        git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
    fi
fi

# Format home directory as tilde
display_cwd="$cwd"
if [[ "$cwd" == "$HOME"* ]]; then
    display_cwd="~${cwd#$HOME}"
fi

# Calculate token usage from transcript (actual current context)
token_percentage=$((current_tokens * 100 / context_window))
current_k=$((current_tokens / 1000))
context_k=$((context_window / 1000))

# Build token info based on flags
token_info=""
if [ "$SHOW_PERCENTAGE" = true ] && [ "$SHOW_RAW_TOKENS" = true ]; then
    token_info="${token_percentage}% (${current_k}k/${context_k}k)"
elif [ "$SHOW_PERCENTAGE" = true ]; then
    token_info="${token_percentage}%"
elif [ "$SHOW_RAW_TOKENS" = true ]; then
    token_info="(${current_k}k/${context_k}k)"
fi

# Build left side: model and token info
left_side="$model_name"
if [ -n "$token_info" ]; then
    left_side="$model_name · $token_info"
fi

# Build right side: git branch and directory
right_side=""
if [ -n "$git_branch" ]; then
    right_side="[$git_branch] · $display_cwd"
else
    right_side="$display_cwd"
fi

# Format the status line with dimmed ANSI color codes
printf "\033[2m%s  |  %s\033[0m" \
    "$left_side" \
    "$right_side"

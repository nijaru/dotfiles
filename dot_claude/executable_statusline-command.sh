#!/bin/bash

# Configuration
SHOW_PERCENTAGE=true   # Set to true to show percentage
SHOW_RAW_TOKENS=true  # Set to true to show (28k/200k)
SHOW_GIT_BRANCH=true   # Set to true to show git branch

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
model_id=$(echo "$input" | jq -r '.model.id')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Format model name: claude-sonnet-4-5-20250929 -> sonnet-4.5
# Extract the model part after "claude-" and before the timestamp
model_name=$(echo "$model_id" | sed 's/^claude-//; s/-[0-9]\{8\}$//')
# Convert version format: replace hyphens between digits with dots
# sonnet-4-5 -> sonnet-4.5, haiku-5-10 -> haiku-5.10
model_name=$(echo "$model_name" | sed 's/\([0-9]\)-\([0-9]\)/\1.\2/g')

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

# Calculate token usage from transcript
token_info=""
if [ -f "$transcript_path" ]; then
    # Rough token estimation: average ~4 chars per token
    file_size=$(wc -c < "$transcript_path")
    estimated_tokens=$((file_size / 4))
elif [ -n "$transcript_path" ]; then
    # Transcript path provided but file doesn't exist yet (0 tokens)
    estimated_tokens=0
fi

# Build token info based on flags
token_info=""
if [ -n "$transcript_path" ] && { [ "$SHOW_PERCENTAGE" = true ] || [ "$SHOW_RAW_TOKENS" = true ]; }; then
    # 200k context window for current models
    context_window=200000
    token_percentage=$((estimated_tokens * 100 / context_window))
    estimated_k=$((estimated_tokens / 1000))
    context_k=$((context_window / 1000))

    # Build token info based on what's enabled
    if [ "$SHOW_PERCENTAGE" = true ] && [ "$SHOW_RAW_TOKENS" = true ]; then
        token_info="${token_percentage}% (${estimated_k}k/${context_k}k)"
    elif [ "$SHOW_PERCENTAGE" = true ]; then
        token_info="${token_percentage}%"
    elif [ "$SHOW_RAW_TOKENS" = true ]; then
        token_info="(${estimated_k}k/${context_k}k)"
    fi
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

#!/bin/bash
# Auto-format files after Write|Edit operations
# Runs silently, non-blocking (exit 0 always)

FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[[ -z "$FILE_PATH" ]] && exit 0

# Security: reject path traversal and sensitive files
[[ "$FILE_PATH" == *".."* ]] && exit 0
[[ "$FILE_PATH" == *".env"* ]] && exit 0
[[ "$FILE_PATH" == *".git/"* ]] && exit 0
[[ "$FILE_PATH" == *"node_modules/"* ]] && exit 0
[[ ! -f "$FILE_PATH" ]] && exit 0

case "$FILE_PATH" in
  *.py)
    uv run ruff format "$FILE_PATH" 2>/dev/null
    uv run ruff check --fix "$FILE_PATH" 2>/dev/null
    ;;
  *.ts|*.tsx|*.js|*.jsx|*.json)
    bun x biome format --write "$FILE_PATH" 2>/dev/null
    ;;
  *.md)
    bun x prettier --write "$FILE_PATH" 2>/dev/null
    ;;
  *.go)
    golines --base-formatter gofumpt -w "$FILE_PATH" 2>/dev/null
    ;;
  *.rs)
    rustfmt "$FILE_PATH" 2>/dev/null
    ;;
  *.mojo|*.🔥)
    mojo format "$FILE_PATH" 2>/dev/null
    ;;
esac

exit 0

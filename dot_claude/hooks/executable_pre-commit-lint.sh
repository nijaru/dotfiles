#!/bin/bash
# Pre-commit lint - auto-fix then check
# Exit 2 = block with feedback to Claude
# Exit 0 = allow commit

COMMAND=$(jq -r '.tool_input.command // empty' 2>/dev/null)

# Only intercept git commit commands
[[ ! "$COMMAND" =~ git[[:space:]]+commit ]] && exit 0

# Get staged files
STAGED=$(git diff --cached --name-only 2>/dev/null)
[[ -z "$STAGED" ]] && exit 0

ERRORS=""
FIXED=false

# Python
if echo "$STAGED" | grep -q '\.py$'; then
  # Auto-fix
  uv run ruff check --fix . 2>/dev/null && FIXED=true
  uv run ruff format . 2>/dev/null && FIXED=true
  # Check remaining
  LINT=$(uv run ruff check . 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Python errors:\n$LINT\n\n"
  fi
fi

# Rust
if echo "$STAGED" | grep -q '\.rs$'; then
  # Auto-fix (clippy suggestions)
  cargo clippy --fix --allow-dirty --allow-staged 2>/dev/null && FIXED=true
  cargo fmt 2>/dev/null && FIXED=true
  # Check remaining
  LINT=$(cargo clippy --message-format=short 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Rust errors:\n$LINT\n\n"
  fi
fi

# TypeScript/JavaScript
if echo "$STAGED" | grep -qE '\.(ts|tsx|js|jsx)$'; then
  if [[ -f "biome.json" ]]; then
    # Auto-fix
    bun x biome check --write . 2>/dev/null && FIXED=true
    # Check remaining
    LINT=$(bun x biome check . 2>&1)
    [[ $? -ne 0 ]] && ERRORS+="TypeScript/JS errors:\n$LINT\n\n"
  elif [[ -f "eslint.config.js" ]] || [[ -f ".eslintrc.json" ]]; then
    # Auto-fix
    bun x eslint --fix . 2>/dev/null && FIXED=true
    bun x prettier --write . 2>/dev/null && FIXED=true
    # Check remaining
    LINT=$(bun x eslint . 2>&1)
    [[ $? -ne 0 ]] && ERRORS+="TypeScript/JS errors:\n$LINT\n\n"
  else
    # No config, just format
    bun x prettier --write . 2>/dev/null && FIXED=true
  fi
fi

# Go
if echo "$STAGED" | grep -q '\.go$'; then
  # Auto-fix (format only, vet has no auto-fix)
  golines --base-formatter gofumpt -w . 2>/dev/null && FIXED=true
  # Check remaining
  LINT=$(go vet ./... 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Go errors:\n$LINT\n\n"
  fi
fi

# Mojo
if echo "$STAGED" | grep -qE '\.(mojo|🔥)$'; then
  # Auto-fix (format)
  mojo format . 2>/dev/null && FIXED=true
  # Check remaining
  LINT=$(mojo check . 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Mojo errors:\n$LINT\n\n"
  fi
fi

# Re-stage fixed files
if [[ "$FIXED" == true ]]; then
  git add -u 2>/dev/null
fi

if [[ -n "$ERRORS" ]]; then
  echo -e "Unfixable errors (auto-fix was attempted):\n\n$ERRORS" >&2
  exit 2
fi

exit 0

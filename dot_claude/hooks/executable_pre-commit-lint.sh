#!/bin/bash
# Pre-commit lint check - blocks commit if lint errors found
# Exit 2 = block with feedback to Claude
# Exit 0 = allow commit

COMMAND=$(jq -r '.tool_input.command // empty' 2>/dev/null)

# Only intercept git commit commands
[[ ! "$COMMAND" =~ git[[:space:]]+commit ]] && exit 0

# Get staged files
STAGED=$(git diff --cached --name-only 2>/dev/null)
[[ -z "$STAGED" ]] && exit 0

ERRORS=""

# Python
if echo "$STAGED" | grep -q '\.py$'; then
  LINT=$(uv run ruff check . 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Python lint errors:\n$LINT\n\n"
  fi
fi

# Rust
if echo "$STAGED" | grep -q '\.rs$'; then
  LINT=$(cargo clippy --message-format=short 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Rust clippy errors:\n$LINT\n\n"
  fi
fi

# TypeScript/JavaScript
if echo "$STAGED" | grep -qE '\.(ts|tsx|js|jsx)$'; then
  if [[ -f "biome.json" ]]; then
    LINT=$(bun x biome check . 2>&1)
  elif [[ -f "eslint.config.js" ]] || [[ -f ".eslintrc.json" ]]; then
    LINT=$(bun x eslint . 2>&1)
  fi
  if [[ $? -ne 0 && -n "$LINT" ]]; then
    ERRORS+="TypeScript/JS lint errors:\n$LINT\n\n"
  fi
fi

# Go
if echo "$STAGED" | grep -q '\.go$'; then
  LINT=$(go vet ./... 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Go vet errors:\n$LINT\n\n"
  fi
fi

# Mojo
if echo "$STAGED" | grep -qE '\.(mojo|🔥)$'; then
  LINT=$(mojo check . 2>&1)
  if [[ $? -ne 0 ]]; then
    ERRORS+="Mojo errors:\n$LINT\n\n"
  fi
fi

if [[ -n "$ERRORS" ]]; then
  echo -e "Fix lint errors before committing:\n\n$ERRORS" >&2
  exit 2
fi

exit 0

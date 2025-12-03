#!/bin/bash
# Pre-commit lint - auto-fix then check
# Exit 2 = block with feedback to Claude
# Exit 0 = allow commit

COMMAND=$(jq -r '.tool_input.command // empty' 2>/dev/null)
[[ ! "$COMMAND" =~ git[[:space:]]+commit ]] && exit 0

# Get staged files, excluding sensitive paths
STAGED=$(git diff --cached --name-only 2>/dev/null | grep -vE '(\.env|\.git/|node_modules/)')
[[ -z "$STAGED" ]] && exit 0

# Parse staged file types once
HAS_PY=$(echo "$STAGED" | grep -c '\.py$' || true)
HAS_RS=$(echo "$STAGED" | grep -c '\.rs$' || true)
HAS_TS=$(echo "$STAGED" | grep -cE '\.(ts|tsx|js|jsx)$' || true)
HAS_GO=$(echo "$STAGED" | grep -c '\.go$' || true)
HAS_MOJO=$(echo "$STAGED" | grep -cE '\.(mojo|🔥)$' || true)

ERRORS=""

# Python: format + lint + type check
if [[ $HAS_PY -gt 0 ]]; then
  uv run ruff check --fix . 2>/dev/null
  uv run ruff format . 2>/dev/null
  LINT=$(uv run ruff check . 2>&1)
  [[ $? -ne 0 ]] && ERRORS+="Python (ruff):\n$LINT\n\n"

  # Type checking with ty (non-blocking warning for now)
  TYPE_ERRORS=$(uvx ty check . 2>&1)
  if [[ $? -ne 0 ]]; then
    # Only block on actual errors, not warnings
    if echo "$TYPE_ERRORS" | grep -q "error:"; then
      ERRORS+="Python (types):\n$TYPE_ERRORS\n\n"
    fi
  fi
fi

# Rust: format + clippy
if [[ $HAS_RS -gt 0 ]]; then
  cargo clippy --fix --allow-dirty --allow-staged 2>/dev/null
  cargo fmt 2>/dev/null
  LINT=$(cargo clippy --message-format=short 2>&1)
  [[ $? -ne 0 ]] && ERRORS+="Rust:\n$LINT\n\n"
fi

# TypeScript/JavaScript - biome preferred
if [[ $HAS_TS -gt 0 ]]; then
  if [[ -f "biome.json" ]] || [[ -f "biome.jsonc" ]]; then
    bun x biome check --write --unsafe . 2>/dev/null
    LINT=$(bun x biome check . 2>&1)
    [[ $? -ne 0 ]] && ERRORS+="TypeScript/JS:\n$LINT\n\n"
  elif [[ -f "eslint.config.js" ]] || [[ -f ".eslintrc.json" ]]; then
    bun x eslint --fix . 2>/dev/null
    LINT=$(bun x eslint . 2>&1)
    [[ $? -ne 0 ]] && ERRORS+="TypeScript/JS:\n$LINT\n\n"
  else
    bun x biome format --write . 2>/dev/null
  fi
fi

# Go: format + vet + staticcheck
if [[ $HAS_GO -gt 0 ]]; then
  golines --base-formatter gofumpt -w . 2>/dev/null
  LINT=$(go vet ./... 2>&1)
  [[ $? -ne 0 ]] && ERRORS+="Go (vet):\n$LINT\n\n"

  # staticcheck if available
  if command -v staticcheck &>/dev/null; then
    STATIC=$(staticcheck ./... 2>&1)
    [[ $? -ne 0 ]] && ERRORS+="Go (staticcheck):\n$STATIC\n\n"
  fi
fi

# Mojo: format + check
if [[ $HAS_MOJO -gt 0 ]]; then
  mojo format . 2>/dev/null
  LINT=$(mojo check . 2>&1)
  [[ $? -ne 0 ]] && ERRORS+="Mojo:\n$LINT\n\n"
fi

# Re-stage any fixed files
git add -u 2>/dev/null

if [[ -n "$ERRORS" ]]; then
  echo -e "Unfixable errors:\n\n$ERRORS" >&2
  exit 2
fi

exit 0

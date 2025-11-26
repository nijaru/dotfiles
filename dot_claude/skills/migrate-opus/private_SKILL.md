---
name: migrate-opus
description: "Migrate code and prompts from Claude Sonnet 4.x or Opus 4.1 to Opus 4.5. Use when user asks to update model versions, migrate to newer Claude models, or fix Opus 4.5 compatibility issues."
---

# Migrate to Claude Opus 4.5

Migrate the codebase to use Claude Opus 4.5. Update:

1. **Model strings**: Replace `claude-sonnet-4-*`, `claude-opus-4-1-*` with `claude-opus-4-5-20250929`
2. **Beta headers**: Remove deprecated beta headers, update API parameters
3. **Configuration files**: Update any hardcoded model references

## Common patterns to find and replace

```
claude-sonnet-4-20250514 → claude-opus-4-5-20250929
claude-opus-4-1-20250507 → claude-opus-4-5-20250929
```

Search for patterns like:
- `model.*claude`
- `ANTHROPIC_MODEL`
- `anthropic.*model`

---
description: Deep research on a topic using web, docs, and code search
argument-hint: "<topic>"
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, mcp__exa__web_search_exa, mcp__exa__get_code_context_exa, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__parallel__web_search_preview, mcp__parallel__web_fetch
---

Research the given topic thoroughly using all available sources.

$ARGUMENTS

---

## Sources (Query in Parallel)

### 1. Web Search (General)

- Current best practices
- Recent articles/discussions (2024-2025)
- Official announcements

### 2. Code Context (Exa)

- Library/SDK documentation
- API examples
- Implementation patterns

### 3. Library Docs (Context7)

- Resolve library ID first
- Fetch focused documentation
- Code snippets

### 4. Codebase (Local)

- How does this project currently handle it?
- Existing patterns to follow

---

## Process

1. **Parallel search**: Hit all sources simultaneously
2. **Filter noise**: Prioritize official docs, recent content, high-quality sources
3. **Synthesize**: Combine findings into actionable summary
4. **Cite sources**: Include links for reference

---

## Output Format

```markdown
# Research: [Topic]

## Summary

[2-3 sentence TL;DR]

## Key Findings

### Best Practices

- [Finding 1]
- [Finding 2]

### Options Considered

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A      | ...  | ...  |
| B      | ...  | ...  |

### Recommended Approach

[What to do and why]

## Code Examples

[Relevant snippets if applicable]

## Sources

- [Title](url)
- [Title](url)
```

---

## When to Use

- Before implementing unfamiliar feature
- Evaluating libraries/tools
- Understanding state of the art
- Finding best practices for a pattern

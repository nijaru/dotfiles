---
name: research
description: >
  Auto-triggers deep research when user needs to understand best practices,
  evaluate options, or learn about unfamiliar technology before implementing.
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, mcp__exa__web_search_exa, mcp__exa__get_code_context_exa, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__parallel__web_search_preview, mcp__parallel__web_fetch
---

# Research Skill

Auto-triggers research when context suggests user needs information before proceeding.

## Activation Triggers

- "what's the best way to..."
- "how should I implement..."
- "state of the art for..."
- "what are the options for..."
- "which library should I use for..."
- "best practices for..."
- "how do others handle..."
- Before implementing unfamiliar patterns/technologies

## Execution

Scale depth to topic complexity (see `/research`):

| Question                | Depth                          |
| ----------------------- | ------------------------------ |
| "which JSON lib?"       | Quick — 1-2 searches, pick one |
| "how to handle auth?"   | Medium — options table         |
| "architect this system" | Deep — full analysis           |

**Assess first**: How consequential? How many options? Then scale effort.

## When NOT to Auto-Trigger

- User already knows what they want (just asking to implement)
- Simple factual question (use knowledge directly)
- User says "just do it" or "skip research"

## Output

Same format as `/research`:

- Summary (TL;DR)
- Key findings
- Options table (if comparing)
- Recommended approach
- Code examples
- Sources with links

---
name: gemini
description: Use ONLY when explicitly asked to consult or invoke the Gemini CLI tool for a second opinion. Do NOT trigger when the word "gemini" appears in conversation as a model name or topic.
allowed-tools: Bash, Read, Grep, Glob
---

# Gemini (Second Opinion)

Use when you want a different model's perspective on a specific problem — logic bugs, architecture tradeoffs, subtle correctness issues. Different models have different blind spots.

## When to use

- Stuck on a bug and want a fresh set of eyes
- Want to validate an architectural decision
- Reviewing code where cross-file correctness matters

## Prompt structure for signal

Be specific. Vague prompts get generic responses.

```bash
# Pipe relevant files with a concrete question
cat src/a.rs src/b.rs | gemini "Does set() behave correctly when called twice with the same key? Trace the ownership path."

# Define invariants to check
cat src/store.rs | gemini "Verify: (1) no double-free on drop, (2) iterator never yields stale data, (3) resize preserves insertion order"
```

## Output

```bash
# Save response
gemini "prompt" > /tmp/gemini-reply.txt 2>/dev/null
```

Keep prompts surgical — one question, specific invariants, `file:line` references requested.

---
name: gemini
description: Use when needing a second opinion from Gemini for code review, debugging, or architectural analysis. Ideal for piping entire modules or codebases into a 2M token context window.
allowed-tools: Bash, Read, Grep, Glob
---

# Gemini (Contextual Review)

## 🎯 Core Mandates

- **Context Mastery:** Leverage the 2M+ token window by piping entire modules or directories (e.g., `cat src/*.rs | gemini`).
- **Precision:** Provide specific invariants for verification to avoid generic AI responses.
- **Directness:** Use piping for targeted review of specific file sets rather than autonomous repo walking.

## 📋 Execution Patterns

### 1. Targeted Review
```bash
# Pipe a file for review
cat src/file.rs | gemini "Correctness review — identify data loss bugs"

# Pipe multiple related files
cat src/a.rs src/b.rs | gemini "Review interaction between these components"
```

### 2. Module Analysis
```bash
# Analyze entire subsystem
cat src/vector/store/*.rs | gemini "Architecture and correctness review"

# Full source tree analysis
find src -name "*.rs" | xargs cat | gemini "Identify coupling issues and missing abstractions"
```

### 3. Output Management
```bash
# Save response to file
gemini "Your prompt" > /tmp/gemini-reply.txt 2>/dev/null

# JSON output for automation
gemini -o json "Your prompt" 2>/dev/null | jq -r .response
```

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "The current agent already reviewed it." | Gemini's massive context window provides a superior bird's-eye view of inter-module dependencies. |
| "It's too much data to pipe manually." | `find ... | xargs cat` is trivial and faster than manual selection or autonomous walking. |
| "I'll just use the default chat." | Default chats have smaller context limits and may lose track of distant file relationships. |

## 🛠️ Performance Standards

- **Invariants:** Always define 3+ specific invariants for Gemini to check.
- **Formatting:** Request findings with `file:line` references.
- **Parallelism:** Use `jb` to run Gemini reviews in parallel with other tools.
